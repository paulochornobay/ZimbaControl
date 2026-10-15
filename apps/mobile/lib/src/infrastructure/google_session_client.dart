import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class ApiSession {
  const ApiSession({
    required this.token,
    required this.expiresInSeconds,
    required this.email,
    required this.accountId,
    required this.householdId,
    this.name,
    this.picture,
  });

  final String token;
  final int expiresInSeconds;
  final String email;
  /// Canonical server-owned account scope. `householdId` remains temporarily
  /// for legacy presentation code and has exactly the same value.
  final String accountId;
  final String householdId;
  final String? name;
  final String? picture;

  factory ApiSession.fromJson(Map<String, dynamic> json) {
    final user = Map<String, dynamic>.from(json['user'] as Map? ?? const {});
    return ApiSession(
      token: json['token'] as String,
      expiresInSeconds: json['expiresInSeconds'] as int? ?? 0,
      email: user['email'] as String,
      accountId: (user['accountId'] ?? user['householdId']) as String,
      householdId: (user['householdId'] ?? user['accountId']) as String,
      name: user['name'] as String?,
      picture: user['picture'] as String?,
    );
  }
}

abstract class SessionStorage {
  Future<String?> read({required String key});

  Future<void> write({required String key, required String value});

  Future<void> delete({required String key});
}

class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);
}

class GoogleSessionClient {
  GoogleSessionClient({
    required this.apiBaseUrl,
    required this.googleWebClientId,
    http.Client? httpClient,
    SessionStorage? storage,
  }) : httpClient = httpClient ?? http.Client(),
       storage = storage ?? SecureSessionStorage();

  static const _tokenKey = 'zimbacontrol.sessionToken';
  static const _emailKey = 'zimbacontrol.sessionEmail';
  static const _accountKey = 'zimbacontrol.sessionAccount';
  static const _householdKey = 'zimbacontrol.sessionHousehold';
  static const _expiresAtKey = 'zimbacontrol.sessionExpiresAt';
  static bool _initialized = false;

  final String apiBaseUrl;
  final String googleWebClientId;
  final http.Client httpClient;
  final SessionStorage storage;

  Future<String?> readSessionToken() => storage.read(key: _tokenKey);

  Future<String?> readSessionEmail() => storage.read(key: _emailKey);

  Future<String?> readSessionAccount() => storage.read(key: _accountKey);

  Future<String?> readSessionHousehold() => storage.read(key: _householdKey);

  /// Returns the stored session only when it still has the minimum identity
  /// data needed by the sync API. Older installations did not persist an
  /// expiry; their existing session remains valid until the server rejects it.
  Future<ApiSession?> readStoredSession() async {
    final token = await readSessionToken();
    final email = await readSessionEmail();
    final householdId = await readSessionHousehold();
    final accountId = await readSessionAccount() ?? householdId;
    if (token == null || token.isEmpty || email == null || accountId == null) {
      return null;
    }
    final expiresAt = await storage.read(key: _expiresAtKey);
    final expiresAtMillis = int.tryParse(expiresAt ?? '');
    if (expiresAtMillis != null &&
        DateTime.now().millisecondsSinceEpoch >= expiresAtMillis) {
      await _clearStoredSession();
      return null;
    }
    return ApiSession(
      token: token,
      expiresInSeconds: expiresAtMillis == null
          ? 0
          : ((expiresAtMillis - DateTime.now().millisecondsSinceEpoch) / 1000)
              .ceil()
              .clamp(0, 1 << 31),
      email: email,
      accountId: accountId,
      householdId: householdId ?? accountId,
    );
  }

  static Future<void> clearStoredSession({
    FlutterSecureStorage? storage,
  }) async {
    final secureStorage = storage ?? const FlutterSecureStorage();
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _emailKey);
    await secureStorage.delete(key: _accountKey);
    await secureStorage.delete(key: _householdKey);
    await secureStorage.delete(key: _expiresAtKey);
  }

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

    return _storeSession(response);
  }

  Future<ApiSession> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final response = await httpClient.post(
      Uri.parse('$apiBaseUrl/auth/login'),
      headers: const {'content-type': 'application/json'},
      body: jsonEncode({'email': email.trim(), 'password': password}),
    );
    if (response.statusCode != 200) {
      throw GoogleSessionException('password_auth_failed_${response.statusCode}');
    }
    return _storeSession(response);
  }

  Future<ApiSession> registerWithPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await httpClient.post(
      Uri.parse('$apiBaseUrl/auth/register'),
      headers: const {'content-type': 'application/json'},
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
      }),
    );
    if (response.statusCode != 200) {
      throw GoogleSessionException('password_registration_failed_${response.statusCode}');
    }
    return _storeSession(response);
  }

  Future<void> signOut() async {
    await _clearStoredSession();
    if (googleWebClientId.isEmpty) {
      return;
    }
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

  Future<ApiSession> _storeSession(http.Response response) async {
    final session = ApiSession.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    await storage.write(key: _tokenKey, value: session.token);
    await storage.write(key: _emailKey, value: session.email);
    await storage.write(key: _accountKey, value: session.accountId);
    await storage.write(key: _householdKey, value: session.householdId);
    if (session.expiresInSeconds > 0) {
      final expiresAt = DateTime.now()
          .add(Duration(seconds: session.expiresInSeconds))
          .millisecondsSinceEpoch;
      await storage.write(key: _expiresAtKey, value: expiresAt.toString());
    }
    return session;
  }

  Future<void> _clearStoredSession() async {
    await storage.delete(key: _tokenKey);
    await storage.delete(key: _emailKey);
    await storage.delete(key: _accountKey);
    await storage.delete(key: _householdKey);
    await storage.delete(key: _expiresAtKey);
  }
}

class GoogleSessionException implements Exception {
  const GoogleSessionException(this.message);

  final String message;

  @override
  String toString() => message;
}
