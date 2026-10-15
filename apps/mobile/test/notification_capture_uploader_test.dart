import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:zimba_control/src/infrastructure/notification_capture_service.dart';
import 'package:zimba_control/src/infrastructure/notification_capture_uploader.dart';

void main() {
  final event = CapturedNotificationEvent(
    id: 'notification-1',
    packageName: 'com.bank.app',
    postedAt: DateTime.utc(2026, 9, 15),
    capturedAt: DateTime.utc(2026, 9, 15),
    text: 'Compra de teste',
  );

  test('remove somente eventos confirmados duravelmente pela API', () async {
    final capture = _Capture(events: [event]);
    final uploader = NotificationCaptureUploader(
      baseUrl: 'https://api.example.test',
      token: 'session-token',
      client: MockClient((request) async {
        expect(request.headers['authorization'], 'Bearer session-token');
        expect(request.url.path, '/notification-events/batch');
        return http.Response(
          jsonEncode({
            'accepted': ['notification-1'],
          }),
          200,
        );
      }),
    );

    await uploader.drain(capture);

    expect(capture.acknowledged, ['notification-1']);
    expect(capture.released, isEmpty);
  });

  test(
    'mantem para retry qualquer evento nao confirmado na resposta',
    () async {
      final second = CapturedNotificationEvent(
        id: 'notification-2',
        packageName: 'com.bank.app',
        postedAt: DateTime.utc(2026, 9, 15),
        capturedAt: DateTime.utc(2026, 9, 15),
      );
      final capture = _Capture(events: [event, second]);
      final uploader = NotificationCaptureUploader(
        baseUrl: 'https://api.example.test',
        token: 'session-token',
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'accepted': ['notification-1'],
            }),
            200,
          ),
        ),
      );

      await uploader.drain(capture);

      expect(capture.acknowledged, ['notification-1']);
      expect(capture.released, ['notification-2']);
    },
  );
}

class _Capture extends NotificationCaptureService {
  _Capture({required this.events});

  final List<CapturedNotificationEvent> events;
  final List<String> acknowledged = [];
  final List<String> released = [];
  var drained = false;

  @override
  Future<NotificationCaptureDrain> drainPendingEvents({int limit = 50}) async {
    if (drained) return const NotificationCaptureDrain.unavailable();
    drained = true;
    return NotificationCaptureDrain(
      available: true,
      events: events,
      pendingCount: events.length,
      hasMore: false,
    );
  }

  @override
  Future<void> acknowledgeDeliveredEvents(List<String> eventIds) async {
    acknowledged.addAll(eventIds);
  }

  @override
  Future<void> releaseEventsForRetry(
    List<String> eventIds, {
    String? error,
  }) async {
    released.addAll(eventIds);
  }
}
