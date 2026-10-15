import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/presentation/design/zimba_theme.dart';
import 'package:zimba_control/src/presentation/design/zimba_ui.dart';

void main() {
  for (final size in const [Size(360, 800), Size(390, 844)]) {
    testWidgets(
      'Marco 1 foundation fits ${size.width.toInt()}x${size.height.toInt()} at 1.3',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.platformDispatcher.clearTextScaleFactorTestValue();
        });

        var selectedTab = 0;
        Set<String> selectedSegment = {'month'};
        await tester.pumpWidget(
          MaterialApp(
            theme: ZimbaTheme.light,
            home: StatefulBuilder(
              builder: (context, setState) => ZimbaHomeScaffold(
                selectedIndex: selectedTab,
                onSelected: (value) => setState(() => selectedTab = value),
                body: Column(
                  children: [
                    const ZimbaCompactHeader(
                      title: 'Fundação visual com título deliberadamente longo',
                      subtitle: 'Componentes compartilhados',
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ZimbaSegmentedControl<String>(
                            segments: const [
                              ButtonSegment(value: 'month', label: Text('Mês')),
                              ButtonSegment(
                                value: 'category',
                                label: Text('Categoria'),
                              ),
                              ButtonSegment(
                                value: 'person',
                                label: Text('Pessoa'),
                              ),
                            ],
                            selected: selectedSegment,
                            onSelectionChanged: (value) =>
                                setState(() => selectedSegment = value),
                          ),
                          const SizedBox(height: 16),
                          ZimbaRows(
                            children: const [
                              ZimbaRow(
                                title: 'Linha segura para texto ampliado',
                                subtitle:
                                    'O toque e a leitura não dependem da tela.',
                                leading: Icon(Icons.tune_outlined),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => showZimbaSheet<void>(
                              context: context,
                              builder: (_) => const Text('Sheet compartilhada'),
                            ),
                            child: const Text('Abrir sheet'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  ZimbaFeedbackSnackBar(
                                    message: 'Feedback compartilhado',
                                    tone: ZimbaTone.success,
                                  ),
                                ),
                            child: const Text('Mostrar feedback'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Mês'), findsOneWidget);
        expect(find.text('Linha segura para texto ampliado'), findsOneWidget);
        await tester.tap(find.text('Abrir sheet'));
        await tester.pumpAndSettle();
        expect(find.text('Sheet compartilhada'), findsOneWidget);
        await tester.tapAt(const Offset(8, 8));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Mostrar feedback'));
        await tester.pump();
        expect(find.text('Feedback compartilhado'), findsOneWidget);

        await tester.tap(find.text('Ajustes'));
        await tester.pump();
        expect(selectedTab, 4);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
