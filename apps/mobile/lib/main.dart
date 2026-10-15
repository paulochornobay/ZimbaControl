import 'dart:async';

import 'package:flutter/material.dart';

import 'src/infrastructure/google_session_client.dart';
import 'src/infrastructure/notification_capture_service.dart';
import 'src/infrastructure/notification_capture_uploader.dart';
import 'src/infrastructure/online_finance_client.dart';
import 'src/presentation/auth_page.dart';
import 'src/presentation/design/zimba_theme.dart';
import 'src/presentation/design/zimba_ui.dart';
import 'src/presentation/online_home_page.dart';

void main() => runApp(const ZimbaControlApp());

/// The application has one financial data path: an authenticated online API.
/// It deliberately has no local-database fallback.
class ZimbaControlApp extends StatefulWidget {
  const ZimbaControlApp({super.key, this.sessionClient});

  final GoogleSessionClient? sessionClient;

  @override
  State<ZimbaControlApp> createState() => _ZimbaControlAppState();
}

class _ZimbaControlAppState extends State<ZimbaControlApp>
    with WidgetsBindingObserver {
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );

  late final GoogleSessionClient sessionClient;
  late Future<ApiSession?> sessionFuture;
  ApiSession? activeSession;
  bool drainingNotificationCapture = false;
  final notificationCapture = const NotificationCaptureService();

  bool get isApiConfigured => apiBaseUrl.isNotEmpty;

  @override
  void initState() {
    super.initState();
    sessionClient =
        widget.sessionClient ??
        GoogleSessionClient(
          apiBaseUrl: apiBaseUrl,
          googleWebClientId: googleWebClientId,
        );
    sessionFuture = _loadSession();
    WidgetsBinding.instance.addObserver(this);
    _drainNotificationCaptureWhenReady();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<ApiSession?> _loadSession() async {
    final session = await sessionClient.readStoredSession();
    activeSession = session;
    if (session != null) {
      await notificationCapture.setActiveAccount(session.householdId);
      unawaited(_drainNotificationCaptureWhenReady());
    }
    return session;
  }

  void refreshSession() => setState(() => sessionFuture = _loadSession());

  void _onAuthenticated(ApiSession session) {
    setState(() {
      activeSession = session;
      sessionFuture = Future.value(session);
    });
    unawaited(notificationCapture.setActiveAccount(session.householdId));
    unawaited(_drainNotificationCaptureWhenReady());
  }

  Future<void> _signOut() async {
    await notificationCapture.clearActiveAccount();
    await sessionClient.signOut();
    if (!mounted) return;
    setState(() {
      activeSession = null;
      sessionFuture = Future.value(null);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _drainNotificationCaptureWhenReady();
  }

  Future<void> _drainNotificationCaptureWhenReady() async {
    if (drainingNotificationCapture || activeSession == null || !isApiConfigured) return;
    drainingNotificationCapture = true;
    try {
      final session = activeSession!;
      await NotificationCaptureUploader(
        baseUrl: apiBaseUrl,
        token: session.token,
      ).drain(notificationCapture);
    } catch (_) {
      // The encrypted notification queue retries after a later lifecycle event.
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
      home: FutureBuilder<ApiSession?>(
        future: sessionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _StartupLoading();
          }
          if (snapshot.hasError) return _StartupError(onRetry: refreshSession);
          if (!isApiConfigured) return const _ApiConfigurationRequired();
          final session = snapshot.data;
          if (session == null) {
            return ZimbaAuthPage(
              client: sessionClient,
              isConfigured: true,
              onAuthenticated: _onAuthenticated,
            );
          }
          return OnlineHomePage(
            client: OnlineFinanceClient(
              baseUrl: apiBaseUrl,
              sessionToken: session.token,
            ),
            email: session.email,
            onSignOut: _signOut,
          );
        },
      ),
    );
  }
}

class _StartupLoading extends StatelessWidget {
  const _StartupLoading();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
}

class _StartupError extends StatelessWidget {
  const _StartupError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 44),
                const SizedBox(height: 14),
                Text('Não foi possível abrir sua sessão',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text('Tente novamente. Nenhuma informação financeira é guardada neste aparelho.'),
                const SizedBox(height: 18),
                FilledButton(onPressed: onRetry, child: const Text('Tentar novamente')),
              ],
            ),
          ),
        ),
      );
}

class _ApiConfigurationRequired extends StatelessWidget {
  const _ApiConfigurationRequired();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(28),
            child: Text(
              'A API online precisa ser configurada para usar o ZimbaControl. Dados financeiros não são mantidos localmente.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}
