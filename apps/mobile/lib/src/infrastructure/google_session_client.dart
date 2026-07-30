import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class ApiSession {
  const ApiSession({
    required this.token,
    required this.expiresInSeconds,
    required this.email,
    this.name,
    this.picture,
  });

  final String token;
  final int expiresInSeconds;
  final String email;
  final String? name;
  final String? picture;

  factory ApiSession.fromJson(Map<String, dynamic> json) {
    final user = Map<String, dynamic>.from(json['user'] as Map? ?? const {});
    return ApiSession(
      token: json['token'] as String,
      expiresInSeconds: json['expiresInSeconds'] as int? ?? 0,
      email: user['email'] as String,
      name: user['name'] as String?,
      picture: user['picture'] as String?,
    );
  }
}

class GoogleSessionClient {
  GoogleSessionClient({
    required this.apiBaseUrl,
    required this.googleWebClientId,
    http.Client? httpClient,
    FlutterSecureStorage? storage,
  }) : httpClient = httpClient ?? http.Client(),
       storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'zimbacontrol.sessionToken';
  static const _emailKey = 'zimbacontrol.sessionEmail';
  static bool _initialized = false;

  final String apiBaseUrl;
  final String googleWebClientId;
  final http.Client httpClient;
  final FlutterSecureStorage storage;

  Future<String?> readSessionToken() => storage.read(key: _tokenKey);

  Future<String?> readSessionEmail() => storage.read(key: _emailKey);

  Future<ApiSession> signIn() async {
    await _initializeGoogle();
    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const GoogleSessionException('missing_google_id_token');
    }

    final response = await httpClient.post(
      Uri.parse('$apiBaseUrl/auth/google'),
      headers: const {'content-type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );
    if (response.statusCode != 200) {
      throw GoogleSessionException('auth_failed_${response.statusCode}');
    }

    final session = ApiSession.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    await storage.write(key: _tokenKey, value: session.token);
    await storage.write(key: _emailKey, value: session.email);
    return session;
  }

  Future<void> signOut() async {
    await storage.delete(key: _tokenKey);
    await storage.delete(key: _emailKey);
    await _initializeGoogle();
    await GoogleSignIn.instance.signOut();
  }

  Future<void> _initializeGoogle() async {
    if (_initialized) {
      return;
    }
    await GoogleSignIn.instance.initialize(serverClientId: googleWebClientId);
    _initialized = true;
  }
}

class GoogleSessionException implements Exception {
  const GoogleSessionException(this.message);

  final String message;

  @override
  String toString() => message;
}
