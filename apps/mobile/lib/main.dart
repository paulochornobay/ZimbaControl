import 'package:flutter/material.dart';

import 'src/data/local/app_database.dart';
import 'src/presentation/dashboard_page.dart';
import 'src/presentation/family_structure_page.dart';
import 'src/presentation/movements_page.dart';
import 'src/presentation/review_page.dart';

void main() {
  runApp(const ZimbaControlApp());
}

class ZimbaControlApp extends StatefulWidget {
  const ZimbaControlApp({super.key, this.database});

  final AppDatabase? database;

  @override
  State<ZimbaControlApp> createState() => _ZimbaControlAppState();
}

class _ZimbaControlAppState extends State<ZimbaControlApp> {
  late final AppDatabase database;
  late final bool ownsDatabase;
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    database = widget.database ?? AppDatabase();
    ownsDatabase = widget.database == null;
    database.seedIfEmpty();
  }

  @override
  void dispose() {
    if (ownsDatabase) {
      database.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZimbaControl',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0EA5E9),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: [
            DashboardPage(database: database),
            ReviewPage(database: database),
            NewDraftPage(
              onCreate: () async {
                await database.createManualDraft();
                setState(() => selectedIndex = 1);
              },
            ),
            MovementsPage(database: database),
            FamilyStructurePage(database: database),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => setState(() {
            selectedIndex = index;
          }),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Resumo',
            ),
            NavigationDestination(
              icon: Icon(Icons.inbox_outlined),
              label: 'Revisao',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline),
              label: 'Novo',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'Movs.',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: 'Ajustes',
            ),
          ],
        ),
      ),
    );
  }
}

class NewDraftPage extends StatelessWidget {
  const NewDraftPage({required this.onCreate, super.key});

  final Future<void> Function() onCreate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo lancamento')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.note_add_outlined, size: 48),
              const SizedBox(height: 12),
              Text(
                'Criar rascunho local',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Ele entra na caixa de revisao para edicao e confirmacao.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: const Text('Criar rascunho'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('Tela aguardando prototipo refinado no Lovable.'),
      ),
    );
  }
}
