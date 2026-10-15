import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/application/dashboard_summary.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/dashboard_page.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/reports_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Marco 4 mantém pendências e transferências fora dos totais', () async {
    final database = await _database();
    addTearDown(database.close);
    final details = await database.watchAllTransactionDetails().first;
    final structure = await database.getFamilyStructureSnapshot();

    final summary = buildOperationalDashboardSummary(
      details: details,
      recurringSchedules: structure.recurringSchedules,
      installmentPlans: structure.installmentPlans,
      now: DateTime(2026, 8, 23),
    );

    expect(summary.incomeCents, 999999999);
    expect(summary.expenseCents, -444444444);
    expect(summary.balanceCents, 555555555);
    expect(summary.transferCents, 333333333);
    expect(summary.pendingCount, 1);
    expect(summary.pendingCents, -22222);
    expect(summary.byCategory.single.label, 'Categoria longa Marco 4');
  });

  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets('Marco 4 relatórios funcionam em ${size.width}px', (
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
      final database = await _database();
      addTearDown(database.close);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: DashboardPage(
            database: database,
            referenceDate: DateTime(2026, 8, 23),
          ),
        ),
      );
      await _waitFor(tester, find.text('SALDO DO MÊS'));
      expect(find.text('Ver relatórios mensais e parcelas'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: MonthlyReportPage(
            key: const ValueKey('monthly-reset'),
            database: database,
            initialMonth: '2026-08',
          ),
        ),
      );
      await _waitFor(tester, find.text('Receitas'));
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(find.text('1 pendência(s) de revisão'), findsOneWidget);
      expect(find.text('Categoria longa Marco 4'), findsOneWidget);
      await tester.ensureVisible(find.text('Contexto'));
      await tester.tap(find.text('Contexto'));
      await tester.pump();
      expect(find.text('Contexto familiar longo Marco 4'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: MonthlyReportPage(
            key: const ValueKey('monthly-empty'),
            database: database,
            initialMonth: '2026-08',
          ),
        ),
      );
      await _waitFor(tester, find.byIcon(Icons.chevron_right));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();
      expect(find.text('Mês vazio'), findsOneWidget);
      expect(tester.takeException(), isNull);

      final countBefore =
          (await database.select(database.transactions).get()).length;
      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: FutureCommitmentsReportPage(
            database: database,
            referenceDate: DateTime(2026, 8, 23),
          ),
        ),
      );
      await _waitFor(tester, find.text('Plano longo de parcela Marco 4'));
      expect(find.text('Parcela 1/3'), findsOneWidget);
      expect(find.text('Previsão, não despesa realizada'), findsOneWidget);
      expect(
        (await database.select(database.transactions).get()).length,
        countBefore,
      );
      expect(tester.takeException(), isNull);
    });
  }
}

Future<AppDatabase> _database() async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  await database.saveInitialSetup(
    const SetupInput(
      personName: 'Responsável de nome longo Marco 4',
      accountName: 'Conta principal de valor alto Marco 4',
      accountProvider: 'manual',
      createStarterCategories: false,
    ),
  );
  final startup = await database.getStartupState();
  await database.upsertCategory(
    id: 'expense-marco-4',
    name: 'Categoria longa Marco 4',
    kind: 'expense',
    iconKey: 'cart',
    colorKey: 'amber',
    sortOrder: 1,
  );
  await database.upsertCategory(
    id: 'income-marco-4',
    name: 'Receita Marco 4',
    kind: 'income',
    iconKey: 'income',
    colorKey: 'green',
    sortOrder: 1,
  );
  await database.upsertCostCenter(
    id: 'center-marco-4',
    name: 'Contexto familiar longo Marco 4',
    iconKey: 'home',
    colorKey: 'blue',
  );
  final income = await database.createManualTransaction(
    NewTransactionInput(
      kind: 'income',
      amountCents: 999999999,
      description: 'Receita grande Marco 4',
      accountId: startup.primaryAccountId!,
      payerPersonId: startup.primaryPersonId,
      categoryId: 'income-marco-4',
      beneficiaryIds: [startup.primaryPersonId!],
      occurredAt: DateTime(2026, 8, 10),
    ),
  );
  final expense = await database.createManualTransaction(
    NewTransactionInput(
      kind: 'expense',
      amountCents: 444444444,
      description: 'Despesa grande Marco 4',
      accountId: startup.primaryAccountId!,
      payerPersonId: startup.primaryPersonId,
      categoryId: 'expense-marco-4',
      costCenterId: 'center-marco-4',
      beneficiaryIds: [startup.primaryPersonId!],
      occurredAt: DateTime(2026, 8, 11),
    ),
  );
  await database.createManualTransaction(
    NewTransactionInput(
      kind: 'transfer',
      amountCents: 333333333,
      description: 'Transferência neutra Marco 4',
      accountId: startup.primaryAccountId!,
      payerPersonId: startup.primaryPersonId,
      beneficiaryIds: [startup.primaryPersonId!],
      occurredAt: DateTime(2026, 8, 12),
    ),
  );
  final pending = await database.createManualTransaction(
    NewTransactionInput(
      kind: 'expense',
      amountCents: 22222,
      description: 'Pendente fora do total Marco 4',
      accountId: startup.primaryAccountId!,
      payerPersonId: startup.primaryPersonId,
      categoryId: 'expense-marco-4',
      beneficiaryIds: [startup.primaryPersonId!],
      occurredAt: DateTime(2026, 8, 13),
    ),
  );
  await database.confirmTransaction(income);
  await database.confirmTransaction(expense);
  await database.confirmTransaction(pending);
  await (database.update(database.transactions)
        ..where((row) => row.id.equals(pending)))
      .write(const TransactionsCompanion(reviewStatus: Value('pending')));
  await database.upsertInstallmentPlan(
    id: 'plan-marco-4',
    label: 'Plano longo de parcela Marco 4',
    planKind: 'credit_card_purchase',
    installmentAmountCents: 123456789,
    currentInstallment: 1,
    totalInstallments: 3,
    startMonth: '2026-08',
    endMonth: '2026-10',
  );
  await database.upsertRecurringSchedule(
    id: 'recurring-marco-4',
    label: 'Recorrência contínua Marco 4',
    kind: 'expense',
    amountCents: -98765432,
    dayOfMonth: 15,
    startMonth: '2026-08',
  );
  return database;
}

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
