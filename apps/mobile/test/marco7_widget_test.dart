import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/application/app_reset_coordinator.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/onboarding_page.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test(
    'instalação limpa só recebe demonstração por escolha explícita',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      expect((await database.getLocalDataStatus()).isEmpty, isTrue);
      expect((await database.getStartupState()).needsOnboarding, isTrue);

      await database.completeDemoOnboarding();

      expect((await database.getStartupState()).needsOnboarding, isFalse);
      expect(
        (await database.getLocalDataStatus()).transactions,
        greaterThan(0),
      );
    },
  );

  test(
    'setup transacional cria conta ou cartão e somente categorias escolhidas',
    () async {
      final accountDatabase = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(accountDatabase.close);
      await accountDatabase.saveInitialSetup(
        const SetupInput(
          personName: 'Marina',
          accountName: 'Conta Inter',
          accountProvider: 'inter',
          accountType: 'checking',
          starterCategoryKeys: ['FOOD'],
        ),
      );
      final accountRegistry = await accountDatabase.getRegistrySnapshot();
      expect(accountRegistry.accounts.single.account.type, 'checking');
      expect(accountRegistry.creditCards, isEmpty);
      expect(
        accountRegistry.categories.map((item) => item.systemKey),
        contains('FOOD'),
      );
      expect(
        accountRegistry.categories.map((item) => item.systemKey),
        isNot(contains('TRANSPORT')),
      );
      expect(await accountDatabase.watchAllTransactions().first, isEmpty);

      final cardDatabase = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(cardDatabase.close);
      await cardDatabase.saveInitialSetup(
        const SetupInput(
          personName: 'Paulo',
          accountName: 'Nubank pessoal',
          accountProvider: 'nubank',
          accountType: 'credit_card',
          cardBrand: 'Visa',
          last4: '1234',
          billingDay: 20,
          dueDay: 27,
          starterCategoryKeys: ['FOOD', 'SALARY'],
        ),
      );
      final cardRegistry = await cardDatabase.getRegistrySnapshot();
      expect(cardRegistry.creditCards, hasLength(1));
      final card = cardRegistry.creditCards.single.creditCard;
      expect(card.brand, 'Visa');
      expect(card.last4, '1234');
      expect(card.billingDay, 20);
      expect(card.dueDay, 27);
      expect(cardRegistry.accounts.single.account.type, 'credit_card');
      expect(await cardDatabase.watchAllTransactions().first, isEmpty);
    },
  );

  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets(
      'Marco 7 preserva respostas e conclui cartão em ${size.width.toInt()}px',
      (tester) async {
        _configureView(tester, size);
        final database = AppDatabase.forTesting(NativeDatabase.memory());
        addTearDown(() async {
          await database.close();
          _resetView(tester);
        });

        await _pump(tester, database, () {});
        expect(find.text('Demonstração é opcional'), findsOneWidget);
        await tester.tap(find.byTooltip('Fechar configuração'));
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Sair da configuração?'), findsOneWidget);
        await tester.tap(find.text('Continuar configurando'));
        await tester.pump(const Duration(seconds: 1));
        expect((await database.getLocalDataStatus()).isEmpty, isTrue);

        await tester.tap(find.text('Começar configuração'));
        await tester.pump();
        await tester.tap(find.text('Continuar'));
        await tester.pump();
        expect(find.text('Informe como devemos chamar você.'), findsOneWidget);
        await tester.enterText(
          find.byKey(const ValueKey('onboarding-person')),
          'Marina',
        );
        await tester.tap(find.text('Continuar'));
        await tester.pump();
        await tester.tap(find.byTooltip('Voltar'));
        await tester.pump();
        expect(find.text('Marina'), findsOneWidget);
        await tester.tap(find.text('Continuar'));
        await tester.pump();

        await tester.tap(find.text('Nubank'));
        await tester.tap(find.text('Continuar'));
        await tester.pump();
        await tester.tap(find.text('Cartão de crédito'));
        await tester.tap(find.text('Continuar'));
        await tester.pump();
        expect(find.text('Como você chama isso no dia a dia?'), findsOneWidget);
        await tester.enterText(
          find.byKey(const ValueKey('onboarding-name')),
          'Nubank da Marina',
        );
        await tester.enterText(
          find.byKey(const ValueKey('onboarding-last4')),
          '1234',
        );
        await tester.tap(find.text('Continuar'));
        await tester.pump();
        expect(find.text('Dados do cartão'), findsOneWidget);
        await tester.tap(find.text('Visa'));
        await tester.enterText(
          find.byKey(const ValueKey('onboarding-billing-day')),
          '20',
        );
        await tester.enterText(
          find.byKey(const ValueKey('onboarding-due-day')),
          '27',
        );
        await tester.tap(find.text('Continuar'));
        await tester.pump();
        expect(find.text('Categorias para começar'), findsOneWidget);
        await tester.tap(find.text('Mercado'));
        await tester.tap(find.text('Continuar'));
        await tester.pump();
        expect(find.text('Confira antes de concluir'), findsOneWidget);
        expect(find.textContaining('fecha dia 20'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  test('reset volta com segurança para o estado de onboarding', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database.saveInitialSetup(
      const SetupInput(
        personName: 'Ana',
        accountName: 'Conta',
        accountProvider: 'manual',
      ),
    );
    await AppResetCoordinator(
      database: database,
      clearSession: () async {},
    ).resetEverything();

    final startup = await database.getStartupState();
    expect(startup.needsOnboarding, isTrue);
    expect((await database.getLocalDataStatus()).isEmpty, isTrue);
  });
}

Future<void> _pump(
  WidgetTester tester,
  AppDatabase database,
  VoidCallback onCompleted,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ZimbaTheme.light,
      home: OnboardingPage(database: database, onCompleted: onCompleted),
    ),
  );
  await tester.pump();
}

void _configureView(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 1.2;
}

void _resetView(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
  tester.platformDispatcher.clearTextScaleFactorTestValue();
}
