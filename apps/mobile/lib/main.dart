import 'package:flutter/material.dart';

import 'src/data/local/app_database.dart';
import 'src/presentation/dashboard_page.dart';

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
      home: DashboardPage(database: database),
    );
  }
}
