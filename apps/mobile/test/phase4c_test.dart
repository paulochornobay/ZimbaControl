import 'dart:convert';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/invoices_page.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('sugestao nunca altera a fatura antes da confirmacao', () async {
    final database = await _baseDatabase();
    addTearDown(database.close);
    await database.createManualTransaction(
      NewTransactionInput(
        kind: 'expense',
        amountCents: 10000,
        description: 'Compra no credito',
        accountId: 'nu-card-account',
        occurredAt: DateTime(2026, 8, 10),
        payerPersonId: null,
      ),
    );
    final transferId = await database.createManualTransaction(
      NewTransactionInput(
        kind: 'transfer',
        amountCents: -10000,
        description: 'Pagamento fatura Nubank',
        accountId: 'nu-bank',
        occurredAt: DateTime(2026, 8, 27),
        payerPersonId: null,
      ),
    );
    const invoiceId = 'invoice-nu-card-2026-08';

    final suggestions = await database.listInvoicePaymentSuggestions(invoiceId);
    final before = await database.getCreditCardInvoiceSummary(invoiceId);

    expect(suggestions.single.transaction.id, transferId);
    expect(suggestions.single.amountCents, 10000);
    expect(before.paidCents, 0);
    expect(before.outstandingCents, 10000);
    expect(
      (await database.getTransaction(transferId))?.transferToAccountId,
      isNull,
    );

    await database.confirmInvoicePaymentSuggestion(
      invoiceId: invoiceId,
      transactionId: transferId,
    );
    final after = await database.getCreditCardInvoiceSummary(invoiceId);

    expect(after.paidCents, 10000);
    expect(after.outstandingCents, 0);
    expect(after.transactions, hasLength(1));
    expect(
      (await database.getTransaction(transferId))?.transferToAccountId,
      'nu-card-account',
    );
    expect(await database.listInvoicePaymentSuggestions(invoiceId), isEmpty);
  });

  test(
    'OFX bancario concilia pagamento e OFX do cartao projeta parcelas',
    () async {
      final database = await _baseDatabase();
      addTearDown(database.close);

      final cardBatch = await database.importStatementFile(
        fileName: 'nubank-cartao.ofx',
        bytes: utf8.encode(
          _ofx(
            container: 'CC',
            accountId: '9999888877774321',
            fitId: 'purchase-2-of-3',
            amount: '-100.00',
            name: 'Loja Moveis 02/03',
            postedAt: '20260810',
          ),
        ),
      );
      await database.confirmImportTarget(
        batchId: cardBatch.batch.id,
        accountId: 'nu-card-account',
      );
      expect(await database.promoteImportBatchToReview(cardBatch.batch.id), 1);

      final bankBatch = await database.importStatementFile(
        fileName: 'nubank-conta.ofx',
        bytes: utf8.encode(
          _ofx(
            container: 'BANK',
            accountId: '0000000000009876',
            fitId: 'invoice-payment',
            amount: '-100.00',
            name: 'Pagamento fatura Nubank',
            postedAt: '20260827',
          ),
        ),
      );
      await database.confirmImportTarget(
        batchId: bankBatch.batch.id,
        accountId: 'nu-bank',
      );
      expect(await database.promoteImportBatchToReview(bankBatch.batch.id), 1);

      const augustInvoice = 'invoice-nu-card-2026-08';
      final suggestions = await database.listInvoicePaymentSuggestions(
        augustInvoice,
      );
      expect(suggestions, hasLength(1));
      expect(suggestions.single.fromOfx, isTrue);
      expect(suggestions.single.explanation, contains('saldo em aberto'));

      final projections = await database.listInvoiceInstallmentProjections();
      expect(projections, hasLength(1));
      expect(projections.single.invoiceId, 'invoice-nu-card-2026-09');
      expect(projections.single.installmentNumber, 3);
      expect(projections.single.amountCents, 10000);
      expect(await database.ensureInstallmentProjectionInvoices(), 1);

      final transactionCountBefore =
          (await database.watchAllTransactions().first).length;
      await database.confirmInvoicePaymentSuggestion(
        invoiceId: augustInvoice,
        transactionId: suggestions.single.transaction.id,
      );
      final payment = (await database.listInvoicePayments(
        augustInvoice,
      )).single;
      final august = await database.getCreditCardInvoiceSummary(augustInvoice);
      final september = await database.getCreditCardInvoiceSummary(
        'invoice-nu-card-2026-09',
      );

      expect(payment.origin, 'ofx_reconciled');
      expect(august.totalCents, 10000);
      expect(august.paidCents, 10000);
      expect(september.totalCents, 0);
      expect(september.installmentProjections, hasLength(1));
      expect(
        (await database.watchAllTransactions().first).length,
        transactionCountBefore,
      );

      final finalInstallmentBatch = await database.importStatementFile(
        fileName: 'nubank-cartao-setembro.ofx',
        bytes: utf8.encode(
          _ofx(
            container: 'CC',
            accountId: '9999888877774321',
            fitId: 'purchase-3-of-3',
            amount: '-100.00',
            name: 'Loja Moveis 03/03',
            postedAt: '20260910',
          ),
        ),
      );
      await database.confirmImportTarget(
        batchId: finalInstallmentBatch.batch.id,
        accountId: 'nu-card-account',
      );
      expect(
        await database.promoteImportBatchToReview(
          finalInstallmentBatch.batch.id,
        ),
        1,
      );
      final realizedSeptember = await database.getCreditCardInvoiceSummary(
        'invoice-nu-card-2026-09',
      );
      expect(realizedSeptember.totalCents, 10000);
      expect(realizedSeptember.installmentProjections, isEmpty);
      expect(
        (await database.watchAllTransactions().first).length,
        transactionCountBefore + 1,
      );
    },
  );

  for (final size in [const Size(360, 800), const Size(390, 844)]) {
    testWidgets(
      'conciliacao e projecao cabem em ${size.width.toInt()}px com texto 1.3',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.platformDispatcher.clearTextScaleFactorTestValue();
        });
        final database = await _databaseWithImportedInstallmentAndPayment();
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
        final list = find.byKey(const Key('invoice-list'));

        await _scrollUntilFound(tester, list, find.text('Revisar e confirmar'));
        expect(find.text('SUGESTÕES DE PAGAMENTO'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Revisar e confirmar'));
        await tester.pumpAndSettle();
        expect(find.text('Confirmar pagamento?'), findsOneWidget);
        await tester.tap(find.text('Agora não'));
        await tester.pumpAndSettle();
        expect(
          await database.listInvoicePayments('invoice-nu-card-2026-08'),
          isEmpty,
        );

        await tester.drag(list, const Offset(0, 1000));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('setembro 2026'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('setembro 2026'));
        await tester.pumpAndSettle();
        await _scrollUntilFound(
          tester,
          list,
          find.text('Parcela 3/3 · projetada'),
        );
        expect(find.text('Parcela 3/3 · projetada'), findsOneWidget);
        expect(find.text('Previsão, não nova despesa'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

Future<void> _scrollUntilFound(
  WidgetTester tester,
  Finder scrollable,
  Finder target,
) async {
  for (var attempt = 0; attempt < 12; attempt += 1) {
    if (target.evaluate().isNotEmpty) {
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
      return;
    }
    await tester.drag(scrollable, const Offset(0, -260));
    await tester.pumpAndSettle();
  }
  fail('Widget não encontrado: $target');
}

Future<AppDatabase> _baseDatabase() async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  await database.upsertAccount(
    id: 'nu-bank',
    provider: 'nubank',
    name: 'Nubank conta',
    type: 'checking',
    ownerPersonId: null,
    last4: '9876',
  );
  await database.upsertCreditCard(
    id: 'nu-card',
    accountId: 'nu-card-account',
    provider: 'nubank',
    name: 'Nubank crédito',
    ownerPersonId: null,
    last4: '4321',
    billingDay: 20,
    dueDay: 27,
  );
  return database;
}

Future<AppDatabase> _databaseWithImportedInstallmentAndPayment() async {
  final database = await _baseDatabase();
  final cardBatch = await database.importStatementFile(
    fileName: 'nubank-cartao.ofx',
    bytes: utf8.encode(
      _ofx(
        container: 'CC',
        accountId: '9999888877774321',
        fitId: 'widget-purchase',
        amount: '-100.00',
        name: 'Loja Moveis 02/03',
        postedAt: '20260810',
      ),
    ),
  );
  await database.confirmImportTarget(
    batchId: cardBatch.batch.id,
    accountId: 'nu-card-account',
  );
  await database.promoteImportBatchToReview(cardBatch.batch.id);
  final bankBatch = await database.importStatementFile(
    fileName: 'nubank-conta.ofx',
    bytes: utf8.encode(
      _ofx(
        container: 'BANK',
        accountId: '0000000000009876',
        fitId: 'widget-payment',
        amount: '-100.00',
        name: 'Pagamento fatura Nubank',
        postedAt: '20260827',
      ),
    ),
  );
  await database.confirmImportTarget(
    batchId: bankBatch.batch.id,
    accountId: 'nu-bank',
  );
  await database.promoteImportBatchToReview(bankBatch.batch.id);
  return database;
}

String _ofx({
  required String container,
  required String? accountId,
  required String fitId,
  required String amount,
  required String name,
  required String postedAt,
}) {
  final accountBlock = container == 'CC'
      ? '<CCACCTFROM>${accountId == null ? '' : '<ACCTID>$accountId'}</CCACCTFROM>'
      : '<BANKACCTFROM><BANKID>260${accountId == null ? '' : '<ACCTID>$accountId'}<ACCTTYPE>CHECKING</BANKACCTFROM>';
  return '''
<OFX><SONRS><FI><ORG>Nubank</FI></SONRS>
<$container${container == 'CC' ? 'STMTRS' : 'MSGSRSV1'}>
<CURDEF>BRL
$accountBlock
<BANKTRANLIST><DTSTART>20260801000000<DTEND>20260930235959
<STMTTRN><DTPOSTED>$postedAt<TRNAMT>$amount<FITID>$fitId<NAME>$name</STMTTRN>
</BANKTRANLIST>
</$container${container == 'CC' ? 'STMTRS' : 'MSGSRSV1'}></OFX>
''';
}
