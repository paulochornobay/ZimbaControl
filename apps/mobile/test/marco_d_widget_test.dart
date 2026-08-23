import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/family_structure_page.dart';
import 'package:zimba_control/src/presentation/feature_availability_page.dart';
import 'package:zimba_control/src/presentation/registries_page.dart';

void main() {
  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets('Marco D jornadas cabem em ${size.width.toInt()}px', (
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
          personName: 'Responsável familiar com um nome deliberadamente longo',
          accountName: 'Conta de uso diário com uma descrição longa',
          accountProvider: 'nubank',
        ),
      );
      await database.upsertPerson(
        displayName: 'Dependente com nome completo muito extenso para a lista',
        kind: 'child',
      );
      final categoryId = await database.upsertCategory(
        name: 'Alimentação e despesas domésticas com descrição longa',
        kind: 'expense',
        sortOrder: 10,
      );
      await database.upsertClassificationRule(
        name: 'Regra longa para compras recorrentes da família',
        matchText: 'supermercado e compras mensais',
        kind: 'expense',
        categoryId: categoryId,
        costCenterId: null,
        priority: 999,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: FamilyStructurePage(database: database),
        ),
      );
      await _pumpUntilFound(tester, find.text('Estrutura da família'));
      expect(find.text('Estrutura da família'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: RegistriesPage(database: database),
        ),
      );
      await _pumpUntilFound(
        tester,
        find.textContaining('Responsável familiar'),
      );
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: RulesPreviewPage(database: database),
        ),
      );
      await _pumpUntilFound(tester, find.textContaining('Regra longa'));
      expect(find.textContaining('prioridade 999'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: BackupSettingsPage(database: database),
        ),
      );
      expect(find.text('Backup local versionado'), findsOneWidget);
      expect(find.text('Restaurar'), findsOneWidget);
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
