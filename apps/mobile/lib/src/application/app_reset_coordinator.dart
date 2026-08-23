import '../data/local/app_database.dart';
import '../infrastructure/google_session_client.dart';
import '../infrastructure/notification_capture_service.dart';

class AppResetCoordinator {
  AppResetCoordinator({
    required this.database,
    this.notificationCapture = const NotificationCaptureService(),
    Future<void> Function()? clearSession,
  }) : clearSession =
           clearSession ?? (() => GoogleSessionClient.clearStoredSession());

  final AppDatabase database;
  final NotificationCaptureService notificationCapture;
  final Future<void> Function() clearSession;

  Future<void> resetEverything() async {
    // External stores are cleared first. If either one fails, the financial
    // database remains intact and the user can retry without a partial reset.
    await notificationCapture.resetLocalCapture();
    await clearSession();
    await database.clearLocalData();
  }
}
