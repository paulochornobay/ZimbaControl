import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/registries_page.dart';

void main() {
  testWidgets('Cadastros apresenta contexto da aba e formulario com CTA fixo', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await database.close();
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await database.saveInitialSetup(
      const SetupInput(
        personName: 'Responsável da família',
        accountName: 'Conta principal',
        accountProvider: 'nubank',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ZimbaTheme.light,
        home: RegistriesPage(database: database),
      ),
    );
    await _pumpUntilFound(
      tester,
      find.text('Pessoas, instrumentos e taxonomia'),
    );

    expect(find.text('Pessoas'), findsAtLeastNWidgets(1));
    expect(find.text('1 cadastro'), findsOneWidget);
    expect(find.text('Nova pessoa'), findsOneWidget);

    await tester.tap(find.text('Nova pessoa'));
    await _pumpUntilFound(tester, find.text('Salvar cadastro'));

    // Section headings are rendered in uppercase by ZimbaSectionTitle.
    expect(find.text('INFORMAÇÕES'), findsOneWidget);
    expect(find.text('Cadastro salvo somente neste aparelho'), findsOneWidget);
    expect(find.text('Salvar cadastro'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 40; attempt += 1) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 20));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Widget nao encontrado: $finder');
}
