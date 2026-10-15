import 'dart:convert';

import 'package:http/http.dart' as http;

import 'notification_capture_service.dart';

/// Sends only the temporary Android queue to MongoDB. Financial records are
/// never created or retained on the device by this class.
class NotificationCaptureUploader {
  NotificationCaptureUploader({
    required this.baseUrl,
    required this.token,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final String token;
  final http.Client _client;

  Future<void> drain(NotificationCaptureService capture) async {
    while (true) {
      final pending = await capture.drainPendingEvents();
      if (pending.events.isEmpty) return;
      try {
        final response = await _client.post(
          Uri.parse('$baseUrl/notification-events/batch'),
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'events': pending.events.map(_eventJson).toList(growable: false),
          }),
        );
        if (response.statusCode != 200) {
          await capture.releaseEventsForRetry(
            pending.events.map((event) => event.id).toList(growable: false),
            error: 'upload_${response.statusCode}',
          );
          return;
        }
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final accepted = (body['accepted'] as List<Object?>? ?? const [])
            .whereType<String>()
            .toSet();
        final eventIds = pending.events
            .map((event) => event.id)
            .toList(growable: false);
        await capture.acknowledgeDeliveredEvents(
          eventIds.where(accepted.contains).toList(growable: false),
        );
        final notAccepted = eventIds
            .where((id) => !accepted.contains(id))
            .toList(growable: false);
        if (notAccepted.isNotEmpty) {
          await capture.releaseEventsForRetry(
            notAccepted,
            error: 'upload_not_acknowledged',
          );
          return;
        }
      } catch (_) {
        await capture.releaseEventsForRetry(
          pending.events.map((event) => event.id).toList(growable: false),
          error: 'network_unavailable',
        );
        return;
      }
      if (!pending.hasMore) return;
    }
  }

  Map<String, Object?> _eventJson(CapturedNotificationEvent event) => {
    'id': event.id,
    'packageName': event.packageName,
    'appLabel': event.appLabel,
    'title': event.title,
    'text': event.text,
    'bigText': event.bigText,
    'notificationId': event.notificationId,
    'tag': event.tag,
    'postedAt': event.postedAt.millisecondsSinceEpoch,
    'capturedAt': event.capturedAt.millisecondsSinceEpoch,
  };
}
