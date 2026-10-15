import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/commitments_page.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/family_structure_page.dart';
import 'package:zimba_control/src/presentation/invoices_page.dart';
import 'package:zimba_control/src/presentation/registries_page.dart';

void main() {
  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets('Marco 5 preserva estados vazios em ${size.width}px', (
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

      await _pump(tester, RegistriesPage(database: database));
      await _waitFor(tester, find.text('Nenhuma pessoa'));
      expect(tester.takeException(), isNull);

      await database.saveInitialSetup(
        const SetupInput(
          personName: 'Responsável da família',
          accountName: 'Conta para testar estados vazios',
          accountProvider: 'manual',
          createStarterCategories: false,
        ),
      );
      await _pump(tester, CommitmentsPage(database: database));
      await _waitFor(tester, find.text('Nenhuma recorrencia'));
      expect(tester.takeException(), isNull);

      await _pump(
        tester,
        InvoicesPage(database: database, referenceDate: DateTime(2026, 8, 15)),
      );
      await _waitFor(tester, find.text('Nenhum cartão cadastrado'));
      expect(tester.takeException(), isNull);

      await _pump(tester, FamilyStructurePage(database: database));
      await _waitFor(tester, find.text('Estrutura da família'));
      expect(
        find.text('1 pessoa(s), 1 conta(s) e 0 cartão(ões).'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'Marco 5 mantém instrumentos e compromissos ativos em ${size.width}px',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.platformDispatcher.clearTextScaleFactorTestValue();
        });
        final database = await _populatedDatabase();
        addTearDown(database.close);

        await _pump(
          tester,
          RegistriesPage(database: database, initialTabIndex: 1),
        );
        await _waitFor(
          tester,
          find.text('Conta Nubank da família com descrição muito longa'),
        );
        expect(
          find.text('Cartão Nubank do mesmo banco e titular com nome longo'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        await _pump(tester, CommitmentsPage(database: database));
        await _waitFor(tester, find.text('Recorrencias ativas'));
        expect(
          find.text('Compromisso ativo com descrição longa para validação'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}

Future<AppDatabase> _populatedDatabase() async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  await database.saveInitialSetup(
    const SetupInput(
      personName: 'Responsável familiar com nome muito longo',
      accountName: 'Conta Nubank da família com descrição muito longa',
      accountProvider: 'nubank',
      createStarterCategories: false,
    ),
  );
  final startup = await database.getStartupState();
  await database.upsertCreditCard(
    id: 'marco-5-nubank-card',
    accountId: 'marco-5-nubank-card-account',
    provider: 'nubank',
    name: 'Cartão Nubank do mesmo banco e titular com nome longo',
    ownerPersonId: startup.primaryPersonId!,
    last4: '1234',
    billingDay: 20,
    dueDay: 27,
  );
  await database.upsertRecurringSchedule(
    id: 'marco-5-active-schedule',
    label: 'Compromisso ativo com descrição longa para validação',
    kind: 'expense',
    amountCents: -123456789,
    dayOfMonth: 12,
    startMonth: '2026-08',
    payerPersonId: startup.primaryPersonId,
    beneficiaryPersonId: startup.primaryPersonId,
    fromAccountId: startup.primaryAccountId,
    toAccountId: null,
    categoryId: null,
    costCenterId: null,
  );
  return database;
}

Future<void> _pump(WidgetTester tester, Widget page) =>
    tester.pumpWidget(MaterialApp(theme: ZimbaTheme.light, home: page));

Future<void> _waitFor(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 60; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 20));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Widget não encontrado: $finder');
}
