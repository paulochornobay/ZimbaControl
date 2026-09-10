import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:zimba_control/src/infrastructure/google_session_client.dart';

void main() {
  test('autentica por senha e armazena somente a sessao retornada pela API', () async {
    final storage = _MemorySessionStorage();
    final client = GoogleSessionClient(
      apiBaseUrl: 'https://api.example.test',
      googleWebClientId: '',
      storage: storage,
      httpClient: MockClient((request) async {
        expect(request.url.toString(), 'https://api.example.test/auth/login');
        expect(request.headers['content-type'], 'application/json');
        expect(
          jsonDecode(request.body),
          {'email': 'admin@zimbacontrol.com.br', 'password': 'senha-de-teste'},
        );
        return http.Response(
          jsonEncode({
            'token': 'session-token',
            'expiresInSeconds': 3600,
            'user': {
              'email': 'admin@zimbacontrol.com.br',
              'householdId': 'household-admin',
              'name': 'Admin',
            },
          }),
          200,
        );
      }),
    );

    final session = await client.signInWithPassword(
      email: '  admin@zimbacontrol.com.br ',
      password: 'senha-de-teste',
    );

    expect(session.token, 'session-token');
    expect(session.email, 'admin@zimbacontrol.com.br');
    expect(session.householdId, 'household-admin');
    expect(await client.readSessionToken(), 'session-token');
    expect(await client.readSessionEmail(), 'admin@zimbacontrol.com.br');
    expect(await client.readSessionHousehold(), 'household-admin');
    expect(storage.values.values, isNot(contains('senha-de-teste')));
  });

  test('reporta credencial recusada pela API', () async {
    final client = GoogleSessionClient(
      apiBaseUrl: 'https://api.example.test',
      googleWebClientId: '',
      storage: _MemorySessionStorage(),
      httpClient: MockClient((_) async => http.Response('{}', 401)),
    );

    expect(
      () => client.signInWithPassword(email: 'admin@example.com', password: 'errada'),
      throwsA(isA<GoogleSessionException>()),
    );
  });
}

class _MemorySessionStorage implements SessionStorage {
  final values = <String, String>{};

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }
}
