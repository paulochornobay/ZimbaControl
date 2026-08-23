import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/invoices_page.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  for (final size in [const Size(360, 800), const Size(390, 844)]) {
    testWidgets(
      'visao de fatura cabe em ${size.width.toInt()}px com dados longos',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.platformDispatcher.clearTextScaleFactorTestValue();
        });
        final database = await _invoiceDatabase();
        addTearDown(database.close);

        await tester.pumpWidget(
          MaterialApp(
            theme: ZimbaTheme.light,
            home: InvoicesPage(
              database: database,
              referenceDate: DateTime(2026, 8, 15),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Faturas'), findsOneWidget);
        await tester.tap(
          find.text('Nubank crédito principal com nome muito extenso'),
        );
        await tester.pumpAndSettle();
        expect(find.text('Fatura de agosto 2026'), findsOneWidget);
        expect(find.text('R\$ 121.956,78'), findsOneWidget);
        expect(find.text('Parcial'), findsOneWidget);
        expect(tester.takeException(), isNull);

        final mainList = find.byKey(const Key('invoice-list'));
        for (var index = 0; index < 5; index++) {
          await tester.drag(mainList, const Offset(0, -360));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        expect(find.text('PAGAMENTOS'), findsOneWidget);
        expect(find.text('Confirmado'), findsOneWidget);
      },
    );
  }

  testWidgets('estado sem cartao direciona ao cadastro real', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      MaterialApp(
        theme: ZimbaTheme.light,
        home: InvoicesPage(
          database: database,
          referenceDate: DateTime(2026, 8, 15),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nenhum cartão cadastrado'), findsOneWidget);
    expect(find.text('Cadastrar cartão'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<AppDatabase> _invoiceDatabase() async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  await database.upsertPerson(
    id: 'person-with-a-very-long-name',
    displayName: 'Paulo responsável principal da família',
    kind: 'adult',
  );
  await database.upsertCategory(
    id: 'electronics',
    name: 'Eletrônicos e equipamentos domésticos',
    kind: 'expense',
    iconKey: 'tag',
    colorKey: 'blue',
    sortOrder: 1,
  );
  await database.upsertCreditCard(
    id: 'nubank-card',
    accountId: 'nubank-card-account',
    provider: 'nubank',
    name: 'Nubank crédito principal com nome muito extenso',
    ownerPersonId: 'person-with-a-very-long-name',
    last4: '4321',
    billingDay: 20,
    dueDay: 27,
  );
  await database.upsertCreditCard(
    id: 'nubank-card-secondary',
    accountId: 'nubank-card-secondary-account',
    provider: 'nubank',
    name: 'Nubank cartão adicional',
    ownerPersonId: 'person-with-a-very-long-name',
    last4: '1111',
    billingDay: 20,
    dueDay: 27,
  );
  await database.createManualTransaction(
    NewTransactionInput(
      kind: 'expense',
      amountCents: 12345678,
      description:
          'Compra parcelada de equipamento com uma descrição extremamente longa',
      accountId: 'nubank-card-account',
      occurredAt: DateTime(2026, 8, 10),
      payerPersonId: 'person-with-a-very-long-name',
      beneficiaryIds: const ['person-with-a-very-long-name'],
      categoryId: 'electronics',
    ),
  );
  await database.createManualTransaction(
    NewTransactionInput(
      kind: 'income',
      amountCents: 150000,
      description: 'Estorno parcial da compra de equipamento',
      accountId: 'nubank-card-account',
      occurredAt: DateTime(2026, 8, 11),
      payerPersonId: 'person-with-a-very-long-name',
      beneficiaryIds: const ['person-with-a-very-long-name'],
      categoryId: 'electronics',
    ),
  );
  await database.upsertAccount(
    id: 'bank-account',
    provider: 'nubank',
    name: 'Conta corrente principal',
    type: 'checking',
    ownerPersonId: 'person-with-a-very-long-name',
  );
  final transferId = await database.createManualTransaction(
    NewTransactionInput(
      kind: 'transfer',
      amountCents: -500000,
      description: 'Pagamento parcial da fatura Nubank',
      accountId: 'bank-account',
      occurredAt: DateTime(2026, 8, 15),
      payerPersonId: 'person-with-a-very-long-name',
    ),
  );
  await database.recordInvoicePayment(
    invoiceId: 'invoice-nubank-card-2026-08',
    amountCents: 500000,
    paidAt: DateTime(2026, 8, 15),
    transactionId: transferId,
    origin: 'manual_confirmed',
  );
  return database;
}
