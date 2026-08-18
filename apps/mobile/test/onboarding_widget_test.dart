import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/main.dart';
import 'package:zimba_control/src/application/import_parser.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/import_page.dart';
import 'package:zimba_control/src/presentation/new_transaction_page.dart';
import 'package:zimba_control/src/presentation/review_page.dart';

void main() {
  for (final size in const [Size(360, 800), Size(393, 873), Size(412, 915)]) {
    testWidgets('fresh onboarding fits ${size.width.toInt()}px', (
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

      await tester.pumpWidget(ZimbaControlApp(database: database));
      await tester.pumpAndSettle();

      expect(find.text('Suas finanças,\nsem bagunça.'), findsOneWidget);
      expect(find.text('Configurar meus dados'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('CSV mapping fits a small screen with larger text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    final inspection = inspectCsvFile(
      fileName: 'extrato.csv',
      bytes: utf8.encode(
        'Quando;Histórico detalhado;Valor da compra;Identificador externo\n'
        '22/07/2026;Padaria;-18,40;linha-1',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ZimbaTheme.light,
        home: CsvMappingPage(
          fileName: 'extrato_com_nome_muito_comprido.csv',
          inspection: inspection,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Mapear colunas'), findsOneWidget);
    expect(find.text('Gerar prévia'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('new transaction uses configured account without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetViewInsets();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.saveInitialSetup(
      const SetupInput(
        personName: 'Pessoa com nome bastante comprido',
        accountName: 'Conta principal com nome longo',
        accountProvider: 'manual',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ZimbaTheme.light,
        home: NewTransactionPage(
          database: database,
          onSaved: () {},
          onOpenSettings: () {},
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Novo lançamento'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();
    expect(tester.takeException(), isNull);

    tester.view.resetViewInsets();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await database.close();
  });

  testWidgets('review handles 30 long transactions and large values', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.saveInitialSetup(
      const SetupInput(
        personName: 'Pessoa principal com nome muito comprido',
        accountName: 'Conta principal com nome igualmente comprido',
        accountProvider: 'manual',
      ),
    );
    final startup = await database.getStartupState();
    for (var index = 0; index < 30; index += 1) {
      await database.createManualTransaction(
        NewTransactionInput(
          kind: 'expense',
          amountCents: 999999999 - index,
          description:
              'Movimentação extensa para validar cortes e responsividade número $index',
          accountId: startup.primaryAccountId!,
          payerPersonId: startup.primaryPersonId!,
          beneficiaryIds: [startup.primaryPersonId!],
        ),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        theme: ZimbaTheme.light,
        home: ReviewPage(database: database),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

      expect(find.text('Caixa de revisão'), findsOneWidget);
    expect(find.byType(ReviewTransactionCard), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.drag(
      find.byType(ReviewTransactionCard).first,
      const Offset(0, -3000),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
  });
}
