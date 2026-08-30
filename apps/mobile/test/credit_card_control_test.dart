import 'dart:convert';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test(
    'limite compartilhado soma cartoes e reage a pagamento cancelado',
    () async {
      final database = await _databaseWithSharedLimit();
      addTearDown(database.close);

      var limit = await database.getCreditLimitGroupSummary(
        'family-nubank-limit',
        now: DateTime(2026, 8, 15),
      );
      expect(limit, isNotNull);
      expect(limit!.cards, hasLength(2));
      expect(limit.usedCents, 30000);
      expect(limit.availableCents, 70000);
      expect(limit.overLimit, isFalse);

      const invoiceId = 'invoice-card-primary-2026-08';
      final paymentId = await database.recordManualInvoicePayment(
        invoiceId: invoiceId,
        sourceAccountId: 'bank-account',
        amountCents: 5000,
        paidAt: DateTime(2026, 8, 15),
      );
      limit = await database.getCreditLimitGroupSummary(
        'family-nubank-limit',
        now: DateTime(2026, 8, 15),
      );
      expect(limit!.usedCents, 25000);
      expect(
        (await database.listInvoicePaymentAudits(invoiceId)).single.action,
        'reconciled',
      );

      await database.cancelInvoicePayment(
        paymentId,
        cancelledAt: DateTime(2026, 8, 16),
        reason: 'Conta pagadora incorreta',
      );
      limit = await database.getCreditLimitGroupSummary(
        'family-nubank-limit',
        now: DateTime(2026, 8, 16),
      );
      expect(limit!.usedCents, 30000);
      final audits = await database.listInvoicePaymentAudits(invoiceId);
      expect(audits.any((audit) => audit.action == 'cancelled'), isTrue);
      final transfer = (await database.watchAllTransactions().first)
          .singleWhere((item) => item.id.contains('invoice-payment'));
      expect(transfer.kind, 'transfer');
      expect(transfer.reviewStatus, 'pending');
      expect(transfer.transferToAccountId, isNull);
    },
  );

  test('exportacao CSV descreve ciclo, compras e pagamentos', () async {
    final database = await _databaseWithSharedLimit();
    addTearDown(database.close);
    await database.recordManualInvoicePayment(
      invoiceId: 'invoice-card-primary-2026-08',
      sourceAccountId: 'bank-account',
      amountCents: 5000,
      paidAt: DateTime(2026, 8, 15),
    );

    final bytes = await database.exportInvoiceCsvBytes(
      'invoice-card-primary-2026-08',
    );
    final csv = utf8.decode(bytes.sublist(3));
    expect(csv, contains('fatura;cartao;periodo_inicio'));
    expect(csv, contains('Nubank principal'));
    expect(csv, contains('compra'));
    expect(csv, contains('pagamento'));
    expect(csv, contains('Mercado da familia'));
  });

  test('limite considera parcelas futuras, estorno e estouro', () async {
    final database = await _databaseWithSharedLimit();
    addTearDown(database.close);

    final transactionId = await database.createManualTransaction(
      NewTransactionInput(
        kind: 'expense',
        amountCents: 80000,
        description: 'Notebook parcelado',
        accountId: 'card-primary-account',
        occurredAt: DateTime(2026, 8, 12),
        payerPersonId: 'owner',
        beneficiaryIds: const ['owner'],
      ),
    );
    final planId = await database.upsertInstallmentPlan(
      id: 'plan-notebook',
      label: 'Notebook parcelado',
      planKind: 'credit_card_purchase',
      ownerPersonId: 'owner',
      totalAmountCents: 240000,
      installmentAmountCents: 80000,
      currentInstallment: 1,
      totalInstallments: 3,
      startMonth: '2026-08',
    );
    await (database.update(database.transactions)
          ..where((row) => row.id.equals(transactionId)))
        .write(TransactionsCompanion(installmentPlanId: Value(planId)));
    await database.createManualTransaction(
      NewTransactionInput(
        kind: 'refund',
        amountCents: 15000,
        description: 'Estorno parcial',
        accountId: 'card-additional-account',
        occurredAt: DateTime(2026, 8, 13),
        payerPersonId: 'owner',
        beneficiaryIds: const ['owner'],
      ),
    );
    await database.rebuildCreditCardInvoices(now: DateTime(2026, 8, 15));

    final limit = await database.getCreditLimitGroupSummary(
      'family-nubank-limit',
      now: DateTime(2026, 8, 15),
    );
    expect(limit, isNotNull);
    // 30.000 existentes + 80.000 da parcela atual - 15.000 de estorno,
    // mais duas parcelas futuras de 80.000 ainda não materializadas.
    expect(limit!.unpaidInvoicesCents, 95000);
    expect(limit.projectedInstallmentsCents, 160000);
    expect(limit.usedCents, 255000);
    expect(limit.availableCents, -155000);
    expect(limit.overLimit, isTrue);
  });

  test(
    'cartao sem limite continua calculando exposicao sem bloquear',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database.upsertPerson(
        id: 'owner',
        displayName: 'Paulo',
        kind: 'adult',
      );
      await database.upsertCreditCard(
        id: 'card-no-limit',
        accountId: 'card-no-limit-account',
        provider: 'manual',
        name: 'Cartao sem limite',
        ownerPersonId: 'owner',
        billingDay: 20,
        dueDay: 27,
      );
      await database.createManualTransaction(
        NewTransactionInput(
          kind: 'expense',
          amountCents: 12345,
          description: 'Compra permitida',
          accountId: 'card-no-limit-account',
          occurredAt: DateTime(2026, 8, 10),
          payerPersonId: 'owner',
        ),
      );
      await database.rebuildCreditCardInvoices(now: DateTime(2026, 8, 15));

      final limit = await database.getCreditLimitGroupSummary(
        'limit-group-card-no-limit',
        now: DateTime(2026, 8, 15),
      );
      expect(limit!.usedCents, 12345);
      expect(limit.availableCents, isNull);
      expect(limit.utilization, isNull);
      expect(limit.overLimit, isFalse);
    },
  );

  test('migracao do schema 14 cria grupos individuais sem limite', () async {
    final executor = NativeDatabase.memory(
      setup: (rawDatabase) {
        rawDatabase.execute('PRAGMA user_version = 14');
        rawDatabase.execute('''
          CREATE TABLE credit_cards (
            id TEXT NOT NULL PRIMARY KEY,
            household_id TEXT NOT NULL,
            account_id TEXT,
            owner_person_id TEXT,
            provider TEXT NOT NULL,
            name TEXT NOT NULL,
            brand TEXT,
            last4 TEXT,
            billing_day INTEGER,
            due_day INTEGER,
            active INTEGER NOT NULL DEFAULT 1
          )
        ''');
        rawDatabase.execute('''
          INSERT INTO credit_cards (
            id, household_id, provider, name, active
          ) VALUES ('legacy-card', 'household-main', 'nubank', 'Nubank antigo', 1)
        ''');
      },
    );
    final database = AppDatabase.forTesting(executor);
    addTearDown(database.close);

    final card = await database.getCreditCard('legacy-card');
    final group = await database.getCreditCardLimitGroup(
      'limit-group-legacy-card',
    );
    expect(card!.limitGroupId, 'limit-group-legacy-card');
    expect(card.limitRole, 'primary');
    expect(group!.name, 'Nubank antigo');
    expect(group.totalLimitCents, isNull);
  });
}

Future<AppDatabase> _databaseWithSharedLimit() async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  await database.upsertPerson(id: 'owner', displayName: 'Paulo', kind: 'adult');
  await database.upsertAccount(
    id: 'bank-account',
    provider: 'nubank',
    name: 'Conta Nubank',
    type: 'checking',
    ownerPersonId: 'owner',
  );
  await database.upsertCreditCard(
    id: 'card-primary',
    accountId: 'card-primary-account',
    provider: 'nubank',
    name: 'Nubank principal',
    ownerPersonId: 'owner',
    billingDay: 20,
    dueDay: 27,
    limitGroupId: 'family-nubank-limit',
    limitGroupName: 'Limite Nubank da familia',
    totalLimitCents: 100000,
  );
  await database.upsertCreditCard(
    id: 'card-additional',
    accountId: 'card-additional-account',
    provider: 'nubank',
    name: 'Nubank adicional',
    ownerPersonId: 'owner',
    billingDay: 20,
    dueDay: 27,
    limitGroupId: 'family-nubank-limit',
    limitGroupName: 'Limite Nubank da familia',
    totalLimitCents: 100000,
    limitRole: 'additional',
  );
  await database.createManualTransaction(
    NewTransactionInput(
      kind: 'expense',
      amountCents: 10000,
      description: 'Mercado da familia',
      accountId: 'card-primary-account',
      occurredAt: DateTime(2026, 8, 10),
      payerPersonId: 'owner',
      beneficiaryIds: const ['owner'],
    ),
  );
  await database.createManualTransaction(
    NewTransactionInput(
      kind: 'expense',
      amountCents: 20000,
      description: 'Compra no cartao adicional',
      accountId: 'card-additional-account',
      occurredAt: DateTime(2026, 8, 11),
      payerPersonId: 'owner',
      beneficiaryIds: const ['owner'],
    ),
  );
  await database.rebuildCreditCardInvoices(now: DateTime(2026, 8, 15));
  return database;
}
