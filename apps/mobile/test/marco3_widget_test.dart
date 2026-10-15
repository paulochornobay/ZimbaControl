import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/edit_transaction_page.dart';
import 'package:zimba_control/src/presentation/new_transaction_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Marco 3 cria receita e transferência sem classificação', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final database = await _database();
    addTearDown(database.close);

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
    await _pumpUntilFound(tester, find.text('Despesa'));

    await tester.tap(find.text('Transferência'));
    await tester.pump();
    expect(find.text('Transferência interna'), findsOneWidget);
    await tester.tap(find.text('Receita'));
    await tester.pump();
    await tester.tap(find.text('Renda Marco 3'));
    await tester.enterText(
      find.byKey(const ValueKey('new-transaction-amount')),
      '150,00',
    );
    await tester.enterText(
      find.byKey(const ValueKey('new-transaction-description')),
      'Receita de teste',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    final addTransaction = find.widgetWithText(
      FilledButton,
      'Adicionar lançamento',
    );
    await tester.scrollUntilVisible(
      addTransaction,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(addTransaction);
    await tester.tap(addTransaction);
    await _waitForAsync(tester);

    final income = (await database.select(database.transactions).get()).single;
    expect(income.kind, 'income');
    expect(income.amountCents, 15000);
    expect(income.categoryId, 'income-marco-3');

    await database.createManualTransaction(
      NewTransactionInput(
        kind: 'transfer',
        amountCents: 4000,
        description: 'PIX para conta conjunta',
        accountId: (await database.getStartupState()).primaryAccountId!,
        payerPersonId: (await database.getStartupState()).primaryPersonId,
      ),
    );

    final transactions = await database.select(database.transactions).get();
    final transfer = transactions.firstWhere(
      (item) => item.descriptionRaw == 'PIX para conta conjunta',
    );
    expect(transfer.kind, 'transfer');
    expect(transfer.categoryId, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Marco 3 mantém texto externo, edição explícita e alertas com texto longo',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });
      final database = await _database();
      addTearDown(database.close);
      final startup = await database.getStartupState();
      final id = await database.createManualTransaction(
        NewTransactionInput(
          kind: 'expense',
          amountCents: 4590,
          description:
              'PIX ENVIADO PARA FAMILIAR COM DESCRIÇÃO EXTERNA MUITO LONGA E IMUTÁVEL PARA AUDITORIA',
          accountId: startup.primaryAccountId!,
          payerPersonId: startup.primaryPersonId,
          categoryId: 'expense-marco-3',
          beneficiaryIds: [startup.primaryPersonId!],
        ),
      );
      await (database.update(
        database.transactions,
      )..where((row) => row.id.equals(id))).write(
        const TransactionsCompanion(
          reviewStatus: Value('pending'),
          duplicateStatus: Value('probable'),
          sourceConfidence: Value(.42),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: EditTransactionPage(database: database, transactionId: id),
        ),
      );
      await _pumpUntilFound(tester, find.text('Possível duplicidade'));
      expect(find.textContaining('Baixa confiança'), findsOneWidget);
      expect(find.text('Parece uma transferência interna'), findsOneWidget);
      expect(
        find.text('Texto externo preservado para auditoria.'),
        findsOneWidget,
      );
      expect(find.text('Editar'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.text('Editar'));
      await tester.pump();
      expect(find.byType(TextField), findsNWidgets(2));
      await tester.enterText(
        find.byType(TextField).first,
        'Título amigável ajustado sem alterar o texto externo original',
      );
      await tester.tap(find.text('Salvar alterações'));
      await _pumpUntilFound(tester, find.text('Editar'));

      final saved = await database.getTransaction(id);
      expect(saved?.descriptionRaw, contains('DESCRIÇÃO EXTERNA MUITO LONGA'));
      expect(saved?.displayDescription, contains('Título amigável ajustado'));

      await tester.ensureVisible(find.text('Converter'));
      await tester.pump();
      await tester.tap(find.text('Converter'));
      await tester.pump(const Duration(milliseconds: 400));
      expect((await database.getTransaction(id))?.kind, 'transfer');
      expect(tester.takeException(), isNull);
    },
  );
}

Future<AppDatabase> _database() async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  await database.saveInitialSetup(
    const SetupInput(
      personName: 'Paulo responsável por nomes longos',
      accountName: 'Conta principal de uso diário',
      accountProvider: 'nubank',
      createStarterCategories: false,
    ),
  );
  final startup = await database.getStartupState();
  await database.upsertAccount(
    id: 'ambiguous-nubank-card',
    provider: 'nubank',
    name: 'Conta principal de uso diário',
    type: 'credit_card',
    ownerPersonId: startup.primaryPersonId,
    last4: '4321',
  );
  await database.upsertCategory(
    id: 'expense-marco-3',
    name: 'Despesa Marco 3',
    kind: 'expense',
    iconKey: 'cart',
    colorKey: 'amber',
    sortOrder: 1,
  );
  await database.upsertCategory(
    id: 'income-marco-3',
    name: 'Renda Marco 3',
    kind: 'income',
    iconKey: 'income',
    colorKey: 'green',
    sortOrder: 1,
  );
  return database;
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var index = 0; index < 60; index++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 20));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Widget não encontrado: $finder');
}

Future<void> _waitForAsync(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 120)),
  );
  await tester.pump(const Duration(milliseconds: 120));
}
