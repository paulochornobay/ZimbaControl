import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/main.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/brand_identity_page.dart';
import 'package:zimba_control/src/presentation/commitments_page.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/design/zimba_ui.dart';
import 'package:zimba_control/src/presentation/duplicates_page.dart';
import 'package:zimba_control/src/presentation/edit_transaction_page.dart';
import 'package:zimba_control/src/presentation/family_structure_page.dart';
import 'package:zimba_control/src/presentation/feature_availability_page.dart';
import 'package:zimba_control/src/presentation/import_page.dart';
import 'package:zimba_control/src/presentation/invoices_page.dart';
import 'package:zimba_control/src/presentation/onboarding_page.dart';
import 'package:zimba_control/src/presentation/registries_page.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  const notificationChannel = MethodChannel(
    'br.com.zimbacontrol/notifications',
  );
  const sizes = [Size(360, 800), Size(390, 844), Size(440, 900)];

  final defaultComparator = goldenFileComparator;
  if (defaultComparator is LocalFileComparator) {
    goldenFileComparator = _ParityGoldenComparator(
      defaultComparator.basedir.resolve('visual_parity_baseline_test.dart'),
    );
  }

  setUpAll(_loadGoldenFonts);

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(notificationChannel, (call) async {
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

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(notificationChannel, null);
  });

  for (final size in sizes) {
    testWidgets(
      'baseline visual das rotas em ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        _configureView(tester, size);
        final database = AppDatabase.forTesting(NativeDatabase.memory());
        await database.loadDemoData();
        final transaction =
            (await database.select(database.transactions).get()).first;
        addTearDown(() async {
          await database.close();
          _resetView(tester);
        });

        final suffix = '${size.width.toInt()}x${size.height.toInt()}';
        await _pumpPage(
          tester,
          ZimbaHomeShell(database: database, onEnvironmentChanged: () {}),
        );
        await _captureShell(tester, suffix, 'summary');
        for (final (label, slug) in const [
          ('Revisão', 'review'),
          ('Novo', 'transaction-new'),
          ('Movim.', 'movimentacoes'),
          ('Ajustes', 'settings'),
        ]) {
          final navigation = find.descendant(
            of: find.byType(ZimbaBottomNavigation),
            matching: find.text(label),
          );
          await tester.tap(navigation);
          await tester.pump(const Duration(milliseconds: 300));
          await _captureShell(tester, suffix, slug);
        }

        final pages = <String, Widget>{
          'transaction-detail': EditTransactionPage(
            database: database,
            transactionId: transaction.id,
          ),
          'onboarding': OnboardingPage(database: database, onCompleted: () {}),
          'import': ImportPage(database: database),
          'duplicates': DuplicatesPage(database: database),
          'family': FamilyStructurePage(database: database),
          'rules': RulesPreviewPage(database: database),
          'backup': BackupSettingsPage(database: database),
          'sync-privacy': SyncPrivacyPreviewPage(database: database),
          'identidade': const BrandIdentityPage(),
          'registries': RegistriesPage(database: database),
          'invoices': InvoicesPage(
            database: database,
            referenceDate: DateTime(2026, 8, 15),
          ),
          'commitments': CommitmentsPage(database: database),
          'capture': NotificationSettingsPage(database: database),
          'local-data': DataEnvironmentPage(
            database: database,
            onChanged: () {},
          ),
        };

        for (final MapEntry(key: slug, value: page) in pages.entries) {
          await _pumpPage(tester, page);
          expect(
            tester.takeException(),
            isNull,
            reason: '$slug causou erro no viewport $suffix',
          );
          await expectLater(
            find.byWidget(page),
            matchesGoldenFile('goldens/parity/$suffix/$slug.png'),
          );
        }
      },
    );
  }
}

class _ParityGoldenComparator extends LocalFileComparator {
  _ParityGoldenComparator(super.testFile);

  static const rasterizationTolerance = 0.0002;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= rasterizationTolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

Future<void> _captureShell(
  WidgetTester tester,
  String suffix,
  String slug,
) async {
  expect(
    tester.takeException(),
    isNull,
    reason: '$slug causou erro no viewport $suffix',
  );
  await expectLater(
    find.byType(ZimbaHomeShell),
    matchesGoldenFile('goldens/parity/$suffix/$slug.png'),
  );
}

Future<void> _loadGoldenFonts() async {
  final inter = FontLoader('Inter')
    ..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'));
  final materialIcons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
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
  await Future.wait([
    inter.load(),
    materialIcons.load(),
    lucide.load(),
    lucide300.load(),
  ]);
}

Future<void> _pumpPage(WidgetTester tester, Widget page) async {
  await tester.pumpWidget(MaterialApp(theme: ZimbaTheme.light, home: page));
  for (var attempt = 0; attempt < 12; attempt += 1) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void _configureView(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 1;
}

void _resetView(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
  tester.platformDispatcher.clearTextScaleFactorTestValue();
}
