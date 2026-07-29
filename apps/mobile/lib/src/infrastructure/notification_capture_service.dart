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
}

class NotificationCaptureStatus {
  const NotificationCaptureStatus({
    required this.available,
    required this.permissionGranted,
    required this.allowedPackages,
    required this.recentEvents,
  });

  final bool available;
  final bool permissionGranted;
  final List<String> allowedPackages;
  final List<CapturedNotificationEvent> recentEvents;

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
