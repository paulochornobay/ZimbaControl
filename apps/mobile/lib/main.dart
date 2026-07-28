import 'package:flutter/material.dart';

import 'src/data/local/app_database.dart';
import 'src/presentation/dashboard_page.dart';
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
            const PlaceholderPage(title: 'Filtros'),
            const PlaceholderPage(title: 'Ajustes'),
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
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.inbox_outlined),
              label: 'Revisao',
            ),
            NavigationDestination(
              icon: Icon(Icons.tune_outlined),
              label: 'Filtros',
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
