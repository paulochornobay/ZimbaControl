import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/import_page.dart';

void main() {
  test(
    'OFX bancário e de cartão Nubank usam somente o destino confirmado',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database.upsertPerson(
        id: 'paulo',
        displayName: 'Paulo',
        kind: 'adult',
      );
      await database.upsertAccount(
        id: 'nu-bank',
        provider: 'nubank',
        name: 'Nubank corrente',
        type: 'checking',
        ownerPersonId: 'paulo',
        last4: '6789',
      );
      await database.upsertCreditCard(
        id: 'nu-card',
        accountId: 'nu-card-account',
        provider: 'nubank',
        name: 'Nubank crédito',
        ownerPersonId: 'paulo',
        last4: '4321',
        billingDay: 20,
        dueDay: 27,
      );
      await database.upsertCreditCard(
        id: 'nu-card-other',
        accountId: 'nu-card-other-account',
        provider: 'nubank',
        name: 'Nubank adicional',
        ownerPersonId: 'paulo',
        last4: '1111',
        billingDay: 15,
        dueDay: 22,
      );

      final bankBatch = await database.importStatementFile(
        fileName: 'nubank-conta.ofx',
        bytes: utf8.encode(
          _ofx(
            container: 'BANK',
            accountId: '000123456789',
            fitId: 'bank-1',
            amount: '-25.90',
          ),
        ),
      );
      final bankTargets = await database.getImportTargetOptions(
        bankBatch.batch.id,
      );
      expect(bankTargets.suggestedAccountId, 'nu-bank');
      expect(
        bankTargets.options
            .firstWhere(
              (option) => option.instrument.account.id == 'nu-card-account',
            )
            .assessment
            .compatible,
        isFalse,
      );
      await expectLater(
        database.promoteImportBatchToReview(bankBatch.batch.id),
        throwsStateError,
      );
      await expectLater(
        database.confirmImportTarget(
          batchId: bankBatch.batch.id,
          accountId: 'nu-card-account',
        ),
        throwsStateError,
      );
      await database.confirmImportTarget(
        batchId: bankBatch.batch.id,
        accountId: 'nu-bank',
      );
      expect(await database.promoteImportBatchToReview(bankBatch.batch.id), 1);

      final cardBatch = await database.importStatementFile(
        fileName: 'nubank-cartao.ofx',
        bytes: utf8.encode(
          _ofx(
            container: 'CC',
            accountId: '9999888877774321',
            fitId: 'card-1',
            amount: '-89.90',
          ),
        ),
      );
      final cardTargets = await database.getImportTargetOptions(
        cardBatch.batch.id,
      );
      expect(cardTargets.suggestedAccountId, 'nu-card-account');
      await expectLater(
        database.confirmImportTarget(
          batchId: cardBatch.batch.id,
          accountId: 'nu-card-other-account',
        ),
        throwsStateError,
      );
      await database.confirmImportTarget(
        batchId: cardBatch.batch.id,
        accountId: 'nu-card-account',
      );
      expect(await database.promoteImportBatchToReview(cardBatch.batch.id), 1);

      final pending = await database.watchPendingReview().first;
      expect(
        pending
            .where((transaction) => transaction.descriptionRaw == 'Teste')
            .map((transaction) => transaction.accountId)
            .toSet(),
        {'nu-bank', 'nu-card-account'},
      );
    },
  );

  test('OFX sem ACCTID bloqueia sugestão quando há dois cartões', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    for (final entry in [('card-a', '1111'), ('card-b', '2222')]) {
      await database.upsertCreditCard(
        id: entry.$1,
        accountId: '${entry.$1}-account',
        provider: 'nubank',
        name: entry.$1,
        ownerPersonId: null,
        last4: entry.$2,
        billingDay: 20,
        dueDay: 27,
      );
    }
    final batch = await database.importStatementFile(
      fileName: 'nubank-cartao.ofx',
      bytes: utf8.encode(
        _ofx(
          container: 'CC',
          accountId: null,
          fitId: 'missing-account',
          amount: '-1.00',
        ),
      ),
    );

    final targets = await database.getImportTargetOptions(batch.batch.id);
    expect(targets.ambiguous, isTrue);
    expect(targets.suggestedAccountId, isNull);
    expect(
      targets.options.where((option) => option.assessment.compatible),
      hasLength(2),
    );
  });

  test('backup de lote anterior à fase 3 continua restaurável', () async {
    final source = AppDatabase.forTesting(NativeDatabase.memory());
    await source.importStatementFile(
      fileName: 'nubank.csv',
      bytes: utf8.encode('Data;Descricao;Valor\n2026-08-10;Teste;-1,00'),
    );
    final backup = await source.exportBackupFile();
    await source.close();
    final json = jsonDecode(utf8.decode(backup.bytes)) as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;
    const phase3Fields = {
      'statementType',
      'statementAccountId',
      'statementBankId',
      'statementBranchId',
      'statementAccountType',
      'currencyCode',
      'periodStart',
      'periodEnd',
      'ledgerBalanceCents',
      'availableBalanceCents',
      'targetAccountId',
      'targetConfirmedAt',
      'targetMatchReason',
    };
    for (final row in data['importBatches'] as List<dynamic>) {
      (row as Map<String, dynamic>).removeWhere(
        (key, _) => phase3Fields.contains(key),
      );
    }
    final target = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(target.close);

    final restored = await target.restoreBackupBytes(
      utf8.encode(jsonEncode(json)),
    );
    final batch = (await target.listImportBatches()).single;
    expect(restored.valid, isTrue);
    expect(batch.statementType, 'unknown');
    expect(batch.currencyCode, 'BRL');
    expect(batch.targetAccountId, isNull);
  });

  for (final size in [const Size(360, 800), const Size(390, 844)]) {
    testWidgets('prévia confirmada cabe em ${size.width.toInt()}px', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database.upsertAccount(
        id: 'nu-bank',
        provider: 'nubank',
        name: 'Nubank corrente principal com nome extenso',
        type: 'checking',
        ownerPersonId: null,
        last4: '6789',
      );
      final batch = await database.importStatementFile(
        fileName: 'extrato_nubank_agosto_2026_com_nome_extenso.ofx',
        bytes: utf8.encode(
          _ofx(
            container: 'BANK',
            accountId: '000123456789',
            fitId: 'responsive',
            amount: '-123456.78',
          ),
        ),
      );
      await database.confirmImportTarget(
        batchId: batch.batch.id,
        accountId: 'nu-bank',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: ImportPage(database: database),
        ),
      );
      await _pumpUntilFound(tester, find.text('DESTINO CONFIRMADO'));
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('instrumento ausente pode ser cadastrado dentro do lote', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database.upsertPerson(
      id: 'paulo',
      displayName: 'Paulo',
      kind: 'adult',
    );
    final batch = await database.importStatementFile(
      fileName: 'nubank-conta.ofx',
      bytes: utf8.encode(
        _ofx(
          container: 'BANK',
          accountId: '000000009876',
          fitId: 'new-account',
          amount: '-10.00',
        ),
      ),
    );
    ImportBatchDetails? confirmed;

    await tester.pumpWidget(
      MaterialApp(
        theme: ZimbaTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ImportBatchView(
              database: database,
              details: batch,
              onTargetConfirmed: (value) => confirmed = value,
              onPromote: null,
            ),
          ),
        ),
      ),
    );
    await _pumpUntilFound(tester, find.text('Cadastrar conta'));
    expect(find.text('Nenhum instrumento compatível'), findsOneWidget);
    await tester.ensureVisible(find.text('Cadastrar conta'));
    await tester.tap(find.text('Cadastrar conta'));
    await _pumpForAsync(tester);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Nubank nova');
    await tester.tap(find.byTooltip('Salvar'));
    await _pumpUntilFound(tester, find.text('Nubank nova'));
    await tester.ensureVisible(
      find.byKey(const ValueKey('confirm-import-target')),
    );
    await tester.tap(find.byKey(const ValueKey('confirm-import-target')));
    await _pumpForAsync(tester);

    expect(confirmed?.batch.targetAccountId, isNotNull);
    expect(confirmed?.batch.targetConfirmedAt, isNotNull);
    final target = await database.getImportTargetOptions(batch.batch.id);
    expect(
      target.options
          .firstWhere(
            (option) =>
                option.instrument.account.id ==
                confirmed!.batch.targetAccountId,
          )
          .instrument
          .account
          .last4,
      '9876',
    );
  });
}

String _ofx({
  required String container,
  required String? accountId,
  required String fitId,
  required String amount,
}) {
  final accountBlock = container == 'CC'
      ? '<CCACCTFROM>${accountId == null ? '' : '<ACCTID>$accountId'}</CCACCTFROM>'
      : '<BANKACCTFROM><BANKID>260${accountId == null ? '' : '<ACCTID>$accountId'}<ACCTTYPE>CHECKING</BANKACCTFROM>';
  return '''
<OFX><SONRS><FI><ORG>Nubank</FI></SONRS>
<$container${container == 'CC' ? 'STMTRS' : 'MSGSRSV1'}>
<CURDEF>BRL
$accountBlock
<BANKTRANLIST><DTSTART>20260801000000<DTEND>20260831235959
<STMTTRN><DTPOSTED>20260810<TRNAMT>$amount<FITID>$fitId<NAME>Teste</STMTTRN>
</BANKTRANLIST>
</$container${container == 'CC' ? 'STMTRS' : 'MSGSRSV1'}></OFX>
''';
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 60; attempt += 1) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 20));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Widget não encontrado: $finder');
}

Future<void> _pumpForAsync(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 160)),
  );
  await tester.pump(const Duration(milliseconds: 160));
}
