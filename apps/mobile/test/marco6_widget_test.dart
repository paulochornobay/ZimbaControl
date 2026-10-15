import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/infrastructure/notification_capture_service.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/duplicates_page.dart';
import 'package:zimba_control/src/presentation/family_structure_page.dart';
import 'package:zimba_control/src/presentation/feature_availability_page.dart';
import 'package:zimba_control/src/presentation/import_page.dart';

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
              'available': false,
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

  test('captura indisponível mantém o estado Android honesto', () async {
    final status = await const NotificationCaptureService().loadStatus();
    expect(status.available, isFalse);
    expect(status.permissionGranted, isFalse);
    expect(status.allowedPackages, isEmpty);
  });

  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets('Marco 6 exibe estados honestos em ${size.width.toInt()}px', (
      tester,
    ) async {
      _configureView(tester, size);
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      await database.loadDemoData();
      addTearDown(() async {
        await database.close();
        _resetView(tester);
      });

      final pages = <Widget>[
        ImportPage(database: database),
        DuplicatesPage(database: database),
        RulesPreviewPage(database: database),
        BackupSettingsPage(database: database),
        SyncPrivacyPreviewPage(database: database),
        NotificationSettingsPage(database: database),
        DataEnvironmentPage(database: database, onChanged: () {}),
      ];

      for (final page in pages) {
        await _pumpPage(tester, page);
        expect(
          tester.takeException(),
          isNull,
          reason: '${page.runtimeType} causou erro em ${size.width}px',
        );
      }

      await _pumpPage(tester, SyncPrivacyPreviewPage(database: database));
      await tester.scrollUntilVisible(
        find.text('Sync não configurado'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Sync não configurado'), findsOneWidget);
      expect(
        find.textContaining('Nenhuma informação será enviada'),
        findsOneWidget,
      );

      await _pumpPage(tester, NotificationSettingsPage(database: database));
      expect(find.text('Captura Android'), findsOneWidget);
      expect(find.text('Permissão, apps e privacidade'), findsOneWidget);

      await _pumpPage(
        tester,
        DataEnvironmentPage(database: database, onChanged: () {}),
      );
      await tester.tap(find.text('Zerar aplicativo'));
      await tester.pumpAndSettle();
      final confirm = find.widgetWithText(
        FilledButton,
        'Apagar tudo e voltar ao início',
      );
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
      await tester.enterText(find.byType(TextField).last, 'ZERAR');
      await tester.pump();
      expect(tester.widget<FilledButton>(confirm).onPressed, isNotNull);
      expect(tester.takeException(), isNull);
    });
  }
}

Future<void> _pumpPage(WidgetTester tester, Widget page) async {
  await tester.pumpWidget(MaterialApp(theme: ZimbaTheme.light, home: page));
  for (var attempt = 0; attempt < 10; attempt += 1) {
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
