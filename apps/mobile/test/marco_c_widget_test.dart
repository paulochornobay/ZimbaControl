import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/commitments_page.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/settings_home_page.dart';

void main() {
  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets('Marco C hubs fit ${size.width.toInt()}px with long data', (
      tester,
    ) async {
      const notificationChannel = MethodChannel(
        'br.com.zimbacontrol/notifications',
      );
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
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.2;
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(() async {
        await database.close();
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(notificationChannel, null);
      });

      await database.saveInitialSetup(
        const SetupInput(
          personName: 'Responsável com nome familiar deliberadamente longo',
          accountName: 'Conta principal com descrição bastante longa',
          accountProvider: 'nubank',
        ),
      );
      final startup = await database.getStartupState();
      await database.upsertRecurringSchedule(
        label:
            'Escola e atividades extracurriculares da criança com nome longo',
        kind: 'expense',
        amountCents: -123456789,
        dayOfMonth: 28,
        startMonth: '2026-08',
        payerPersonId: startup.primaryPersonId,
        beneficiaryPersonId: startup.primaryPersonId,
        fromAccountId: startup.primaryAccountId,
        toAccountId: null,
        categoryId: null,
        costCenterId: null,
      );
      await database.upsertInstallmentPlan(
        label:
            'Compra parcelada com descrição muito longa para validar leitura',
        planKind: 'credit_card_purchase',
        ownerPersonId: startup.primaryPersonId,
        totalAmountCents: 987654312,
        installmentAmountCents: 123456789,
        currentInstallment: 10,
        totalInstallments: 12,
        dueDay: 31,
        startMonth: '2026-08',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: CommitmentsPage(database: database),
        ),
      );
      await _pumpUntilFound(tester, find.text('PROJECAO MENSAL'));

      expect(find.text('PROJECAO MENSAL'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: CommitmentsPage(
            key: const ValueKey('installments'),
            database: database,
            initialTabIndex: 1,
          ),
        ),
      );
      await _pumpUntilFound(tester, find.text('Parcelas em aberto'));
      expect(find.text('Parcelas em aberto'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: SettingsHomePage(
            database: database,
            onEnvironmentChanged: () {},
          ),
        ),
      );
      await _pumpUntilFound(tester, find.text('Captura Android'));

      expect(find.text('Captura Android'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    });
  }
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 25)),
    );
    await tester.pump();
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Widget não encontrado após aguardar o carregamento: $finder');
}
