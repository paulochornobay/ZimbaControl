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

  test('generic Portuguese CSV is not silently labeled as Nubank', () {
    final result = parseStatementFile(
      fileName: 'extrato.csv',
      bytes: utf8.encode('Data;Descricao;Valor\n22/07/2026;Padaria;-18,40'),
    );

    expect(result.provider, 'unknown');
    expect(result.statementIdentity.statementType, 'unknown');
  });

  test('inspects CSV columns and suggests a complete mapping', () {
    final csv = [
      'Data;Descrição;Valor;Identificador',
      '22/07/2026;Padaria;-18,40;linha-1',
    ].join('\n');

    final inspection = inspectCsvFile(
      fileName: 'nubank.csv',
      bytes: utf8.encode(csv),
    );

    expect(inspection.columns, ['Data', 'Descrição', 'Valor', 'Identificador']);
    expect(inspection.provider, 'nubank');
    expect(inspection.suggestedMapping?.dateColumn, 'Data');
    expect(inspection.suggestedMapping?.descriptionColumn, 'Descrição');
    expect(inspection.suggestedMapping?.amountColumn, 'Valor');
    expect(inspection.suggestedMapping?.externalIdColumn, 'Identificador');
  });

  test('parses OFX statement transactions', () {
    final ofx = '''
OFXHEADER:100
DATA:OFXSGML
<OFX>
<SIGNONMSGSRSV1><SONRS><FI><ORG>Nubank</FI></SONRS></SIGNONMSGSRSV1>
<BANKMSGSRSV1><STMTTRNRS><STMTRS>
<CURDEF>BRL
<BANKACCTFROM>
<BANKID>260
<BRANCHID>0001
<ACCTID>000123456789
<ACCTTYPE>CHECKING
</BANKACCTFROM>
<BANKTRANLIST>
<DTSTART>20260701000000[-3:BRT]
<DTEND>20260731235959[-3:BRT]
<STMTTRN>
<TRNTYPE>DEBIT
<DTPOSTED>20260720120000[-3:BRT]
<TRNAMT>-89.90
<FITID>ofx-1
<NAME>Farmacia Teste
<MEMO>Compra cartao
</STMTTRN>
</BANKTRANLIST>
<LEDGERBAL><BALAMT>1234.56<DTASOF>20260731235959</LEDGERBAL>
<AVAILBAL><BALAMT>1200.00<DTASOF>20260731235959</AVAILBAL>
</STMTRS></STMTTRNRS></BANKMSGSRSV1>
</OFX>
''';

    final result = parseStatementFile(
      fileName: 'extrato.ofx',
      bytes: utf8.encode(ofx),
    );

    expect(result.fileFormat, 'ofx');
    expect(result.statementIdentity.statementType, 'bank');
    expect(result.statementIdentity.accountId, '000123456789');
    expect(result.statementIdentity.last4, '6789');
    expect(result.statementIdentity.currencyCode, 'BRL');
    expect(result.statementIdentity.periodStart, DateTime(2026, 7, 1));
    expect(result.statementIdentity.periodEnd, DateTime(2026, 7, 31));
    expect(result.statementIdentity.ledgerBalanceCents, 123456);
    expect(result.statementIdentity.availableBalanceCents, 120000);
    expect(result.records, hasLength(1));
    expect(result.records.first.externalId, 'ofx-1');
    expect(result.records.first.amountCents, -8990);
    expect(result.records.first.description, contains('Farmacia Teste'));
  });

  test('identifies credit card OFX and tolerates missing ACCTID', () {
    final withAccount = parseStatementFile(
      fileName: 'nubank-cartao.ofx',
      bytes: utf8.encode('''
<OFX><CCSTMTTRNRS><CCSTMTRS><CURDEF>BRL
<CCACCTFROM><ACCTID>9999888877774321</CCACCTFROM>
<BANKTRANLIST><DTSTART>20260801000000<DTEND>20260831235959
<STMTTRN><DTPOSTED>20260810<TRNAMT>-9.90<FITID>cc-1<NAME>Teste</STMTTRN>
</BANKTRANLIST></CCSTMTRS></CCSTMTTRNRS></OFX>
'''),
    );
    final withoutAccount = parseStatementFile(
      fileName: 'cartao.ofx',
      bytes: utf8.encode('''
<OFX><CCSTMTRS><CURDEF>BRL<CCACCTFROM></CCACCTFROM>
<BANKTRANLIST><STMTTRN><DTPOSTED>20260810<TRNAMT>-1.00<FITID>cc-2<NAME>Teste</STMTTRN></BANKTRANLIST>
</CCSTMTRS></OFX>
'''),
    );

    expect(withAccount.statementIdentity.statementType, 'credit_card');
    expect(withAccount.statementIdentity.last4, '4321');
    expect(withoutAccount.statementIdentity.statementType, 'credit_card');
    expect(withoutAccount.statementIdentity.accountId, isNull);
  });
}
