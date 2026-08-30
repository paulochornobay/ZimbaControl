import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/dashboard_page.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/design/zimba_ui.dart';

import 'support/lovable_fixture.dart';

void main() {
  const sizes = [Size(360, 800), Size(390, 844), Size(440, 900)];
  const channel = MethodChannel('br.com.zimbacontrol/notifications');

  setUpAll(_loadFonts);
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'getStatus') {
            return <String, Object?>{
              'available': true,
              'permissionGranted': false,
              'allowedPackages': const <Object?>[],
              'recentEvents': const <Object?>[],
              'queue': <String, Object?>{'pending': 0, 'delivered': 0},
            };
          }
          return null;
        });
  });
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );

  for (final size in sizes) {
    testWidgets('Resumo Lovable ${size.width.toInt()}x${size.height.toInt()}', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      final database = await openLovableTestDatabase();
      final details = await database.listAllTransactionDetails();
      final structure = await database.getFamilyStructureSnapshot();
      addTearDown(() async {
        await database.close();
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: _SummaryTestShell(
            database: database,
            details: details,
            structure: structure,
          ),
        ),
      );
      await _settleDashboard(tester);
      final suffix = '${size.width.toInt()}x${size.height.toInt()}';
      await expectLater(
        find.byType(_SummaryTestShell),
        matchesGoldenFile('goldens/lovable_summary/summary-pessoa-$suffix.png'),
      );

      await tester.tap(find.text('Categoria').first);
      await tester.pump(const Duration(milliseconds: 200));
      await expectLater(
        find.byType(_SummaryTestShell),
        matchesGoldenFile(
          'goldens/lovable_summary/summary-categoria-$suffix.png',
        ),
      );

      await tester.tap(find.text('Centro').first);
      await tester.pump(const Duration(milliseconds: 200));
      await expectLater(
        find.byType(_SummaryTestShell),
        matchesGoldenFile('goldens/lovable_summary/summary-centro-$suffix.png'),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();
    });
  }

  testWidgets('Resumo tolera fonte 1,3 e dados longos sem overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    final database = await openLovableTestDatabase();
    final details = await database.listAllTransactionDetails();
    final structure = await database.getFamilyStructureSnapshot();
    addTearDown(() async {
      await database.close();
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: ZimbaTheme.light,
        home: _SummaryTestShell(
          database: database,
          details: details,
          structure: structure,
        ),
      ),
    );
    await _settleDashboard(tester);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
  });
}

class _SummaryTestShell extends StatelessWidget {
  const _SummaryTestShell({
    required this.database,
    required this.details,
    required this.structure,
  });

  final AppDatabase database;
  final List<ReviewTransactionDetails> details;
  final FamilyStructureSnapshot structure;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DashboardPage(
      database: database,
      detailsStream: Stream.value(details),
      structureFuture: Future.value(structure),
    ),
    bottomNavigationBar: ZimbaBottomNavigation(
      selectedIndex: 0,
      onSelected: (_) {},
    ),
  );
}

Future<void> _settleDashboard(WidgetTester tester) async {
  for (var attempt = 0; attempt < 20; attempt += 1) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 20));
    if (find.text('SALDO DO MÊS').evaluate().isNotEmpty) return;
  }
  fail('Resumo não carregou a fixture Lovable.');
}

Future<void> _loadFonts() async {
  final inter = FontLoader('Inter')
    ..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'));
  final lucide = FontLoader('packages/lucide_icons_flutter/Lucide')
    ..addFont(
      rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
    );
  await Future.wait([inter.load(), lucide.load()]);
}
