import 'dart:convert';

import 'package:http/http.dart' as http;

/// Direct online gateway for financial data. It intentionally has no disk
/// cache, outbox or fallback: financial operations require an active API.
class OnlineFinanceClient {
  OnlineFinanceClient({
    required this.baseUrl,
    required this.sessionToken,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final String sessionToken;
  final http.Client _httpClient;

  Future<OnlineBootstrap> bootstrap() async {
    final response = await _get('/v1/bootstrap');
    final body = _jsonObject(response);
    final entities = body['entities'];
    return OnlineBootstrap(
      email: ((body['user'] as Map<Object?, Object?>?)?['email'] as String?) ?? '',
      entities: entities is Map<Object?, Object?>
          ? Map<String, Object?>.from(entities)
          : const {},
    );
  }

  Future<List<OnlineEntitySnapshot>> listEntities(String entityType) async {
    final response = await _get('/v1/entities/${Uri.encodeComponent(entityType)}');
    final body = _jsonObject(response);
    final rows = body['data'];
    if (rows is! List<Object?>) throw const OnlineFinanceException('invalid_api_response');
    return rows
        .whereType<Map<Object?, Object?>>()
        .map((row) => OnlineEntitySnapshot.fromJson(Map<String, Object?>.from(row)))
        .toList(growable: false);
  }

  Future<List<OnlineEntitySnapshot>> listTransactions() => listEntities('transaction');

  Future<OnlineWriteResult> putEntity({
    required String entityType,
    required String entityId,
    required int baseVersion,
    required Map<String, Object?> payload,
  }) async {
    final response = await _request(
      'PUT',
      '/v1/entities/${Uri.encodeComponent(entityType)}/${Uri.encodeComponent(entityId)}',
      body: {'baseVersion': baseVersion, 'payload': payload},
    );
    return _writeResult(response);
  }

  Future<OnlineWriteResult> deleteEntity({
    required String entityType,
    required String entityId,
    required int baseVersion,
  }) async {
    final response = await _request(
      'DELETE',
      '/v1/entities/${Uri.encodeComponent(entityType)}/${Uri.encodeComponent(entityId)}?baseVersion=$baseVersion',
    );
    return _writeResult(response);
  }

  Future<OnlineWriteResult> createTransaction({
    required String entityId,
    required Map<String, Object?> payload,
  }) async {
    final response = await _request(
      'POST',
      '/v1/transactions',
      body: {'id': entityId, 'payload': payload},
    );
    return _writeResult(response);
  }

  Future<http.Response> _get(String path) => _request('GET', path);

  Future<http.Response> _request(
    String method,
    String path, {
    Map<String, Object?>? body,
  }) async {
    if (baseUrl.isEmpty || sessionToken.isEmpty) {
      throw const OnlineFinanceException('missing_online_session');
    }
    try {
      final request = http.Request(method, Uri.parse('${baseUrl.replaceFirst(RegExp(r'/+$'), '')}$path'))
        ..headers.addAll({
          'authorization': 'Bearer $sessionToken',
          'accept': 'application/json',
          if (body != null) 'content-type': 'application/json',
        });
      if (body != null) request.body = jsonEncode(body);
      final streamed = await _httpClient.send(request);
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw OnlineFinanceException('session_rejected_${response.statusCode}');
      }
      if (response.statusCode == 409) {
        throw const OnlineFinanceException('version_conflict');
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw OnlineFinanceException('request_failed_${response.statusCode}');
      }
      return response;
    } on OnlineFinanceException {
      rethrow;
    } catch (_) {
      throw const OnlineFinanceException('network_unavailable');
    }
  }

  Map<String, Object?> _jsonObject(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<Object?, Object?>) return Map<String, Object?>.from(decoded);
    } catch (_) {
      // Normalized below so the UI can show a recoverable API state.
    }
    throw const OnlineFinanceException('invalid_api_response');
  }

  OnlineWriteResult _writeResult(http.Response response) {
    final body = _jsonObject(response);
    final result = body['result'];
    final entityId = body['entityId'];
    if (result is! String || entityId is! String) {
      throw const OnlineFinanceException('invalid_api_response');
    }
    return OnlineWriteResult(entityId: entityId, result: result, seq: body['seq'] as int? ?? 0);
  }
}

class OnlineBootstrap {
  const OnlineBootstrap({required this.email, required this.entities});

  final String email;
  final Map<String, Object?> entities;
}

class OnlineEntitySnapshot {
  const OnlineEntitySnapshot({
    required this.entityId,
    required this.entityType,
    required this.baseVersion,
    required this.payload,
    this.updatedAt,
  });

  final String entityId;
  final String entityType;
  final int baseVersion;
  final Map<String, Object?> payload;
  final String? updatedAt;

  factory OnlineEntitySnapshot.fromJson(Map<String, Object?> json) {
    final payload = json['payload'];
    if (json['entityId'] is! String || json['entityType'] is! String || payload is! Map<Object?, Object?>) {
      throw const OnlineFinanceException('invalid_api_response');
    }
    return OnlineEntitySnapshot(
      entityId: json['entityId']! as String,
      entityType: json['entityType']! as String,
      baseVersion: json['baseVersion'] as int? ?? 0,
      payload: Map<String, Object?>.from(payload),
      updatedAt: json['updatedAt'] as String?,
    );
  }
}

class OnlineWriteResult {
  const OnlineWriteResult({required this.entityId, required this.result, required this.seq});

  final String entityId;
  final String result;
  final int seq;
}

class OnlineFinanceException implements Exception {
  const OnlineFinanceException(this.code);

  final String code;

  @override
  String toString() => code;
}
