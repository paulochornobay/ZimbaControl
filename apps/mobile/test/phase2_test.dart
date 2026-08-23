import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/application/app_reset_coordinator.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/infrastructure/notification_capture_service.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/family_structure_page.dart';
import 'package:zimba_control/src/presentation/new_transaction_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const notificationChannel = MethodChannel(
    'br.com.zimbacontrol/notifications',
  );

  test(
    'reset coordenado limpa todos os stores e backup continua restaurável',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database.saveInitialSetup(
        const SetupInput(
          personName: 'Paulo',
          accountName: 'Nubank corrente',
          accountProvider: 'nubank',
        ),
      );
      final startup = await database.getStartupState();
      final category = (await database.listCategories()).first;
      await database.upsertClassificationRule(
        name: 'Mercado',
        matchText: 'mercado',
        categoryId: category.id,
        priority: 10,
      );
      await database.createManualTransaction(
        NewTransactionInput(
          kind: 'expense',
          amountCents: 2590,
          description: 'Mercado do bairro',
          accountId: startup.primaryAccountId!,
          payerPersonId: startup.primaryPersonId,
        ),
      );
      await database.recordRawNotificationEvent(
        CapturedNotificationEvent(
          id: 'native-before-reset',
          packageName: 'com.nu.production',
          title: 'Compra aprovada',
          text: 'R\$ 25,90 no Mercado',
          postedAt: DateTime(2026, 8, 23, 10),
          capturedAt: DateTime(2026, 8, 23, 10),
        ),
      );
      final backup = await database.exportBackupFile();
      var nativeReset = false;
      var sessionReset = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(notificationChannel, (call) async {
            if (call.method == 'resetLocalCapture') nativeReset = true;
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(notificationChannel, null),
      );

      await AppResetCoordinator(
        database: database,
        clearSession: () async => sessionReset = true,
      ).resetEverything();

      expect(nativeReset, isTrue);
      expect(sessionReset, isTrue);
      expect((await database.getLocalDataStatus()).isEmpty, isTrue);
      expect((await database.getStartupState()).needsOnboarding, isTrue);
      expect(
        await database.select(database.classificationRules).get(),
        isEmpty,
      );
      expect(await database.select(database.syncOutbox).get(), isEmpty);
      expect(await database.select(database.syncAppliedEvents).get(), isEmpty);
      expect(await database.select(database.syncConflicts).get(), isEmpty);
      expect(
        await database.select(database.rawNotificationEvents).get(),
        isEmpty,
      );

      final restored = await database.restoreBackupBytes(backup.bytes);
      expect(restored.valid, isTrue);
      expect((await database.getLocalDataStatus()).transactions, 1);
      expect((await database.listCategories()).first.iconKey, isNotEmpty);
    },
  );

  test('backup anterior recebe fallback de ícone e cor ao restaurar', () async {
    final source = AppDatabase.forTesting(NativeDatabase.memory());
    await source.saveInitialSetup(
      const SetupInput(
        personName: 'Paulo',
        accountName: 'Conta',
        accountProvider: 'manual',
      ),
    );
    final backup = await source.exportBackupFile();
    await source.close();
    final target = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(target.close);
    final json = jsonDecode(utf8.decode(backup.bytes)) as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;
    for (final row in data['categories'] as List<dynamic>) {
      (row as Map<String, dynamic>)
        ..remove('iconKey')
        ..remove('colorKey');
    }
    for (final row in data['costCenters'] as List<dynamic>) {
      (row as Map<String, dynamic>)
        ..remove('iconKey')
        ..remove('colorKey');
    }

    final restored = await target.restoreBackupBytes(
      utf8.encode(jsonEncode(json)),
    );
    expect(restored.valid, isTrue);
    expect(
      (await target.listCategories()).every((row) => row.iconKey.isNotEmpty),
      isTrue,
    );
    expect(
      (await target.listCostCenters()).every((row) => row.colorKey.isNotEmpty),
      isTrue,
    );
  });

  testWidgets(
    'instrumentos são inequívocos e criação inline volta selecionada',
    (tester) async {
      await _configureView(tester);
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database.saveInitialSetup(
        const SetupInput(
          personName: 'Paulo',
          accountName: 'Nubank corrente',
          accountProvider: 'nubank',
          createStarterCategories: false,
        ),
      );
      final startup = await database.getStartupState();
      await database.upsertAccount(
        provider: 'nubank',
        name: 'Nubank corrente',
        type: 'checking',
        ownerPersonId: startup.primaryPersonId,
        last4: '9876',
      );
      await database.upsertCreditCard(
        provider: 'nubank',
        name: 'Nubank crédito',
        ownerPersonId: startup.primaryPersonId,
        last4: '4321',
        billingDay: 20,
        dueDay: 27,
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
      await _pumpUntilFound(tester, find.text('Nubank crédito'));

      expect(find.textContaining('Conta corrente'), findsAtLeastNWidgets(1));
      expect(find.textContaining('Cartão de crédito'), findsOneWidget);
      expect(find.text('•••• 9876'), findsOneWidget);
      expect(find.text('•••• 4321'), findsOneWidget);

      await tester.tap(find.text('Criar').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Saúde do pet');
      await tester.tap(find.text('Sugerir'));
      tester.testTextInput.hide();
      await tester.pump();
      await tester.tap(find.byTooltip('Salvar'));
      await _pumpForAsync(tester);
      await _pumpUntilFound(tester, find.byType(Scrollable));
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      await _pumpUntilFound(tester, find.text('CENTRO DE CUSTO'));
      await tester.tap(find.text('Criar').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Filhos');
      await tester.tap(find.text('Sugerir'));
      tester.testTextInput.hide();
      await tester.pump();
      await tester.tap(find.byTooltip('Salvar'));
      await _pumpForAsync(tester);
      await _pumpUntilFound(
        tester,
        find.byKey(const ValueKey('new-transaction-amount')),
      );

      await tester.enterText(
        find.byKey(const ValueKey('new-transaction-amount')),
        '25,90',
      );
      await tester.enterText(
        find.byKey(const ValueKey('new-transaction-description')),
        'Consulta veterinária',
      );
      await tester.scrollUntilVisible(
        find.text('Adicionar lançamento'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Adicionar lançamento'));
      await tester.pump(const Duration(milliseconds: 500));

      final transaction = await database
          .select(database.transactions)
          .getSingle();
      final category = await (database.select(
        database.categories,
      )..where((row) => row.id.equals(transaction.categoryId!))).getSingle();
      final center = await (database.select(
        database.costCenters,
      )..where((row) => row.id.equals(transaction.costCenterId!))).getSingle();
      expect(category.name, 'Saúde do pet');
      expect(category.iconKey, 'health');
      expect(center.name, 'Filhos');
      expect(center.iconKey, 'child');
      await _disposeWidget(tester);
    },
  );

  testWidgets('reset exige a palavra ZERAR e explica permissões preservadas', (
    tester,
  ) async {
    await _configureView(tester);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database.loadDemoData();
    await tester.pumpWidget(
      MaterialApp(
        theme: ZimbaTheme.light,
        home: DataEnvironmentPage(database: database, onChanged: () {}),
      ),
    );
    await _pumpUntilFound(tester, find.text('Zerar aplicativo'));
    await tester.tap(find.text('Zerar aplicativo'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('permissões concedidas pelo Android'),
      findsOneWidget,
    );
    final confirmFinder = find.widgetWithText(
      FilledButton,
      'Apagar tudo e voltar ao início',
    );
    expect(tester.widget<FilledButton>(confirmFinder).onPressed, isNull);
    await tester.enterText(find.byType(TextField).last, 'ZERAR');
    await tester.pump();
    expect(tester.widget<FilledButton>(confirmFinder).onPressed, isNotNull);
    await tester.tap(find.byTooltip('Fechar'));
    await tester.pumpAndSettle();
    await _disposeWidget(tester);
  });
}

Future<void> _configureView(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 1.2;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 60; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 20));
    if (finder.evaluate().isNotEmpty) return;
  }
  final visibleTexts = find
      .byType(Text)
      .evaluate()
      .map((element) => (element.widget as Text).data)
      .whereType<String>()
      .join(' | ');
  fail('Widget não encontrado após aguardar: $finder. Tela: $visibleTexts');
}

Future<void> _disposeWidget(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 20)),
  );
  await tester.pump(const Duration(milliseconds: 20));
}

Future<void> _pumpForAsync(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 120)),
  );
  await tester.pump(const Duration(milliseconds: 120));
}
