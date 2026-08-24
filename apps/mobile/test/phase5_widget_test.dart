import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/commitments_page.dart';
import 'package:zimba_control/src/presentation/dashboard_page.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/duplicates_page.dart';
import 'package:zimba_control/src/presentation/family_structure_page.dart';
import 'package:zimba_control/src/presentation/feature_availability_page.dart';
import 'package:zimba_control/src/presentation/import_page.dart';
import 'package:zimba_control/src/presentation/new_transaction_page.dart';
import 'package:zimba_control/src/presentation/onboarding_page.dart';
import 'package:zimba_control/src/presentation/registries_page.dart';
import 'package:zimba_control/src/presentation/settings_home_page.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  const notificationChannel = MethodChannel(
    'br.com.zimbacontrol/notifications',
  );

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

  for (final size in [const Size(360, 800), const Size(390, 844)]) {
    testWidgets(
      'Fase 5 valida jornadas em ${size.width.toInt()}px com texto 1.3',
      (tester) async {
        _configureView(tester, size);
        final database = await _demoDatabase();
        addTearDown(() async {
          await database.close();
          _resetView(tester);
        });

        final pages = <Widget>[
          DashboardPage(
            database: database,
            referenceDate: DateTime(2026, 8, 15),
          ),
          SettingsHomePage(database: database, onEnvironmentChanged: () {}),
          FamilyStructurePage(database: database),
          BackupSettingsPage(database: database),
          RulesPreviewPage(database: database),
          SyncPrivacyPreviewPage(database: database),
          DuplicatesPage(database: database),
          RegistriesPage(database: database),
          CommitmentsPage(database: database),
          NotificationSettingsPage(database: database),
          ImportPage(database: database),
          NewTransactionPage(
            database: database,
            onSaved: () {},
            onOpenSettings: () {},
          ),
          OnboardingPage(database: database, onCompleted: () {}),
        ];

        for (final page in pages) {
          await _pumpPage(tester, page);
          expect(
            tester.takeException(),
            isNull,
            reason: '${page.runtimeType} causou erro em ${size.width}px',
          );
        }
      },
    );

    testWidgets('Fase 5 goldens principais em ${size.width.toInt()}px', (
      tester,
    ) async {
      _configureView(tester, size);
      final database = await _demoDatabase();
      addTearDown(() async {
        await database.close();
        _resetView(tester);
      });
      final suffix = '${size.width.toInt()}x${size.height.toInt()}';

      await _pumpPage(
        tester,
        DashboardPage(database: database, referenceDate: DateTime(2026, 8, 15)),
      );
      await expectLater(
        find.byType(DashboardPage),
        matchesGoldenFile('goldens/phase5/dashboard_$suffix.png'),
      );

      await _pumpPage(
        tester,
        SettingsHomePage(database: database, onEnvironmentChanged: () {}),
      );
      await expectLater(
        find.byType(SettingsHomePage),
        matchesGoldenFile('goldens/phase5/settings_$suffix.png'),
      );

      await _pumpPage(tester, FamilyStructurePage(database: database));
      await expectLater(
        find.byType(FamilyStructurePage),
        matchesGoldenFile('goldens/phase5/family_$suffix.png'),
      );
    });
  }
}

Future<AppDatabase> _demoDatabase() async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  await database.loadDemoData();
  return database;
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
  tester.platformDispatcher.textScaleFactorTestValue = 1.3;
}

void _resetView(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
  tester.platformDispatcher.clearTextScaleFactorTestValue();
}
