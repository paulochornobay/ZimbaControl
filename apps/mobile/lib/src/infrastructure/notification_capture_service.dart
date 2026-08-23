import 'package:flutter/services.dart';

class NotificationCaptureService {
  const NotificationCaptureService();

  static const _channel = MethodChannel('br.com.zimbacontrol/notifications');

  Future<NotificationCaptureStatus> loadStatus() async {
    try {
      final raw = await _channel.invokeMapMethod<String, Object?>('getStatus');
      return NotificationCaptureStatus.fromMap(raw ?? const {});
    } on MissingPluginException {
      return const NotificationCaptureStatus(
        available: false,
        permissionGranted: false,
        allowedPackages: [],
        recentEvents: [],
        queue: NotificationCaptureQueueStatus(pending: 0, delivered: 0),
      );
    }
  }

  Future<void> openNotificationSettings() async {
    try {
      await _channel.invokeMethod<void>('openNotificationSettings');
    } on MissingPluginException {
      return;
    }
  }

  Future<List<String>> setAllowedPackages(List<String> packageNames) async {
    try {
      final raw = await _channel.invokeListMethod<Object?>(
        'setAllowedPackages',
        {'packages': packageNames},
      );
      return raw?.whereType<String>().toList(growable: false) ?? const [];
    } on MissingPluginException {
      return const [];
    }
  }

  Future<List<CapturedNotificationEvent>> getRecentEvents({
    int limit = 50,
  }) async {
    try {
      final raw = await _channel.invokeListMethod<Object?>('getRecentEvents', {
        'limit': limit,
      });
      return raw
              ?.whereType<Map<Object?, Object?>>()
              .map(CapturedNotificationEvent.fromPlatformMap)
              .toList(growable: false) ??
          const [];
    } on MissingPluginException {
      return const [];
    }
  }

  Future<NotificationCaptureDrain> drainPendingEvents({int limit = 50}) async {
    try {
      final raw = await _channel.invokeMapMethod<String, Object?>(
        'drainPendingEvents',
        {'limit': limit},
      );
      return NotificationCaptureDrain.fromMap(raw ?? const {});
    } on MissingPluginException {
      return const NotificationCaptureDrain.unavailable();
    }
  }

  Future<void> acknowledgeDeliveredEvents(List<String> eventIds) async {
    if (eventIds.isEmpty) {
      return;
    }
    try {
      await _channel.invokeMethod<void>('acknowledgeDeliveredEvents', {
        'eventIds': eventIds,
      });
    } on MissingPluginException {
      return;
    }
  }

  Future<void> releaseEventsForRetry(
    List<String> eventIds, {
    String? error,
  }) async {
    if (eventIds.isEmpty) {
      return;
    }
    try {
      await _channel.invokeMethod<void>('releaseEventsForRetry', {
        'eventIds': eventIds,
        'error': error,
      });
    } on MissingPluginException {
      return;
    }
  }

  Future<int> pruneRawEvents({required int olderThanDays}) async {
    try {
      final count = await _channel.invokeMethod<int>('pruneRawEvents', {
        'olderThanDays': olderThanDays,
      });
      return count ?? 0;
    } on MissingPluginException {
      return 0;
    }
  }

  Future<void> resetLocalCapture() async {
    try {
      await _channel.invokeMethod<void>('resetLocalCapture');
    } on MissingPluginException {
      return;
    }
  }
}

class NotificationCaptureStatus {
  const NotificationCaptureStatus({
    required this.available,
    required this.permissionGranted,
    required this.allowedPackages,
    required this.recentEvents,
    required this.queue,
  });

  final bool available;
  final bool permissionGranted;
  final List<String> allowedPackages;
  final List<CapturedNotificationEvent> recentEvents;
  final NotificationCaptureQueueStatus queue;

  factory NotificationCaptureStatus.fromMap(Map<String, Object?> map) {
    final events = (map['recentEvents'] as List<Object?>? ?? const [])
        .whereType<Map<Object?, Object?>>()
        .map(CapturedNotificationEvent.fromPlatformMap)
        .toList(growable: false);
    return NotificationCaptureStatus(
      available: map['available'] == true,
      permissionGranted: map['permissionGranted'] == true,
      allowedPackages: (map['allowedPackages'] as List<Object?>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      recentEvents: events,
      queue: NotificationCaptureQueueStatus.fromMap(
        map['queue'] as Map<Object?, Object?>? ?? const {},
      ),
    );
  }
}

class NotificationCaptureQueueStatus {
  const NotificationCaptureQueueStatus({
    required this.pending,
    required this.delivered,
    this.lastDrainStartedAt,
    this.lastDrainCompletedAt,
    this.lastDeliveryRequestAt,
    this.lastDeliveryRequestSource,
  });

  final int pending;
  final int delivered;
  final DateTime? lastDrainStartedAt;
  final DateTime? lastDrainCompletedAt;
  final DateTime? lastDeliveryRequestAt;
  final String? lastDeliveryRequestSource;

  factory NotificationCaptureQueueStatus.fromMap(Map<Object?, Object?> map) {
    return NotificationCaptureQueueStatus(
      pending: map['pending'] as int? ?? 0,
      delivered: map['delivered'] as int? ?? 0,
      lastDrainStartedAt: _nullableMillisToDateTime(map['lastDrainStartedAt']),
      lastDrainCompletedAt: _nullableMillisToDateTime(
        map['lastDrainCompletedAt'],
      ),
      lastDeliveryRequestAt: _nullableMillisToDateTime(
        map['lastDeliveryRequestAt'],
      ),
      lastDeliveryRequestSource: map['lastDeliveryRequestSource'] as String?,
    );
  }
}

class NotificationCaptureDrain {
  const NotificationCaptureDrain({
    required this.available,
    required this.events,
    required this.pendingCount,
    required this.hasMore,
  });

  const NotificationCaptureDrain.unavailable()
    : available = false,
      events = const [],
      pendingCount = 0,
      hasMore = false;

  final bool available;
  final List<CapturedNotificationEvent> events;
  final int pendingCount;
  final bool hasMore;

  factory NotificationCaptureDrain.fromMap(Map<String, Object?> map) {
    return NotificationCaptureDrain(
      available: true,
      events: (map['events'] as List<Object?>? ?? const [])
          .whereType<Map<Object?, Object?>>()
          .map(CapturedNotificationEvent.fromPlatformMap)
          .toList(growable: false),
      pendingCount: map['pendingCount'] as int? ?? 0,
      hasMore: map['hasMore'] == true,
    );
  }
}

class CapturedNotificationEvent {
  const CapturedNotificationEvent({
    required this.id,
    required this.packageName,
    required this.postedAt,
    required this.capturedAt,
    this.appLabel,
    this.title,
    this.text,
    this.bigText,
    this.notificationId,
    this.tag,
    this.rawPayloadJson,
  });

  final String id;
  final String packageName;
  final String? appLabel;
  final String? title;
  final String? text;
  final String? bigText;
  final int? notificationId;
  final String? tag;
  final DateTime postedAt;
  final DateTime capturedAt;
  final String? rawPayloadJson;

  factory CapturedNotificationEvent.fromPlatformMap(Map<Object?, Object?> map) {
    return CapturedNotificationEvent(
      id: (map['id'] as String?) ?? '',
      packageName: (map['packageName'] as String?) ?? 'unknown',
      appLabel: map['appLabel'] as String?,
      title: map['title'] as String?,
      text: map['text'] as String?,
      bigText: map['bigText'] as String?,
      notificationId: map['notificationId'] as int?,
      tag: map['tag'] as String?,
      postedAt: _millisToDateTime(map['postedAt']),
      capturedAt: _millisToDateTime(map['capturedAt']),
      rawPayloadJson: map['rawPayloadJson'] as String?,
    );
  }

  static DateTime _millisToDateTime(Object? value) {
    final millis = value is int ? value : 0;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }
}

DateTime? _nullableMillisToDateTime(Object? value) {
  final millis = value is int ? value : 0;
  return millis > 0 ? DateTime.fromMillisecondsSinceEpoch(millis) : null;
}
