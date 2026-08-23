import 'dart:convert';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.upsertCreditCard(
      id: 'nubank-card',
      accountId: 'nubank-card-account',
      provider: 'nubank',
      name: 'Nubank credito',
      ownerPersonId: null,
      last4: '4321',
      billingDay: 20,
      dueDay: 27,
    );
  });

  tearDown(() => database.close());

  test('ciclo respeita antes, no e depois do fechamento', () async {
    final card = (await database.listCreditCardsWithOwners()).single.creditCard;

    final before = database.invoiceCycleFor(card, DateTime(2026, 7, 19));
    final onClosing = database.invoiceCycleFor(card, DateTime(2026, 7, 20));
    final after = database.invoiceCycleFor(card, DateTime(2026, 7, 21));

    expect(before.competenceMonth, '2026-07');
    expect(onClosing.competenceMonth, '2026-07');
    expect(onClosing.periodStart, DateTime(2026, 6, 21));
    expect(onClosing.periodEnd, DateTime(2026, 7, 20));
    expect(onClosing.dueDate, DateTime(2026, 7, 27));
    expect(after.competenceMonth, '2026-08');
    expect(after.periodStart, DateTime(2026, 7, 21));
    expect(after.dueDate, DateTime(2026, 8, 27));
  });

  test('ciclo trata mes curto, vencimento apos corte e virada anual', () async {
    await database.upsertCreditCard(
      id: 'long-cycle',
      accountId: 'long-cycle-account',
      provider: 'manual',
      name: 'Cartao dia 31',
      ownerPersonId: null,
      billingDay: 31,
      dueDay: 15,
    );
    final card = await database.getCreditCard('long-cycle');

    final february = database.invoiceCycleFor(card!, DateTime(2028, 2, 29));
    final december = database.invoiceCycleFor(card, DateTime(2026, 12, 31));

    expect(february.periodEnd, DateTime(2028, 2, 29));
    expect(february.dueDate, DateTime(2028, 3, 15));
    expect(december.competenceMonth, '2026-12');
    expect(december.dueDate, DateTime(2027, 1, 15));
  });

  test(
    'postedAt prevalece e recalculo nao altera competencia historica',
    () async {
      final transactionId = await _create(
        database,
        kind: 'expense',
        amountCents: 10000,
        occurredAt: DateTime(2026, 8, 5),
        description: 'Compra postada depois',
      );
      final original = await database.getTransaction(transactionId);
      expect(original?.creditCardInvoiceId, 'invoice-nubank-card-2026-08');

      await (database.update(database.transactions)
            ..where((row) => row.id.equals(transactionId)))
          .write(TransactionsCompanion(postedAt: Value(DateTime(2026, 9, 21))));
      expect(await database.rebuildCreditCardInvoices(), 1);

      final recalculated = await database.getTransaction(transactionId);
      expect(recalculated?.creditCardInvoiceId, 'invoice-nubank-card-2026-10');
      expect(recalculated?.competenceMonth, original?.competenceMonth);
      expect(recalculated?.amountCents, original?.amountCents);
    },
  );

  test(
    'estorno reduz total e pagamento parcial ou total deriva o estado',
    () async {
      await _create(
        database,
        kind: 'expense',
        amountCents: 10000,
        occurredAt: DateTime(2026, 8, 10),
        description: 'Compra',
      );
      await _create(
        database,
        kind: 'income',
        amountCents: 2500,
        occurredAt: DateTime(2026, 8, 11),
        description: 'Estorno',
      );
      final invoice = (await database.listCreditCardInvoices()).single;
      var summary = await database.getCreditCardInvoiceSummary(
        invoice.id,
        now: DateTime(2026, 8, 15),
      );
      expect(summary.purchasesCents, 10000);
      expect(summary.refundsCents, 2500);
      expect(summary.totalCents, 7500);
      expect(summary.effectiveState, 'open');

      await database.upsertAccount(
        id: 'bank-account',
        provider: 'nubank',
        name: 'Conta corrente',
        type: 'checking',
        ownerPersonId: null,
      );
      final transferId = await database.createManualTransaction(
        NewTransactionInput(
          kind: 'transfer',
          amountCents: -4000,
          description: 'Pagamento da fatura',
          accountId: 'bank-account',
          occurredAt: DateTime(2026, 8, 18),
          payerPersonId: null,
        ),
      );
      await database.recordInvoicePayment(
        invoiceId: invoice.id,
        amountCents: 4000,
        paidAt: DateTime(2026, 8, 18),
        transactionId: transferId,
        origin: 'manual_confirmed',
      );
      summary = await database.getCreditCardInvoiceSummary(
        invoice.id,
        now: DateTime(2026, 8, 19),
      );
      expect(summary.paidCents, 4000);
      expect(summary.outstandingCents, 3500);
      expect(summary.effectiveState, 'partially_paid');
      expect(
        summary.transactions.every((item) => item.kind != 'transfer'),
        isTrue,
      );
      expect((await database.getTransaction(transferId))?.kind, 'transfer');

      await database.recordInvoicePayment(
        invoiceId: invoice.id,
        amountCents: 3500,
        paidAt: DateTime(2026, 8, 20),
      );
      summary = await database.getCreditCardInvoiceSummary(
        invoice.id,
        now: DateTime(2026, 8, 21),
      );
      expect(summary.outstandingCents, 0);
      expect(summary.effectiveState, 'paid');
    },
  );

  test(
    'fatura vencida deriva estado real e pagamento cancelado deixa de contar',
    () async {
      await _create(
        database,
        kind: 'expense',
        amountCents: 5000,
        occurredAt: DateTime(2026, 8, 10),
        description: 'Compra vencida',
      );
      final invoice = (await database.listCreditCardInvoices()).single;
      final paymentId = await database.recordInvoicePayment(
        invoiceId: invoice.id,
        amountCents: 1000,
        paidAt: DateTime(2026, 8, 22),
      );
      await database.cancelInvoicePayment(
        paymentId,
        cancelledAt: DateTime(2026, 8, 23),
      );

      final summary = await database.getCreditCardInvoiceSummary(
        invoice.id,
        now: DateTime(2026, 8, 28),
      );
      expect(summary.paidCents, 0);
      expect(summary.outstandingCents, 5000);
      expect(summary.effectiveState, 'overdue');
    },
  );

  test(
    'converter compra em transferencia remove o vinculo e a despesa',
    () async {
      final transactionId = await _create(
        database,
        kind: 'expense',
        amountCents: 5000,
        occurredAt: DateTime(2026, 8, 10),
        description: 'Pagamento identificado como compra',
      );
      final invoice = (await database.listCreditCardInvoices()).single;

      await database.convertToTransfer(transactionId);

      final transaction = await database.getTransaction(transactionId);
      final summary = await database.getCreditCardInvoiceSummary(
        invoice.id,
        now: DateTime(2026, 8, 15),
      );
      expect(transaction?.creditCardInvoiceId, isNull);
      expect(transaction?.kind, 'transfer');
      expect(summary.totalCents, 0);
      expect(
        (await database.listInvoiceAssignmentAudits(transactionId)).last.reason,
        contains('nao e uma compra'),
      );
    },
  );

  test(
    'correcao manual fica auditada e resiste ao recalculo automatico',
    () async {
      final julyId = await _create(
        database,
        kind: 'expense',
        amountCents: 1000,
        occurredAt: DateTime(2026, 7, 10),
        description: 'Compra julho',
      );
      await _create(
        database,
        kind: 'expense',
        amountCents: 2000,
        occurredAt: DateTime(2026, 8, 10),
        description: 'Compra agosto',
      );
      const augustInvoice = 'invoice-nubank-card-2026-08';

      await database.correctInvoiceAssignment(
        transactionId: julyId,
        invoiceId: augustInvoice,
        reason: 'Compra reconhecida pelo emissor somente na fatura seguinte.',
        correctedAt: DateTime(2026, 8, 12),
      );
      await database.rebuildCreditCardInvoices(now: DateTime(2026, 8, 13));

      final corrected = await database.getTransaction(julyId);
      final audits = await database.listInvoiceAssignmentAudits(julyId);
      expect(corrected?.creditCardInvoiceId, augustInvoice);
      expect(corrected?.invoiceAssignmentSource, 'manual');
      expect(audits, hasLength(2));
      final manualAudit = audits.singleWhere(
        (audit) => audit.origin == 'manual',
      );
      expect(manualAudit.reason, contains('fatura seguinte'));
      final outbox = await database.listPendingSyncOutbox();
      final payload =
          jsonDecode(outbox.last.payloadJson) as Map<String, dynamic>;
      expect(
        (payload['transaction'] as Map<String, dynamic>)['creditCardInvoiceId'],
        augustInvoice,
      );
    },
  );

  test(
    'backup novo e backup anterior a fase 4A continuam restauraveis',
    () async {
      await _create(
        database,
        kind: 'expense',
        amountCents: 1234,
        occurredAt: DateTime(2026, 8, 10),
        description: 'Compra no backup',
      );
      final backup = await database.exportBackupFile();
      final target = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(target.close);
      await target.restoreBackupBytes(backup.bytes);
      expect(await target.listCreditCardInvoices(), hasLength(1));

      final oldJson =
          jsonDecode(utf8.decode(backup.bytes)) as Map<String, dynamic>;
      final data = oldJson['data'] as Map<String, dynamic>;
      data.remove('creditCardInvoices');
      data.remove('invoicePayments');
      data.remove('invoiceAssignmentAudits');
      for (final row in data['transactions'] as List<dynamic>) {
        final transaction = row as Map<String, dynamic>;
        transaction.remove('creditCardInvoiceId');
        transaction.remove('invoiceAssignmentSource');
        transaction.remove('invoiceAssignedAt');
      }
      final oldTarget = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(oldTarget.close);
      final result = await oldTarget.restoreBackupBytes(
        utf8.encode(jsonEncode(oldJson)),
      );
      final restoredTransaction =
          (await oldTarget.watchAllTransactions().first).single;
      expect(result.valid, isTrue);
      expect(restoredTransaction.creditCardInvoiceId, isNull);
      expect(await oldTarget.listCreditCardInvoices(), isEmpty);
    },
  );
}

Future<String> _create(
  AppDatabase database, {
  required String kind,
  required int amountCents,
  required DateTime occurredAt,
  required String description,
}) {
  return database.createManualTransaction(
    NewTransactionInput(
      kind: kind,
      amountCents: amountCents,
      description: description,
      accountId: 'nubank-card-account',
      occurredAt: occurredAt,
      payerPersonId: null,
    ),
  );
}
