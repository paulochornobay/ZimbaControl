import 'dart:convert';

import 'package:http/http.dart' as http;

class SyncPushPayload {
  const SyncPushPayload({
    required this.deviceId,
    required this.householdId,
    required this.operations,
  });

  final String deviceId;
  final String householdId;
  final List<Map<String, dynamic>> operations;

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'householdId': householdId,
    'operations': operations,
  };
}

class SyncPushResponse {
  const SyncPushResponse({required this.results, required this.latestSeq});

  final List<SyncOperationAck> results;
  final int latestSeq;

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) {
    return SyncPushResponse(
      latestSeq: json['latestSeq'] as int? ?? 0,
      results: (json['results'] as List<Object?>? ?? const [])
          .whereType<Map<Object?, Object?>>()
          .map(
            (item) =>
                SyncOperationAck.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false),
    );
  }
}

class SyncOperationAck {
  const SyncOperationAck({
    required this.opId,
    required this.result,
    required this.entityId,
    required this.seq,
  });

  final String opId;
  final String result;
  final String entityId;
  final int seq;

  factory SyncOperationAck.fromJson(Map<String, dynamic> json) {
    return SyncOperationAck(
      opId: json['opId'] as String,
      result: json['result'] as String,
      entityId: json['entityId'] as String,
      seq: json['seq'] as int? ?? 0,
    );
  }
}

class SyncPullResponse {
  const SyncPullResponse({required this.events, required this.latestSeq});

  final List<Map<String, dynamic>> events;
  final int latestSeq;

  factory SyncPullResponse.fromJson(Map<String, dynamic> json) {
    return SyncPullResponse(
      latestSeq: json['latestSeq'] as int? ?? 0,
      events: (json['events'] as List<Object?>? ?? const [])
          .whereType<Map<Object?, Object?>>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(growable: false),
    );
  }
}

abstract class SyncApiClient {
  Future<SyncPushResponse> push(SyncPushPayload payload);

  Future<SyncPullResponse> pull({
    required String householdId,
    required int sinceSeq,
  });
}

class HttpSyncApiClient implements SyncApiClient {
  HttpSyncApiClient({
    required this.baseUrl,
    this.sessionToken,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final String? sessionToken;
  final http.Client httpClient;

  @override
  Future<SyncPushResponse> push(SyncPushPayload payload) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/sync/push'),
      headers: _headers(json: true),
      body: jsonEncode(payload.toJson()),
    );
    if (response.statusCode != 200) {
      throw SyncApiException('push_failed_${response.statusCode}');
    }
    return SyncPushResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  @override
  Future<SyncPullResponse> pull({
    required String householdId,
    required int sinceSeq,
  }) async {
    final uri = Uri.parse('$baseUrl/sync/pull').replace(
      queryParameters: {
        'householdId': householdId,
        'sinceSeq': sinceSeq.toString(),
      },
    );
    final response = await httpClient.get(uri, headers: _headers());
    if (response.statusCode != 200) {
      throw SyncApiException('pull_failed_${response.statusCode}');
    }
    return SyncPullResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Map<String, String> _headers({bool json = false}) {
    return {
      if (json) 'content-type': 'application/json',
      if (sessionToken != null && sessionToken!.isNotEmpty)
        'authorization': 'Bearer $sessionToken',
    };
  }
}

class SyncApiException implements Exception {
  const SyncApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
