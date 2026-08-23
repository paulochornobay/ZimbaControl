import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/dashboard_page.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/duplicates_page.dart';
import 'package:zimba_control/src/presentation/import_page.dart';
import 'package:zimba_control/src/presentation/movements_page.dart';

void main() {
  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets('Marco E regressão operacional em ${size.width.toInt()}px', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.2;
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(() async {
        await database.close();
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });

      await database.saveInitialSetup(
        const SetupInput(
          personName: 'Responsável com nome familiar bastante extenso',
          accountName: 'Conta principal com nome longo para regressão visual',
          accountProvider: 'manual',
        ),
      );
      final startup = await database.getStartupState();
      await database.createManualTransaction(
        NewTransactionInput(
          kind: 'expense',
          amountCents: -987654321,
          description:
              'Lançamento muito extenso para garantir leitura em telas compactas durante a regressão visual',
          accountId: startup.primaryAccountId!,
          payerPersonId: startup.primaryPersonId,
          beneficiaryIds: [startup.primaryPersonId!],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: DashboardPage(database: database),
        ),
      );
      await _pumpUntilFound(tester, find.text('SALDO DO MÊS'));
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: MovementsPage(database: database),
        ),
      );
      await _pumpUntilFound(tester, find.byType(MovementTotalsCard));
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: DuplicatesPage(database: database),
        ),
      );
      await _pumpUntilFound(tester, find.text('Sem duplicidades abertas'));
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: ImportPage(database: database),
        ),
      );
      expect(find.text('Importação local'), findsOneWidget);
      expect(find.text('Escolher arquivo'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    });
  }
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 25)),
    );
    await tester.pump();
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Widget não encontrado após aguardar o carregamento: $finder');
}
