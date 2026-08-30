import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:zimba_control/src/presentation/brand_identity_page.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';

void main() {
  const sizes = [Size(360, 800), Size(390, 844), Size(440, 900)];

  setUpAll(() async {
    final inter = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'));
    final lucide = FontLoader('packages/lucide_icons_flutter/Lucide')
      ..addFont(
        rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
      );
    final lucide300 = FontLoader('packages/lucide_icons_flutter/Lucide300')
      ..addFont(
        rootBundle.load(
          'packages/lucide_icons_flutter/assets/build_font/LucideVariable-w300.ttf',
        ),
      );
    await Future.wait([inter.load(), lucide.load(), lucide300.load()]);
  });

  for (final size in sizes) {
    testWidgets('Identidade cabe em ${size.width.toInt()}px com texto 1.3', (
      tester,
    ) async {
      _configureView(tester, size, textScale: 1.3);
      addTearDown(() => _resetView(tester));

      await _pump(tester);

      expect(find.text('Identidade Visual'), findsOneWidget);
      expect(find.text('Variações da marca'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Escuro'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.scrollUntilVisible(
        find.text('Paleta de cores'),
        240,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Paleta de cores'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Identidade golden ${size.width.toInt()}px', (tester) async {
      _configureView(tester, size);
      addTearDown(() => _resetView(tester));

      await _pump(tester);
      final suffix = '${size.width.toInt()}x${size.height.toInt()}';
      await expectLater(
        find.byType(BrandIdentityPage),
        matchesGoldenFile('goldens/identity/identity_$suffix.png'),
      );
    });
  }

  testWidgets('Identidade alterna a prévia e copia um token', (tester) async {
    _configureView(tester, const Size(390, 844));
    addTearDown(() => _resetView(tester));
    final copiedValues = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            copiedValues.add(
              (call.arguments as Map<Object?, Object?>)['text']! as String,
            );
          }
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );
    await _pump(tester);

    await tester.tap(find.text('Escuro'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Background'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Background'));
    await tester.pump();
    expect(copiedValues, ['#F7F8FA']);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(milliseconds: 1201));
  });

  testWidgets('Identidade retorna para Ajustes pelo cabeçalho', (tester) async {
    _configureView(tester, const Size(390, 844));
    addTearDown(() => _resetView(tester));

    await tester.pumpWidget(
      MaterialApp(
        theme: ZimbaTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(builder: (_) => const BrandIdentityPage()),
                ),
                child: const Text('Abrir Identidade'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir Identidade'));
    await tester.pumpAndSettle();
    expect(find.byType(BrandIdentityPage), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();
    expect(find.text('Abrir Identidade'), findsOneWidget);
  });
}

Future<void> _pump(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(theme: ZimbaTheme.light, home: const BrandIdentityPage()),
  );
  await tester.pumpAndSettle();
}

void _configureView(WidgetTester tester, Size size, {double textScale = 1}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
}

void _resetView(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
  tester.platformDispatcher.clearTextScaleFactorTestValue();
}
