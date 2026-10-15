import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:zimba_control/src/infrastructure/online_finance_client.dart';

void main() {
  test('consulta entidades pela sessao sem enviar escopo de conta', () async {
    final client = OnlineFinanceClient(
      baseUrl: 'https://api.example.test/',
      sessionToken: 'token-da-sessao',
      httpClient: MockClient((request) async {
        expect(request.url.toString(), 'https://api.example.test/v1/entities/transaction');
        expect(request.headers['authorization'], 'Bearer token-da-sessao');
        expect(request.url.queryParameters.containsKey('householdId'), isFalse);
        return http.Response(jsonEncode({
          'data': [
            {
              'entityId': 'tx-1',
              'entityType': 'transaction',
              'baseVersion': 3,
              'payload': {'transaction': {'id': 'tx-1'}},
            },
          ],
        }), 200);
      }),
    );

    final rows = await client.listTransactions();

    expect(rows, hasLength(1));
    expect(rows.single.entityId, 'tx-1');
    expect(rows.single.baseVersion, 3);
  });

  test('falha sem rede nao cria fila local', () async {
    final client = OnlineFinanceClient(
      baseUrl: 'https://api.example.test',
      sessionToken: 'token-da-sessao',
      httpClient: MockClient((_) async => throw Exception('offline')),
    );

    expect(client.listTransactions(), throwsA(isA<OnlineFinanceException>()));
  });
}
