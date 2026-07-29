import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/application/import_parser.dart';

void main() {
  test('parses Nubank-style CSV into canonical records', () {
    final csv = [
      'Data;Descricao;Valor;Identificador',
      '2026-07-20;Mercado Exemplo;-45,67;nubank-1',
      '21/07/2026;Salario;1000,00;nubank-2',
    ].join('\n');

    final result = parseStatementFile(
      fileName: 'nubank_julho.csv',
      bytes: utf8.encode(csv),
    );

    expect(result.fileFormat, 'csv');
    expect(result.provider, 'nubank');
    expect(result.records, hasLength(2));
    expect(result.records.first.amountCents, -4567);
    expect(result.records.first.occurredAt, DateTime(2026, 7, 20));
    expect(result.records.last.amountCents, 100000);
  });

  test('parses Mercado Pago-style CSV with invalid row reporting', () {
    final csv = [
      'Data de operacao,Codigo de operacao,Tipo de operacao,Valor',
      '20/07/2026,mp-1,Compra mercado,-12.34',
      'sem-data,mp-2,,x',
    ].join('\n');

    final result = parseStatementFile(
      fileName: 'mercado_pago.csv',
      bytes: utf8.encode(csv),
    );

    expect(result.provider, 'mercado_pago');
    expect(result.records.first.amountCents, -1234);
    expect(result.records.last.status, 'invalid');
  });

  test('parses unknown CSV with manual column mapping', () {
    final csv = [
      'Quando;Historico;Total;Chave',
      '22/07/2026;Padaria bairro;-18,40;linha-1',
    ].join('\n');

    final result = parseStatementFile(
      fileName: 'extrato_desconhecido.csv',
      bytes: utf8.encode(csv),
      csvMapping: const CsvImportMapping(
        dateColumn: 'Quando',
        descriptionColumn: 'Historico',
        amountColumn: 'Total',
        externalIdColumn: 'Chave',
      ),
    );

    expect(result.provider, 'unknown');
    expect(result.records.single.status, 'valid');
    expect(result.records.single.description, 'Padaria bairro');
    expect(result.records.single.amountCents, -1840);
    expect(result.records.single.externalId, 'linha-1');
  });

  test('parses OFX statement transactions', () {
    final ofx = '''
OFXHEADER:100
DATA:OFXSGML
<OFX>
<BANKTRANLIST>
<STMTTRN>
<TRNTYPE>DEBIT
<DTPOSTED>20260720120000[-3:BRT]
<TRNAMT>-89.90
<FITID>ofx-1
<NAME>Farmacia Teste
<MEMO>Compra cartao
</STMTTRN>
</BANKTRANLIST>
</OFX>
''';

    final result = parseStatementFile(
      fileName: 'extrato.ofx',
      bytes: utf8.encode(ofx),
    );

    expect(result.fileFormat, 'ofx');
    expect(result.records, hasLength(1));
    expect(result.records.first.externalId, 'ofx-1');
    expect(result.records.first.amountCents, -8990);
    expect(result.records.first.description, contains('Farmacia Teste'));
  });
}
