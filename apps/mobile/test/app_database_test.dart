import 'package:drift/native.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:zimba_control/src/application/dashboard_summary.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/infrastructure/api_sync_client.dart';
import 'package:zimba_control/src/infrastructure/notification_capture_service.dart';
import 'package:zimba_control/src/presentation/dashboard_page.dart';
import 'package:zimba_control/src/presentation/movements_page.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('formatBrl formats integer cents as Brazilian currency text', () {
    expect(formatBrl(1280000), 'R\$ 12.800,00');
    expect(formatBrl(-48732), '-R\$ 487,32');
  });

  test('new local database starts empty until demo is explicit', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    final status = await database.getLocalDataStatus();

    expect(status.isEmpty, isTrue);
    expect(await database.watchAllTransactions().first, isEmpty);
    expect(await database.watchPeople().first, isEmpty);
    expect(await database.listCategories(), isEmpty);
  });

  test(
    'initial setup creates real defaults without demo transactions',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      await database.saveInitialSetup(
        const SetupInput(
          personName: 'Paulo',
          accountName: 'Conta principal',
          accountProvider: 'nubank',
        ),
      );

      final startup = await database.getStartupState();
      final registry = await database.getRegistrySnapshot();

      expect(startup.needsOnboarding, isFalse);
      expect(startup.primaryPersonId, isNotNull);
      expect(startup.primaryAccountId, isNotNull);
      expect(registry.people.single.displayName, 'Paulo');
      expect(registry.accounts.single.account.name, 'Conta principal');
      expect(registry.categories, isNotEmpty);
      expect(await database.watchAllTransactions().first, isEmpty);
    },
  );

  test('manual transaction rejects an account that does not exist', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    expect(
      () => database.createManualTransaction(
        const NewTransactionInput(
          kind: 'expense',
          amountCents: 1000,
          description: 'Teste',
          accountId: 'mp',
          payerPersonId: 'eu',
        ),
      ),
      throwsA(isA<StateError>()),
    );
  });

  test(
    'active classification rule classifies a manual transaction by priority',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database.saveInitialSetup(
        const SetupInput(
          personName: 'Paulo',
          accountName: 'Conta principal',
          accountProvider: 'nubank',
        ),
      );
      final startup = await database.getStartupState();
      final categories = await database.listCategories();
      final category = categories.firstWhere((item) => item.kind == 'expense');
      final ruleId = await database.upsertClassificationRule(
        name: 'Mercados',
        matchText: 'mercado',
        kind: 'expense',
        categoryId: category.id,
        costCenterId: null,
        priority: 100,
      );

      final transactionId = await database.createManualTransaction(
        NewTransactionInput(
          kind: 'expense',
          amountCents: 1890,
          description: 'Mercado do bairro',
          accountId: startup.primaryAccountId!,
          payerPersonId: startup.primaryPersonId,
        ),
      );
      final transaction = await database.getTransaction(transactionId);
      final rule = (await database.listClassificationRules()).single;
      final pending = await database.watchPendingReview().first;
      final outbox = await database.listPendingSyncOutbox();

      expect(transaction?.categoryId, category.id);
      expect(transaction?.appliedRuleId, ruleId);
      expect(transaction?.reviewStatus, 'confirmed');
      expect(rule.usageCount, 1);
      expect(pending.where((item) => item.id == transactionId), isEmpty);
      expect(outbox.last.deviceId, startsWith('device-'));
    },
  );

  test(
    'loadDemoData and clearLocalData control the local environment',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      await database.loadDemoData();
      var status = await database.getLocalDataStatus();

      expect(status.transactions, 7);
      expect(status.accounts, greaterThan(0));
      expect(status.categories, greaterThan(0));

      await database.loadDemoData();
      status = await database.getLocalDataStatus();
      expect(status.transactions, 7);

      await database.clearLocalData();
      status = await database.getLocalDataStatus();
      expect(status.isEmpty, isTrue);
    },
  );

  test('credit card invoice helpers honor closing and due days', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.loadDemoData();
    final card = (await database.listCreditCardsWithOwners()).single.creditCard;

    expect(database.invoiceMonthFor(card, DateTime(2026, 7, 20)), '2026-07');
    expect(database.invoiceMonthFor(card, DateTime(2026, 7, 21)), '2026-08');
    expect(
      database.invoiceDueDateFor(card, DateTime(2026, 7, 21)),
      DateTime(2026, 8, 27),
    );
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

  test('backup export validates and restores into an empty database', () async {
    final source = AppDatabase.forTesting(NativeDatabase.memory());
    await source.seedIfEmpty();
    await source.upsertClassificationRule(
      name: 'Mercado no backup',
      matchText: 'mercado',
      kind: 'expense',
      categoryId: 'alimentacao',
      costCenterId: null,
      priority: 100,
    );
    await source.createManualTransaction(
      const NewTransactionInput(
        kind: 'expense',
        amountCents: 2450,
        description: 'Lancamento manual',
        accountId: 'mp',
        payerPersonId: 'eu',
        categoryId: 'alimentacao',
        beneficiaryIds: ['eu'],
      ),
    );
    final backup = await source.exportBackupFile();
    await source.close();

    final target = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(target.close);

    final validation = await target.validateBackupBytes(backup.bytes);
    final restored = await target.restoreBackupBytes(backup.bytes);
    final restoredTransactions = await target.watchAllTransactions().first;
    final restoredPeople = await target.watchPeople().first;
    final restoredRules = await target.listClassificationRules();

    expect(validation.valid, isTrue);
    expect(validation.transactionCount, 8);
    expect(restored.transactionCount, 8);
    expect(restoredTransactions, hasLength(8));
    expect(
      restoredPeople.map((person) => person.displayName),
      contains('Sofia'),
    );
    expect(restoredRules.single.name, 'Mercado no backup');
  });

  test(
    'backup validation rejects unknown files and CSV export is readable',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      await database.seedIfEmpty();

      final invalid = await database.validateBackupBytes(
        utf8.encode('{"x":1}'),
      );
      final csv = utf8.decode(await database.exportTransactionsCsvBytes());

      expect(invalid.valid, isFalse);
      expect(csv, contains('data;competencia;tipo;descricao'));
      expect(csv, contains('Mercado Extra'));
      expect(csv, contains('Pensao Sofia'));
    },
  );

  test('sync run pushes pending outbox and stores pull cursor', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();
    await database.createManualTransaction(
      const NewTransactionInput(
        kind: 'expense',
        amountCents: 2450,
        description: 'Lancamento manual',
        accountId: 'mp',
        payerPersonId: 'eu',
        categoryId: 'alimentacao',
        beneficiaryIds: ['eu'],
      ),
    );

    final before = await database.listPendingSyncOutbox();
    final summary = await database.runSyncOnce(_FakeSyncApiClient());
    final after = await database.listPendingSyncOutbox();

    expect(before, isNotEmpty);
    expect(summary.pushed, before.length);
    expect(summary.pulled, 0);
    expect(summary.applied, 0);
    expect(summary.latestSeq, 0);
    expect(after, isEmpty);
  });

  test('sync conflict returns the local transaction to review', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database.seedIfEmpty();
    final transactionId = await database.createManualTransaction(
      const NewTransactionInput(
        kind: 'expense',
        amountCents: 2450,
        description: 'Lancamento concorrente',
        accountId: 'mp',
        payerPersonId: 'eu',
        categoryId: 'alimentacao',
      ),
    );

    final summary = await database.runSyncOnce(_ConflictSyncApiClient());
    final inbox = await database.watchOpenReviewInbox().first;

    expect(summary.conflicts, greaterThan(0));
    expect(
      inbox.where(
        (item) =>
            item.transactionId == transactionId &&
            item.reason == 'sync_conflict' &&
            item.severity == 'high',
      ),
      isNotEmpty,
    );
  });

  test('two local databases apply a remote transaction only once', () async {
    final deviceA = AppDatabase.forTesting(NativeDatabase.memory());
    final deviceB = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(deviceA.close);
    addTearDown(deviceB.close);
    await deviceA.seedIfEmpty();
    await deviceB.seedIfEmpty();
    final server = _SharedSyncServer();
    final transactionId = await deviceA.createManualTransaction(
      const NewTransactionInput(
        kind: 'expense',
        amountCents: 7654,
        description: 'Compra compartilhada sincronizada',
        accountId: 'mp',
        payerPersonId: 'eu',
        categoryId: 'alimentacao',
        beneficiaryIds: ['eu'],
      ),
    );

    await deviceA.runSyncOnce(_SharedSyncApiClient(server));
    final firstPull = await deviceB.runSyncOnce(_SharedSyncApiClient(server));
    final remote = await deviceB.getTransaction(transactionId);
    final sources = await deviceB.listTransactionSources(transactionId);
    final secondPull = await deviceB.runSyncOnce(_SharedSyncApiClient(server));

    expect(firstPull.applied, 1);
    expect(remote?.descriptionRaw, 'Compra compartilhada sincronizada');
    expect(remote?.amountCents, -7654);
    expect(sources.map((source) => source.sourceKind), contains('manual'));
    expect(secondPull.applied, 0);
    expect(await deviceB.listSyncConflicts(transactionId), isEmpty);
  });

  test(
    'concurrent financial edits preserve both sides in sync review',
    () async {
      final deviceA = AppDatabase.forTesting(NativeDatabase.memory());
      final deviceB = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(deviceA.close);
      addTearDown(deviceB.close);
      await deviceA.seedIfEmpty();
      await deviceB.seedIfEmpty();
      final server = _SharedSyncServer();
      final transactionId = await deviceA.createManualTransaction(
        const NewTransactionInput(
          kind: 'expense',
          amountCents: 3000,
          description: 'Compra concorrente entre aparelhos',
          accountId: 'mp',
          payerPersonId: 'eu',
          categoryId: 'alimentacao',
        ),
      );
      await deviceA.runSyncOnce(_SharedSyncApiClient(server));
      await deviceB.runSyncOnce(_SharedSyncApiClient(server));

      await deviceA.updateTransactionCore(
        id: transactionId,
        displayDescription: 'Valor confirmado no aparelho A',
        amountCents: -3100,
        kind: 'expense',
        categoryId: 'alimentacao',
        costCenterId: null,
      );
      await deviceB.updateTransactionCore(
        id: transactionId,
        displayDescription: 'Valor corrigido no aparelho B',
        amountCents: -3200,
        kind: 'expense',
        categoryId: 'alimentacao',
        costCenterId: null,
      );
      await deviceA.runSyncOnce(_SharedSyncApiClient(server));
      final result = await deviceB.runSyncOnce(_SharedSyncApiClient(server));
      final local = await deviceB.getTransaction(transactionId);
      final conflicts = await deviceB.listSyncConflicts(transactionId);
      final inbox = await deviceB.watchOpenReviewInbox().first;
      final reviewDetails = await deviceB.watchPendingReviewDetails().first;

      expect(result.conflicts, 1);
      expect(result.remoteConflicts, 1);
      expect(local?.displayDescription, 'Valor corrigido no aparelho B');
      expect(local?.amountCents, -3200);
      expect(local?.reviewStatus, 'conflict');
      expect(conflicts.single.localPayloadJson, contains('aparelho B'));
      expect(conflicts.single.remotePayloadJson, contains('aparelho A'));
      expect(
        reviewDetails
            .firstWhere((item) => item.transaction.id == transactionId)
            .syncConflictSummary,
        contains('aparelho B'),
      );
      expect(
        inbox.where((item) => item.reason == 'sync_remote_conflict'),
        isNotEmpty,
      );

      await deviceB.confirmTransaction(transactionId);
      await deviceB.runSyncOnce(_SharedSyncApiClient(server));
      await deviceA.runSyncOnce(_SharedSyncApiClient(server));
      final resolvedOnA = await deviceA.getTransaction(transactionId);
      final resolvedConflicts = await deviceB.listSyncConflicts(transactionId);

      expect(resolvedConflicts.single.status, 'keep_local');
      expect(resolvedOnA?.displayDescription, 'Valor corrigido no aparelho B');
      expect(resolvedOnA?.reviewStatus, 'confirmed');
    },
  );

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
    await database.confirmImportTarget(
      batchId: details.batch.id,
      accountId: 'nu',
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
    await database.confirmImportTarget(
      batchId: first.batch.id,
      accountId: 'nu',
    );
    await database.promoteImportBatchToReview(first.batch.id);

    final second = await database.importStatementFile(
      fileName: 'nubank_julho.csv',
      bytes: utf8.encode(csv),
    );
    await database.confirmImportTarget(
      batchId: second.batch.id,
      accountId: 'nu',
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
      final confirmed = await database.confirmImportTarget(
        batchId: details.batch.id,
        accountId: 'nu',
      );
      final candidates = await database.listDuplicateCandidates();

      expect(confirmed.batch.reviewRows, 0);
      expect(confirmed.batch.duplicateRows, 1);
      expect(confirmed.records.single.status, 'merge_candidate');
      expect(confirmed.records.single.duplicateOfTransactionId, 'tx-mercado');
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
      await database.confirmImportTarget(
        batchId: details.batch.id,
        accountId: 'mp',
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
      expect(invoice.transferToAccountId, isNull);
      expect(cardPlan.planKind, 'credit_card_purchase');
      expect(cardPlan.currentInstallment, 2);
      expect(cardPlan.totalInstallments, 10);
      expect(cardPlan.dueDay, isNull);
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

  test('notification bridge drains a paginated backlog exactly once', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database.seedIfEmpty();
    final now = DateTime.now();
    final events = List.generate(
      120,
      (index) => CapturedNotificationEvent(
        id: 'backlog-$index',
        packageName: index.isEven
            ? 'com.nu.production'
            : 'com.mercadopago.wallet',
        postedAt: now.add(Duration(seconds: index)),
        capturedAt: now.add(Duration(seconds: index)),
        title: 'Aviso sem valor $index',
        text: 'Atualizacao de seguranca',
      ),
    );
    final service = _FakeNotificationCaptureService(
      drains: [
        NotificationCaptureDrain(
          available: true,
          events: events.take(50).toList(),
          pendingCount: 120,
          hasMore: true,
        ),
        NotificationCaptureDrain(
          available: true,
          events: events.skip(50).take(50).toList(),
          pendingCount: 70,
          hasMore: true,
        ),
        NotificationCaptureDrain(
          available: true,
          events: events.skip(100).toList(),
          pendingCount: 20,
          hasMore: false,
        ),
      ],
    );

    final result = await database.syncNotificationCaptureEvents(service);
    final rawEvents = await database.listRawNotificationEvents(limit: 200);
    final diagnostics = await database.getNotificationCaptureDiagnostics();

    expect(result.fetched, 120);
    expect(result.recorded, 120);
    expect(result.drafts, 0);
    expect(service.acknowledged.expand((ids) => ids), hasLength(120));
    expect(rawEvents, hasLength(120));
    expect(diagnostics.count('ignored_no_amount'), 120);
  });

  test(
    'notification bridge is idempotent after acknowledgement retry',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database.seedIfEmpty();
      final now = DateTime.now();
      final event = CapturedNotificationEvent(
        id: 'same-native-notification',
        packageName: 'com.nu.production',
        postedAt: now,
        capturedAt: now,
        title: 'Compra aprovada',
        text: 'Compra aprovada de R\$ 19,90',
      );
      final service = _FakeNotificationCaptureService(
        drains: [
          NotificationCaptureDrain(
            available: true,
            events: [event],
            pendingCount: 1,
            hasMore: true,
          ),
          NotificationCaptureDrain(
            available: true,
            events: [event],
            pendingCount: 1,
            hasMore: false,
          ),
        ],
      );

      final result = await database.syncNotificationCaptureEvents(service);
      final rawEvents = await database.listRawNotificationEvents();
      final sources = await database.listTransactionSources(
        rawEvents.single.draftTransactionId!,
      );

      expect(result.fetched, 2);
      expect(result.recorded, 1);
      expect(result.drafts, 1);
      expect(rawEvents, hasLength(1));
      expect(rawEvents.single.status, 'draft_created');
      expect(sources, hasLength(1));
    },
  );

  test(
    'notification bridge releases a batch after acknowledgement failure',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database.seedIfEmpty();
      final now = DateTime.now();
      final service = _FakeNotificationCaptureService(
        failAcknowledge: true,
        drains: [
          NotificationCaptureDrain(
            available: true,
            events: [
              CapturedNotificationEvent(
                id: 'retry-after-bridge-failure',
                packageName: 'com.mercadopago.wallet',
                postedAt: now,
                capturedAt: now,
                title: 'Aviso',
                text: 'Sem valor financeiro',
              ),
            ],
            pendingCount: 1,
            hasMore: false,
          ),
        ],
      );

      final result = await database.syncNotificationCaptureEvents(service);

      expect(result.bridgeError, isNotNull);
      expect(service.released, contains('retry-after-bridge-failure'));
    },
  );

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

  test('local registries create edit archive and reactivate records', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final accountId = await database.upsertAccount(
      provider: 'manual',
      name: 'Conta corrente teste',
      type: 'account',
      ownerPersonId: 'eu',
      last4: '4321',
    );
    final cardId = await database.upsertCreditCard(
      provider: 'manual',
      name: 'Cartao teste',
      ownerPersonId: 'eu',
      brand: 'Visa',
      last4: '9876',
      billingDay: 10,
      dueDay: 20,
    );
    final categoryId = await database.upsertCategory(
      name: 'Assinaturas',
      kind: 'expense',
      sortOrder: 90,
    );
    final costCenterId = await database.upsertCostCenter(name: 'Projetos');

    var registry = await database.getRegistrySnapshot();
    final createdCard = registry.creditCards.firstWhere(
      (item) => item.creditCard.id == cardId,
    );

    expect(
      registry.accounts.map((item) => item.account.id),
      contains(accountId),
    );
    expect(createdCard.creditCard.accountId, isNotNull);
    expect(
      registry.categories.map((category) => category.id),
      contains(categoryId),
    );
    expect(
      registry.costCenters.map((center) => center.id),
      contains(costCenterId),
    );

    await database.archiveAccount(accountId);
    await database.archiveCreditCard(cardId);
    await database.archiveCategory(categoryId);
    await database.archiveCostCenter(costCenterId);

    expect(
      (await database.listAccountsWithOwners()).map((item) => item.account.id),
      isNot(contains(accountId)),
    );
    expect(
      (await database.listCreditCardsWithOwners()).map(
        (item) => item.creditCard.id,
      ),
      isNot(contains(cardId)),
    );
    expect(
      (await database.listCategories()).map((category) => category.id),
      isNot(contains(categoryId)),
    );
    expect(
      (await database.listCostCenters()).map((center) => center.id),
      isNot(contains(costCenterId)),
    );

    await database.upsertCategory(
      id: categoryId,
      name: 'Assinaturas fixas',
      kind: 'expense',
      sortOrder: 95,
      active: true,
    );

    registry = await database.getRegistrySnapshot();
    expect(
      registry.categories
          .firstWhere((category) => category.id == categoryId)
          .name,
      'Assinaturas fixas',
    );
  });

  test(
    'archived category is hidden from pickers but kept in history',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      await database.seedIfEmpty();
      await database.archiveCategory('saude');

      final activeCategories = await database.listCategories();
      final allDetails = await database.watchAllTransactionDetails().first;
      final farmacia = allDetails.firstWhere(
        (item) => item.transaction.id == 'tx-farmacia',
      );

      expect(
        activeCategories.map((category) => category.id),
        isNot(contains('saude')),
      );
      expect(farmacia.categoryLabel, 'Saude');
    },
  );

  test(
    'updateTransactionDetails edits account payer dates and beneficiaries',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      await database.seedIfEmpty();
      await database.updateTransactionDetails(
        id: 'tx-farmacia',
        displayDescription: 'Farmacia completa',
        amountCents: 4567,
        kind: 'expense',
        occurredAt: DateTime(2026, 7, 29),
        competenceMonth: '2026-07',
        accountId: 'marina-conta',
        categoryId: 'saude',
        costCenterId: 'pessoal',
        payerId: 'marina',
        beneficiaryIds: const ['marina', 'bebe'],
      );

      final transaction = await database.getTransaction('tx-farmacia');
      final details = await database.watchAllTransactionDetails().first;
      final farmacia = details.firstWhere(
        (item) => item.transaction.id == 'tx-farmacia',
      );

      expect(transaction?.descriptionRaw, 'Farmacia Pague Menos');
      expect(transaction?.displayDescription, 'Farmacia completa');
      expect(transaction?.amountCents, -4567);
      expect(transaction?.occurredAt, DateTime(2026, 7, 29));
      expect(transaction?.accountId, 'marina-conta');
      expect(transaction?.payerId, 'marina');
      expect(transaction?.costCenterId, 'pessoal');
      expect(
        farmacia.beneficiaries.map((person) => person.id),
        containsAll(['marina', 'bebe']),
      );
    },
  );

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
      displayDescription: 'Farmacia editada',
      amountCents: -12000,
      kind: 'expense',
      categoryId: 'saude',
      costCenterId: 'pessoal',
    );

    final transaction = await database.getTransaction('tx-farmacia');

    expect(transaction?.descriptionRaw, 'Farmacia Pague Menos');
    expect(transaction?.displayDescription, 'Farmacia editada');
    expect(transaction?.amountCents, -12000);
    expect(transaction?.costCenterId, 'pessoal');
  });
}

class _FakeSyncApiClient implements SyncApiClient {
  @override
  Future<SyncPullResponse> pull({
    required String householdId,
    required int sinceSeq,
  }) async {
    return const SyncPullResponse(events: [], latestSeq: 0);
  }

  @override
  Future<SyncPushResponse> push(SyncPushPayload payload) async {
    return SyncPushResponse(
      latestSeq: payload.operations.length,
      results: [
        for (final operation in payload.operations)
          SyncOperationAck(
            opId: operation['opId'] as String,
            result: 'applied',
            entityId: operation['entityId'] as String,
            seq: payload.operations.indexOf(operation) + 1,
          ),
      ],
    );
  }
}

class _ConflictSyncApiClient implements SyncApiClient {
  @override
  Future<SyncPullResponse> pull({
    required String householdId,
    required int sinceSeq,
  }) async => const SyncPullResponse(events: [], latestSeq: 0);

  @override
  Future<SyncPushResponse> push(SyncPushPayload payload) async {
    return SyncPushResponse(
      latestSeq: 1,
      results: [
        for (final operation in payload.operations)
          SyncOperationAck(
            opId: operation['opId'] as String,
            result: 'conflict',
            entityId: operation['entityId'] as String,
            seq: 1,
          ),
      ],
    );
  }
}

class _SharedSyncApiClient implements SyncApiClient {
  _SharedSyncApiClient(this.server);

  final _SharedSyncServer server;

  @override
  Future<SyncPullResponse> pull({
    required String householdId,
    required int sinceSeq,
  }) async => server.pull(householdId, sinceSeq);

  @override
  Future<SyncPushResponse> push(SyncPushPayload payload) async =>
      server.push(payload);
}

class _SharedSyncServer {
  final Map<String, SyncOperationAck> _operations = {};
  final Map<String, int> _entityVersions = {};
  final List<Map<String, dynamic>> _events = [];
  var _seq = 0;

  Future<SyncPushResponse> push(SyncPushPayload payload) async {
    final results = <SyncOperationAck>[];
    for (final operation in payload.operations) {
      final opId = operation['opId'] as String;
      final existing = _operations[opId];
      if (existing != null) {
        results.add(
          SyncOperationAck(
            opId: opId,
            result: 'duplicate',
            entityId: existing.entityId,
            seq: existing.seq,
          ),
        );
        continue;
      }
      final entityKey = [
        operation['householdId'],
        operation['entityType'],
        operation['entityId'],
      ].join(':');
      final expectedVersion = _entityVersions[entityKey] ?? 0;
      final baseVersion = operation['baseVersion'] as int;
      final isCreate = operation['operationType'] == 'create';
      final result = (!isCreate && baseVersion != expectedVersion)
          ? 'conflict'
          : 'applied';
      final ack = SyncOperationAck(
        opId: opId,
        result: result,
        entityId: operation['entityId'] as String,
        seq: ++_seq,
      );
      _operations[opId] = ack;
      results.add(ack);
      if (result == 'applied') {
        _entityVersions[entityKey] = baseVersion + 1;
        _events.add({
          ...operation,
          'seq': ack.seq,
          'serverAt': DateTime.utc(2026, 8, 23, 12, 0, _seq).toIso8601String(),
        });
      }
    }
    return SyncPushResponse(results: results, latestSeq: _seq);
  }

  Future<SyncPullResponse> pull(String householdId, int sinceSeq) async {
    final events = _events
        .where(
          (event) =>
              event['householdId'] == householdId &&
              (event['seq'] as int) > sinceSeq,
        )
        .map(Map<String, dynamic>.from)
        .toList(growable: false);
    return SyncPullResponse(events: events, latestSeq: _seq);
  }
}

class _FakeNotificationCaptureService extends NotificationCaptureService {
  _FakeNotificationCaptureService({
    required this.drains,
    this.failAcknowledge = false,
  });

  final List<NotificationCaptureDrain> drains;
  final bool failAcknowledge;
  final List<List<String>> acknowledged = [];
  final List<String> released = [];
  var _drainIndex = 0;

  @override
  Future<NotificationCaptureDrain> drainPendingEvents({int limit = 50}) async {
    if (_drainIndex >= drains.length) {
      return const NotificationCaptureDrain.unavailable();
    }
    return drains[_drainIndex++];
  }

  @override
  Future<void> acknowledgeDeliveredEvents(List<String> eventIds) async {
    if (failAcknowledge) {
      throw StateError('bridge acknowledgement failed');
    }
    acknowledged.add(eventIds);
  }

  @override
  Future<void> releaseEventsForRetry(
    List<String> eventIds, {
    String? error,
  }) async {
    released.addAll(eventIds);
  }
}
