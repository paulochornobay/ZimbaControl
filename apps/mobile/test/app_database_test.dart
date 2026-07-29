import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:zimba_control/src/application/dashboard_summary.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/infrastructure/notification_capture_service.dart';
import 'package:zimba_control/src/presentation/dashboard_page.dart';
import 'package:zimba_control/src/presentation/movements_page.dart';

void main() {
  test('formatBrl formats integer cents as Brazilian currency text', () {
    expect(formatBrl(1280000), 'R\$ 12.800,00');
    expect(formatBrl(-48732), '-R\$ 487,32');
  });

  test('seedIfEmpty creates the first offline dashboard records', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final transactions = await database.watchRecentTransactions().first;
    final pending = await database.watchPendingReview().first;
    final people = await database.watchPeople().first;
    final inbox = await database.watchOpenReviewInbox().first;
    final categories = await database.listCategories();
    final costCenters = await database.listCostCenters();

    expect(transactions, hasLength(7));
    expect(pending, hasLength(2));
    expect(people.map((person) => person.displayName), contains('Sofia'));
    expect(inbox, hasLength(2));
    expect(categories.map((category) => category.name), contains('Saude'));
    expect(costCenters.map((center) => center.name), contains('Filhos'));
  });

  test(
    'family structure seed registers owners, auth, recurrence and consortium',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      await database.seedIfEmpty();

      final structure = await database.getFamilyStructureSnapshot();

      expect(
        structure.accounts.map(
          (item) => '${item.account.id}:${item.ownerLabel}',
        ),
        containsAll(['mp:Voce', 'nu:Voce', 'marina-conta:Marina']),
      );
      expect(
        structure.creditCards.map((item) => item.ownerLabel),
        contains('Voce'),
      );
      expect(
        structure.authUsers.map(
          (user) => '${user.email}:${user.linkedPersonId}',
        ),
        contains('teste@zimbacontrol.local:eu'),
      );
      expect(
        structure.recurringSchedules.map((schedule) => schedule.id),
        containsAll([
          'rec-escola-sofia',
          'rec-pensao-sofia',
          'rec-ajuda-marina',
        ]),
      );
      expect(
        structure.installmentPlans.map((plan) => plan.id),
        contains('plan-consorcio-carro'),
      );

      final consortium = structure.installmentPlans.firstWhere(
        (plan) => plan.id == 'plan-consorcio-carro',
      );

      expect(consortium.planKind, 'vehicle_consortium');
      expect(consortium.currentInstallment, 18);
      expect(consortium.totalInstallments, 72);
    },
  );

  test('family transfers do not inflate income or expenses', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final before = buildDashboardSummary(
      await database.watchRecentTransactions().first,
    );

    final transferId = await database.createInternalTransfer(
      fromAccountId: 'mp',
      toAccountId: 'marina-conta',
      amountCents: 100000,
      description: 'Reforco do mes para Marina',
      payerPersonId: 'eu',
      beneficiaryPersonId: 'marina',
    );

    final afterTransactions = await database.watchRecentTransactions().first;
    final after = buildDashboardSummary(afterTransactions);
    final transfer = await database.getTransaction(transferId);

    expect(after.incomeCents, before.incomeCents);
    expect(after.expenseCents, before.expenseCents);
    expect(transfer?.kind, 'transfer');
    expect(transfer?.amountCents, -100000);
    expect(transfer?.transferFromAccountId, 'mp');
    expect(transfer?.transferToAccountId, 'marina-conta');
    expect(transfer?.payerId, 'eu');
  });

  test('operational dashboard summary groups month data', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final details = await database.watchAllTransactionDetails().first;
    final structure = await database.getFamilyStructureSnapshot();
    final summary = buildOperationalDashboardSummary(
      details: details,
      recurringSchedules: structure.recurringSchedules,
      installmentPlans: structure.installmentPlans,
    );

    expect(summary.incomeCents, 1370000);
    expect(summary.expenseCents, -285222);
    expect(summary.pendingCount, 2);
    expect(summary.transferCount, 1);
    expect(summary.futureCommitmentCents, greaterThan(500000));
    expect(summary.byPerson.map((item) => item.label), contains('Sofia'));
    expect(
      summary.byCategory.map((item) => item.label),
      containsAll(['Renda', 'Educacao']),
    );
    expect(summary.bySource.map((item) => item.label), contains('Manual'));
  });

  test('movement filters search by person and source', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final details = await database.watchAllTransactionDetails().first;
    final byPerson = filterMovementDetails(
      items: details,
      query: 'sofia',
      kindFilter: 'all',
      statusFilter: 'all',
      sourceFilter: 'all',
      currentMonthOnly: true,
    );
    final byNotification = filterMovementDetails(
      items: details,
      query: '',
      kindFilter: 'expense',
      statusFilter: 'pending',
      sourceFilter: 'notification',
      currentMonthOnly: true,
    );

    expect(
      byPerson.map((item) => item.transaction.descriptionRaw),
      containsAll(['Escola Sofia mensalidade', 'Pensao Sofia']),
    );
    expect(
      byNotification.map((item) => item.transaction.id),
      containsAll(['tx-mercado', 'tx-farmacia']),
    );
  });

  test('pension and school are tied to the child financial context', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final pension = await database.getTransaction('tx-pensao-sofia');
    final school = await database.getTransaction('tx-escola');
    final pensionSchedule = (await database.listRecurringSchedules())
        .firstWhere((schedule) => schedule.id == 'rec-pensao-sofia');
    final schoolSchedule = (await database.listRecurringSchedules()).firstWhere(
      (schedule) => schedule.id == 'rec-escola-sofia',
    );

    expect(pension?.kind, 'income');
    expect(pension?.amountCents, 90000);
    expect(pension?.costCenterId, 'filhos');
    expect(pensionSchedule.beneficiaryPersonId, 'sofia');
    expect(school?.kind, 'expense');
    expect(school?.recurringScheduleId, 'rec-escola-sofia');
    expect(schoolSchedule.beneficiaryPersonId, 'sofia');
  });

  test('CSV import stages rows and promotes valid records to review', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final csv = [
      'Data;Descricao;Valor;Identificador',
      '2026-07-22;Mercado CSV;-10,50;csv-1',
      '2026-07-23;Receita CSV;250,00;csv-2',
      'invalida;Sem valor;x;csv-3',
    ].join('\n');

    final details = await database.importStatementFile(
      fileName: 'nubank_julho.csv',
      bytes: utf8.encode(csv),
    );

    expect(details.batch.totalRows, 3);
    expect(details.batch.reviewRows, 2);
    expect(details.batch.invalidRows, 1);
    expect(details.batch.duplicateRows, 0);
    expect(
      details.records.map((record) => record.status),
      containsAll(['needs_review', 'invalid']),
    );

    final promoted = await database.promoteImportBatchToReview(
      details.batch.id,
    );
    final pending = await database.watchPendingReview().first;
    final promotedDetails = await database.getLatestImportBatchDetails();

    expect(promoted, 2);
    expect(promotedDetails?.batch.reviewRows, 0);
    expect(
      pending.map((transaction) => transaction.descriptionRaw),
      containsAll(['Mercado CSV', 'Receita CSV']),
    );
  });

  test('reimporting the same statement marks rows as duplicates', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final csv = [
      'Data;Descricao;Valor;Identificador',
      '2026-07-22;Mercado CSV;-10,50;csv-1',
      '2026-07-23;Receita CSV;250,00;csv-2',
    ].join('\n');

    final first = await database.importStatementFile(
      fileName: 'nubank_julho.csv',
      bytes: utf8.encode(csv),
    );
    await database.promoteImportBatchToReview(first.batch.id);

    final second = await database.importStatementFile(
      fileName: 'nubank_julho.csv',
      bytes: utf8.encode(csv),
    );

    expect(second.batch.reviewRows, 0);
    expect(second.batch.duplicateRows, 2);
    expect(
      second.records.map((record) => record.status),
      everyElement('duplicate'),
    );
  });

  test(
    'statement row can merge with an existing notification transaction',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      await database.seedIfEmpty();
      final today = DateTime.now();
      final todayText =
          '${today.year.toString().padLeft(4, '0')}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';
      final csv = [
        'Data;Descricao;Valor;Identificador',
        '$todayText;Mercado Extra;-487,32;csv-mercado-extra',
      ].join('\n');

      final details = await database.importStatementFile(
        fileName: 'nubank_julho.csv',
        bytes: utf8.encode(csv),
      );
      final candidates = await database.listDuplicateCandidates();

      expect(details.batch.reviewRows, 0);
      expect(details.batch.duplicateRows, 1);
      expect(details.records.single.status, 'merge_candidate');
      expect(details.records.single.duplicateOfTransactionId, 'tx-mercado');
      expect(candidates.single.transactionId, 'tx-mercado');
      expect(candidates.single.explanation, contains('valor igual'));

      final promoted = await database.promoteImportBatchToReview(
        details.batch.id,
      );
      final sources = await database.listTransactionSources('tx-mercado');
      final refreshed = await database.listStagedRecords(details.batch.id);

      expect(promoted, 0);
      expect(refreshed.single.status, 'merged');
      expect(sources.map((source) => source.sourceKind), contains('csv'));
    },
  );

  test(
    'import promotion classifies invoice, installments and consortium',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      await database.seedIfEmpty();
      final today = DateTime.now();
      final todayText =
          '${today.year.toString().padLeft(4, '0')}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';
      final csv = [
        'Data;Descricao;Valor;Identificador',
        '$todayText;Pagamento fatura Nubank;-1200,00;fat-1',
        '$todayText;Loja Moveis 02/10;-89,90;parc-1',
        '$todayText;Consorcio administradora auto;-985,00;cons-1',
      ].join('\n');

      final details = await database.importStatementFile(
        fileName: 'mercado_pago_julho.csv',
        bytes: utf8.encode(csv),
      );
      await database.promoteImportBatchToReview(details.batch.id);

      final pending = await database.watchPendingReview().first;
      final invoice = pending.firstWhere(
        (tx) => tx.descriptionRaw == 'Pagamento fatura Nubank',
      );
      final installment = pending.firstWhere(
        (tx) => tx.descriptionRaw == 'Loja Moveis 02/10',
      );
      final consortium = pending.firstWhere(
        (tx) => tx.descriptionRaw == 'Consorcio administradora auto',
      );
      final structure = await database.getFamilyStructureSnapshot();
      final cardPlan = structure.installmentPlans.firstWhere(
        (plan) => plan.id == installment.installmentPlanId,
      );

      expect(invoice.kind, 'transfer');
      expect(invoice.transferFromAccountId, 'mp');
      expect(invoice.transferToAccountId, 'nu');
      expect(cardPlan.planKind, 'credit_card_purchase');
      expect(cardPlan.currentInstallment, 2);
      expect(cardPlan.totalInstallments, 10);
      expect(consortium.installmentPlanId, 'plan-consorcio-carro');
      expect(consortium.categoryId, 'transporte');
    },
  );

  test('raw notification capture creates a review draft', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();
    final now = DateTime.now();
    await database.recordRawNotificationEvent(
      CapturedNotificationEvent(
        id: 'notification-pix-1',
        packageName: 'com.mercadopago.wallet',
        appLabel: 'Mercado Pago',
        title: 'Pagamento aprovado',
        text: 'Voce pagou R\$ 42,10 no Pix',
        bigText: 'Voce pagou R\$ 42,10 no Pix para Padaria Central',
        notificationId: 10,
        tag: 'pix',
        postedAt: now,
        capturedAt: now,
      ),
    );

    final drafts = await database.processPendingRawNotificationEvents();
    final pending = await database.watchPendingReview().first;
    final rawEvents = await database.listRawNotificationEvents();
    final draft = pending.firstWhere(
      (tx) => tx.descriptionRaw == 'Pagamento aprovado',
    );
    final sources = await database.listTransactionSources(draft.id);

    expect(drafts, 1);
    expect(draft.amountCents, -4210);
    expect(draft.accountId, 'mp');
    expect(rawEvents.first.status, 'draft_created');
    expect(sources.single.notificationKey, 'notification-pix-1');
  });

  test('raw notification can merge with an existing transaction', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();
    final now = DateTime.now();
    await database.recordRawNotificationEvent(
      CapturedNotificationEvent(
        id: 'notification-mercado-extra',
        packageName: 'com.nu.production',
        appLabel: 'Nubank',
        title: 'Mercado Extra',
        text: 'Compra aprovada de R\$ 487,32',
        notificationId: 11,
        tag: 'card',
        postedAt: now,
        capturedAt: now,
      ),
    );

    final drafts = await database.processPendingRawNotificationEvents();
    final rawEvents = await database.listRawNotificationEvents();
    final sources = await database.listTransactionSources('tx-mercado');
    final candidates = await database.listDuplicateCandidates();

    expect(drafts, 0);
    expect(rawEvents.first.status, 'merged');
    expect(
      sources.map((source) => source.notificationKey),
      contains('notification-mercado-extra'),
    );
    expect(
      candidates.map((candidate) => candidate.status),
      contains('auto_merged'),
    );
  });

  test('review actions update local transaction state and outbox', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();
    await database.markProbableDuplicate('tx-mercado');
    await database.confirmTransaction('tx-mercado');

    final transaction = await database.getTransaction('tx-mercado');
    final pending = await database.watchPendingReview().first;
    final inbox = await database.watchOpenReviewInbox().first;

    expect(transaction?.reviewStatus, 'confirmed');
    expect(transaction?.duplicateStatus, 'probable');
    expect(pending.map((tx) => tx.id), isNot(contains('tx-mercado')));
    expect(
      inbox.map((item) => item.transactionId),
      isNot(contains('tx-mercado')),
    );
  });

  test('watchPendingReviewDetails hydrates review metadata', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final details = await database.watchPendingReviewDetails().first;
    final mercado = details.firstWhere(
      (item) => item.transaction.id == 'tx-mercado',
    );

    expect(mercado.displayMerchant, 'Mercado Extra');
    expect(mercado.accountLabel, 'Nubank');
    expect(mercado.categoryLabel, 'Alimentacao');
    expect(mercado.costCenterLabel, 'Casa');
    expect(mercado.sourceLabel, 'Notificacao');
    expect(mercado.providerLabel, 'Nubank');
    expect(
      mercado.beneficiaries.map((person) => person.displayName),
      containsAll(['Voce', 'Marina', 'Sofia', 'Bebe']),
    );
  });

  test('review filter preference is stored locally', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.setReviewFilter('low_confidence');

    expect(await database.watchReviewFilter().first, 'low_confidence');
  });

  test('duplicate and transfer review actions can be undone', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final duplicateSnapshot = await database.captureReviewSnapshot(
      'tx-mercado',
    );
    await database.markDuplicateAndResolve('tx-mercado');

    var mercado = await database.getTransaction('tx-mercado');
    var pending = await database.watchPendingReview().first;

    expect(mercado?.reviewStatus, 'ignored');
    expect(mercado?.duplicateStatus, 'duplicate');
    expect(pending.map((tx) => tx.id), isNot(contains('tx-mercado')));

    await database.restoreReviewSnapshot(duplicateSnapshot!);

    mercado = await database.getTransaction('tx-mercado');
    pending = await database.watchPendingReview().first;

    expect(mercado?.reviewStatus, 'pending');
    expect(mercado?.duplicateStatus, 'none');
    expect(pending.map((tx) => tx.id), contains('tx-mercado'));

    final transferSnapshot = await database.captureReviewSnapshot(
      'tx-farmacia',
    );
    await database.convertToTransfer('tx-farmacia');

    var farmacia = await database.getTransaction('tx-farmacia');

    expect(farmacia?.kind, 'transfer');
    expect(farmacia?.reviewStatus, 'confirmed');
    expect(farmacia?.categoryId, isNull);
    expect(farmacia?.costCenterId, isNull);

    await database.restoreReviewSnapshot(transferSnapshot!);

    farmacia = await database.getTransaction('tx-farmacia');

    expect(farmacia?.kind, 'expense');
    expect(farmacia?.reviewStatus, 'pending');
    expect(farmacia?.categoryId, 'saude');
    expect(farmacia?.costCenterId, 'filhos');
  });

  test('updateTransactionCore edits the local canonical transaction', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();
    await database.updateTransactionCore(
      id: 'tx-farmacia',
      description: 'Farmacia editada',
      amountCents: -12000,
      kind: 'expense',
      categoryId: 'saude',
      costCenterId: 'pessoal',
    );

    final transaction = await database.getTransaction('tx-farmacia');

    expect(transaction?.descriptionRaw, 'Farmacia editada');
    expect(transaction?.amountCents, -12000);
    expect(transaction?.costCenterId, 'pessoal');
  });
}
