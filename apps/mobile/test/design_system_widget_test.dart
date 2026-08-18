import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/design/zimba_ui.dart';
import 'package:zimba_control/src/presentation/feature_availability_page.dart';

void main() {
  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets('design primitives fit ${size.width.toInt()}px', (
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

      await tester.pumpWidget(
        MaterialApp(
          theme: ZimbaTheme.light,
          home: Scaffold(
            body: ListView(
              children: const [
                ZimbaSection(
                  title: 'Componentes',
                  child: ZimbaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lancamento com descricao suficientemente longa'),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            ZimbaBadge(label: 'Notificacao'),
                            ZimbaBadge(label: '94%', tone: ZimbaTone.success),
                            ZimbaBadge(
                              label: 'Baixa confianca',
                              tone: ZimbaTone.warning,
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ZimbaAvatarStack(
                          names: ['Paulo Vitor', 'Maria Clara', 'Sofia'],
                        ),
                        SizedBox(height: 12),
                        ZimbaActionGrid(
                          items: [
                            ZimbaActionItem(
                              label: 'Confirmar',
                              icon: Icons.check,
                              tone: ZimbaTone.success,
                              onPressed: _noop,
                            ),
                            ZimbaActionItem(
                              label: 'Editar',
                              icon: Icons.edit_outlined,
                              onPressed: _noop,
                            ),
                            ZimbaActionItem(
                              label: 'Duplicado',
                              icon: Icons.content_copy_outlined,
                              tone: ZimbaTone.danger,
                              onPressed: _noop,
                            ),
                            ZimbaActionItem(
                              label: 'Ignorar',
                              icon: Icons.visibility_off_outlined,
                              onPressed: _noop,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('COMPONENTES'), findsOneWidget);
      expect(find.text('3 beneficiários'), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets('rules availability fits ${size.width.toInt()}px', (
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

      await tester.pumpWidget(
        MaterialApp(theme: ZimbaTheme.light, home: const RulesPreviewPage()),
      );
      await tester.pump();

      expect(find.text('Regras indisponíveis neste preview'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

void _noop() {}
