import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/main.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/edit_transaction_page.dart';
import 'package:zimba_control/src/presentation/movements_page.dart';
import 'package:zimba_control/src/presentation/review_page.dart';

void main() {
  setUpAll(() async {
    final inter = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'));
    final materialIcons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await Future.wait([inter.load(), materialIcons.load()]);
  });

  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets('Fase 1 mantém Movimentações compacta em ${size.width}px', (
      tester,
    ) async {
      await _configureView(tester, size);
      final database = await _databaseWithTransaction(
        description: 'Padaria original importada',
      );
      addTearDown(database.close);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: MovementsPage(
            database: database,
            referenceDate: DateTime(2026, 8, 23),
          ),
        ),
      );
      await _pumpUntilFound(tester, find.byType(MovementTransactionRow));

      expect(find.text('Movimentações'), findsOneWidget);
      expect(find.text('Todos'), findsOneWidget);
      expect(find.text('Ajustes'), findsOneWidget);
      expect(find.text('Somente mês atual'), findsNothing);
      expect(find.text('Itens'), findsNothing);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MovementsPage),
        matchesGoldenFile(
          'goldens/phase1/movements_${size.width.toInt()}x${size.height.toInt()}.png',
        ),
      );

      await tester.tap(find.byTooltip('Abrir filtros'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Filtros'), findsOneWidget);
      expect(find.text('PESSOA'), findsOneWidget);
      expect(find.text('CONTA / CARTÃO'), findsOneWidget);
      expect(find.text('CATEGORIA'), findsOneWidget);
      expect(find.text('Aplicar'), findsOneWidget);

      await tester.drag(find.byType(ListView).last, const Offset(0, -500));
      await tester.pump();

      expect(find.text('CENTRO DE CUSTO'), findsOneWidget);
      expect(find.text('ORIGEM'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Aplicar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await _disposeWidget(tester);
    });

    testWidgets('Fase 1 abre detalhe em leitura em ${size.width}px', (
      tester,
    ) async {
      await _configureView(tester, size);
      final database = await _databaseWithTransaction(
        description: 'PADARIA SAO JOAO COMPRA 1234',
        displayDescription: 'Padaria São João',
      );
      addTearDown(database.close);
      final transaction = await database
          .select(database.transactions)
          .getSingle();

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: EditTransactionPage(
            database: database,
            transactionId: transaction.id,
          ),
        ),
      );
      await _pumpUntilFound(tester, find.text('Padaria São João'));

      expect(find.text('Editar'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(find.text('DESCRIÇÃO ORIGINAL'), findsOneWidget);
      expect(find.text('“PADARIA SAO JOAO COMPRA 1234”'), findsOneWidget);
      expect(find.text('Salvar alterações'), findsNothing);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(EditTransactionPage),
        matchesGoldenFile(
          'goldens/phase1/detail_${size.width.toInt()}x${size.height.toInt()}.png',
        ),
      );

      await tester.tap(find.text('Editar'));
      await tester.pump();
      expect(find.byType(TextField), findsNWidgets(2));

      await tester.enterText(find.byType(TextField).first, 'Padaria do bairro');
      await tester.scrollUntilVisible(
        find.text('Salvar alterações'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Salvar alterações'), findsOneWidget);
      await tester.tap(find.text('Salvar alterações'));
      await _pumpUntilFound(tester, find.text('Editar'));

      final updated = await database.getTransaction(transaction.id);
      expect(updated?.displayDescription, 'Padaria do bairro');
      expect(updated?.descriptionRaw, 'PADARIA SAO JOAO COMPRA 1234');
      expect(find.byType(TextField), findsNothing);
      expect(tester.takeException(), isNull);
      await _disposeWidget(tester);
    });

    testWidgets('Fase 1 mantém Revisão compacta em ${size.width}px', (
      tester,
    ) async {
      await _configureView(tester, size);
      final database = await _databaseWithTransaction(
        description: 'Compra no crédito aprovada',
        displayDescription: 'Mercado do bairro',
      );
      addTearDown(database.close);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: ReviewPage(database: database),
        ),
      );
      await _pumpUntilFound(tester, find.text('Confirmar'));

      expect(find.text('Caixa de revisão'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(ReviewPage),
        matchesGoldenFile(
          'goldens/phase1/review_${size.width.toInt()}x${size.height.toInt()}.png',
        ),
      );
      await _disposeWidget(tester);
    });
  }

  testWidgets('confirmação fecha ao trocar de aba e também expira', (
    tester,
  ) async {
    await _configureView(tester, const Size(390, 844), textScale: 1);
    final database = await _databaseWithTransaction(
      description: 'Primeiro lançamento pendente',
    );
    await _createPendingTransaction(
      database,
      description: 'Segundo lançamento pendente',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ZimbaTheme.light,
        home: ZimbaHomeShell(database: database, onEnvironmentChanged: () {}),
      ),
    );
    await tester.tap(find.text('Revisão'));
    await _pumpUntilFound(tester, find.text('Confirmar'));

    await tester.tap(find.text('Confirmar').first);
    await _pumpUntilFound(tester, find.text('Lancamento confirmado'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Lancamento confirmado'), findsOneWidget);

    await tester.tap(find.text('Movim.'));
    await tester.pump();
    expect(find.text('Lancamento confirmado'), findsNothing);

    await tester.tap(find.text('Revisão'));
    await _pumpUntilFound(tester, find.text('Confirmar'));
    await tester.tap(find.text('Confirmar').first);
    await _pumpUntilFound(tester, find.text('Lancamento confirmado'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Lancamento confirmado'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Lancamento confirmado'), findsNothing);
    expect(tester.takeException(), isNull);
    await _disposeWidget(tester);
    await tester.runAsync(database.close);
  });
}

Future<AppDatabase> _databaseWithTransaction({
  required String description,
  String? displayDescription,
}) async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  await database.saveInitialSetup(
    const SetupInput(
      personName: 'Responsável da família',
      accountName: 'Conta principal',
      accountProvider: 'manual',
    ),
  );
  final id = await _createPendingTransaction(
    database,
    description: description,
  );
  if (displayDescription != null) {
    await database.updateTransactionCore(
      id: id,
      displayDescription: displayDescription,
      amountCents: -4590,
      kind: 'expense',
      categoryId: null,
      costCenterId: null,
    );
  }
  return database;
}

Future<String> _createPendingTransaction(
  AppDatabase database, {
  required String description,
}) async {
  final startup = await database.getStartupState();
  return database.createManualTransaction(
    NewTransactionInput(
      kind: 'expense',
      amountCents: 4590,
      description: description,
      accountId: startup.primaryAccountId!,
      payerPersonId: startup.primaryPersonId,
      beneficiaryIds: [startup.primaryPersonId!],
      occurredAt: DateTime(2026, 8, 23, 10, 30),
    ),
  );
}

Future<void> _configureView(
  WidgetTester tester,
  Size size, {
  double textScale = 1.3,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures();
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
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
  fail('Widget não encontrado após aguardar: $finder');
}

Future<void> _disposeWidget(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 20)),
  );
  await tester.pump(const Duration(milliseconds: 20));
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 20)),
  );
  await tester.pump(const Duration(milliseconds: 20));
}
