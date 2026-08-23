import 'package:flutter/material.dart';

import 'src/data/local/app_database.dart';
import 'src/presentation/dashboard_page.dart';
import 'src/presentation/design/zimba_theme.dart';
import 'src/presentation/design/zimba_ui.dart';
import 'src/presentation/movements_page.dart';
import 'src/presentation/new_transaction_page.dart';
import 'src/presentation/onboarding_page.dart';
import 'src/presentation/review_page.dart';
import 'src/presentation/settings_home_page.dart';

void main() {
  runApp(const ZimbaControlApp());
}

class ZimbaControlApp extends StatefulWidget {
  const ZimbaControlApp({super.key, this.database});

  final AppDatabase? database;

  @override
  State<ZimbaControlApp> createState() => _ZimbaControlAppState();
}

class _ZimbaControlAppState extends State<ZimbaControlApp>
    with WidgetsBindingObserver {
  late final AppDatabase database;
  late final bool ownsDatabase;
  late Future<StartupState> startupFuture;
  bool drainingNotificationCapture = false;

  @override
  void initState() {
    super.initState();
    database = widget.database ?? AppDatabase();
    ownsDatabase = widget.database == null;
    startupFuture = database.getStartupState();
    WidgetsBinding.instance.addObserver(this);
    _drainNotificationCaptureWhenReady();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (ownsDatabase) {
      database.close();
    }
    super.dispose();
  }

  void refreshStartup() {
    setState(() {
      startupFuture = database.getStartupState();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _drainNotificationCaptureWhenReady();
    }
  }

  Future<void> _drainNotificationCaptureWhenReady() async {
    if (drainingNotificationCapture) {
      return;
    }
    drainingNotificationCapture = true;
    try {
      final startup = await database.getStartupState();
      if (!startup.needsOnboarding) {
        await database.syncNotificationCaptureEvents();
      }
    } catch (_) {
      // The diagnostics screen keeps the failure recoverable; startup must not
      // be blocked by an Android bridge that is temporarily unavailable.
    } finally {
      drainingNotificationCapture = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZimbaControl',
      debugShowCheckedModeBanner: false,
      theme: ZimbaTheme.light,
      builder: (context, child) =>
          ZimbaViewport(child: child ?? const SizedBox.shrink()),
      home: FutureBuilder<StartupState>(
        future: startupFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _StartupLoading();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return _StartupError(onRetry: refreshStartup);
          }
          if (snapshot.data!.needsOnboarding) {
            return OnboardingPage(
              database: database,
              onCompleted: refreshStartup,
            );
          }
          return ZimbaHomeShell(
            database: database,
            onEnvironmentChanged: refreshStartup,
          );
        },
      ),
    );
  }
}

class ZimbaHomeShell extends StatefulWidget {
  const ZimbaHomeShell({
    required this.database,
    required this.onEnvironmentChanged,
    super.key,
  });

  final AppDatabase database;
  final VoidCallback onEnvironmentChanged;

  @override
  State<ZimbaHomeShell> createState() => _ZimbaHomeShellState();
}

class _ZimbaHomeShellState extends State<ZimbaHomeShell> {
  var selectedIndex = 0;

  void select(int index) {
    ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(database: widget.database),
      ReviewPage(database: widget.database, onNavigate: select),
      NewTransactionPage(
        database: widget.database,
        onSaved: () => select(3),
        onOpenSettings: () => select(4),
      ),
      MovementsPage(database: widget.database),
      SettingsHomePage(
        database: widget.database,
        onEnvironmentChanged: widget.onEnvironmentChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(),
        child: ZimbaBottomNavigation(
          selectedIndex: selectedIndex,
          onSelected: select,
        ),
      ),
    );
  }
}

class _StartupLoading extends StatelessWidget {
  const _StartupLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
    );
  }
}

class _StartupError extends StatelessWidget {
  const _StartupError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 44),
              const SizedBox(height: 14),
              Text(
                'Não foi possível abrir seus dados',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tente novamente. Nenhuma informação foi alterada.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
