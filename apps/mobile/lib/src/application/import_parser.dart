import 'dart:convert';

import 'package:crypto/crypto.dart';

class ImportParseResult {
  const ImportParseResult({
    required this.fileHash,
    required this.fileFormat,
    required this.provider,
    required this.records,
  });

  final String fileHash;
  final String fileFormat;
  final String provider;
  final List<CanonicalImportRecord> records;
}

class CanonicalImportRecord {
  const CanonicalImportRecord({
    required this.rowIndex,
    required this.rowHash,
    required this.sourceKind,
    required this.provider,
    required this.rawPayload,
    this.externalId,
    this.occurredAt,
    this.postedAt,
    this.description,
    this.amountCents,
    this.currencyCode = 'BRL',
    this.accountHint,
    this.status = 'valid',
    this.errorMessage,
    this.confidence = 0.72,
  });

  final int rowIndex;
  final String rowHash;
  final String sourceKind;
  final String provider;
  final String rawPayload;
  final String? externalId;
  final DateTime? occurredAt;
  final DateTime? postedAt;
  final String? description;
  final int? amountCents;
  final String currencyCode;
  final String? accountHint;
  final String status;
  final String? errorMessage;
  final double confidence;

  bool get isValid =>
      status == 'valid' &&
      occurredAt != null &&
      description != null &&
      description!.trim().isNotEmpty &&
      amountCents != null;
}

ImportParseResult parseStatementFile({
  required String fileName,
  required List<int> bytes,
  CsvImportMapping? csvMapping,
}) {
  final text = decodeStatementBytes(bytes);
  final fileHash = sha256Hex(bytes);
  final lowerName = fileName.toLowerCase();

  if (lowerName.endsWith('.ofx') || text.toUpperCase().contains('<OFX')) {
    return _parseOfx(text: text, fileHash: fileHash);
  }

  return _parseCsv(
    text: text,
    fileHash: fileHash,
    fileName: fileName,
    manualMapping: csvMapping,
  );
}

String decodeStatementBytes(List<int> bytes) {
  if (bytes.length >= 3 &&
      bytes[0] == 0xEF &&
      bytes[1] == 0xBB &&
      bytes[2] == 0xBF) {
    return utf8.decode(bytes.sublist(3), allowMalformed: true);
  }

  return utf8.decode(bytes, allowMalformed: true);
}

String sha256Hex(List<int> bytes) => sha256.convert(bytes).toString();

ImportParseResult _parseCsv({
  required String text,
  required String fileHash,
  required String fileName,
  CsvImportMapping? manualMapping,
}) {
  final lines = const LineSplitter()
      .convert(text)
      .where((line) => line.trim().isNotEmpty)
      .toList(growable: false);
  if (lines.isEmpty) {
    return ImportParseResult(
      fileHash: fileHash,
      fileFormat: 'csv',
      provider: 'unknown',
      records: const [],
    );
  }

  final delimiter = _detectDelimiter(lines.first);
  final header = _parseCsvLine(
    lines.first,
    delimiter,
  ).map(_normalizeHeader).toList(growable: false);
  final provider = _detectCsvProvider(fileName, header);
  final mapping = manualMapping == null
      ? _CsvMapping.fromHeaders(header)
      : _CsvMapping(
          date: _normalizeHeader(manualMapping.dateColumn),
          description: _normalizeHeader(manualMapping.descriptionColumn),
          amount: _normalizeHeader(manualMapping.amountColumn),
          externalId: manualMapping.externalIdColumn == null
              ? null
              : _normalizeHeader(manualMapping.externalIdColumn!),
        );
  final records = <CanonicalImportRecord>[];

  for (var index = 1; index < lines.length; index += 1) {
    final rawLine = lines[index];
    final values = _parseCsvLine(rawLine, delimiter);
    final row = <String, String>{
      for (var column = 0; column < header.length; column += 1)
        header[column]: column < values.length ? values[column].trim() : '',
    };

    final description = mapping.description == null
        ? null
        : row[mapping.description]?.trim();
    final occurredAt = mapping.date == null
        ? null
        : parseFlexibleDate(row[mapping.date] ?? '');
    final amount = mapping.amount == null
        ? null
        : parseAmountCents(row[mapping.amount] ?? '');
    final rowHash = sha256Hex(utf8.encode('$provider|$rawLine'));
    final externalId = mapping.externalId == null
        ? null
        : row[mapping.externalId]?.trim();
    final isValid =
        description != null &&
        description.isNotEmpty &&
        occurredAt != null &&
        amount != null;

    records.add(
      CanonicalImportRecord(
        rowIndex: index,
        rowHash: rowHash,
        sourceKind: 'csv',
        provider: provider,
        rawPayload: rawLine,
        externalId: externalId?.isEmpty ?? true ? null : externalId,
        occurredAt: occurredAt,
        postedAt: occurredAt,
        description: description,
        amountCents: amount,
        accountHint: provider,
        status: isValid ? 'valid' : 'invalid',
        errorMessage: isValid ? null : 'Linha CSV incompleta ou invalida',
        confidence: provider == 'unknown' ? 0.55 : 0.78,
      ),
    );
  }

  return ImportParseResult(
    fileHash: fileHash,
    fileFormat: 'csv',
    provider: provider,
    records: records,
  );
}

ImportParseResult _parseOfx({required String text, required String fileHash}) {
  final normalized = text.replaceAll('\r', '\n');
  final blocks = RegExp(
    r'<STMTTRN>(.*?)(?=<STMTTRN>|</BANKTRANLIST>|</CCSTMTRS>|$)',
    caseSensitive: false,
    dotAll: true,
  ).allMatches(normalized).toList(growable: false);
  final provider = _detectOfxProvider(normalized);
  final records = <CanonicalImportRecord>[];

  for (var index = 0; index < blocks.length; index += 1) {
    final block = blocks[index].group(1) ?? '';
    final dateText = _ofxTag(block, 'DTPOSTED') ?? _ofxTag(block, 'DTUSER');
    final amountText = _ofxTag(block, 'TRNAMT');
    final name = _ofxTag(block, 'NAME');
    final memo = _ofxTag(block, 'MEMO');
    final fitId = _ofxTag(block, 'FITID');
    final description = [
      name,
      memo,
    ].where((value) => value != null && value.trim().isNotEmpty).join(' - ');
    final occurredAt = parseOfxDate(dateText ?? '');
    final amount = parseAmountCents(amountText ?? '');
    final rowHash = sha256Hex(utf8.encode('$provider|$block'));
    final isValid =
        description.isNotEmpty && occurredAt != null && amount != null;

    records.add(
      CanonicalImportRecord(
        rowIndex: index + 1,
        rowHash: rowHash,
        sourceKind: 'ofx',
        provider: provider,
        rawPayload: block.trim(),
        externalId: fitId,
        occurredAt: occurredAt,
        postedAt: occurredAt,
        description: description.isEmpty ? null : description,
        amountCents: amount,
        accountHint: provider,
        status: isValid ? 'valid' : 'invalid',
        errorMessage: isValid ? null : 'Registro OFX incompleto ou invalido',
        confidence: provider == 'unknown' ? 0.62 : 0.82,
      ),
    );
  }

  return ImportParseResult(
    fileHash: fileHash,
    fileFormat: 'ofx',
    provider: provider,
    records: records,
  );
}

String? _ofxTag(String block, String tag) {
  final match = RegExp(
    '<$tag>([^<\\n\\r]*)',
    caseSensitive: false,
  ).firstMatch(block);
  return match?.group(1)?.trim();
}

String _detectOfxProvider(String text) {
  final normalized = text.toLowerCase();
  if (normalized.contains('nubank') || normalized.contains('nu pagamentos')) {
    return 'nubank';
  }
  if (normalized.contains('mercado pago') ||
      normalized.contains('mercadopago')) {
    return 'mercado_pago';
  }
  return 'unknown';
}

String _detectCsvProvider(String fileName, List<String> header) {
  final joined = '${fileName.toLowerCase()} ${header.join(' ')}';
  if (fileName.toLowerCase().contains('mercado')) {
    return 'mercado_pago';
  }
  if (fileName.toLowerCase().contains('nubank')) {
    return 'nubank';
  }
  if (joined.contains('nubank') ||
      joined.contains('identificador') ||
      joined.contains('valor') && joined.contains('descricao')) {
    return 'nubank';
  }
  if (joined.contains('mercado') ||
      joined.contains('codigo de operacao') ||
      joined.contains('tipo de operacao')) {
    return 'mercado_pago';
  }
  return 'unknown';
}

String _normalizeHeader(String header) {
  final lower = header.trim().toLowerCase();
  const replacements = {
    'á': 'a',
    'à': 'a',
    'ã': 'a',
    'â': 'a',
    'é': 'e',
    'ê': 'e',
    'í': 'i',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ú': 'u',
    'ç': 'c',
  };
  return lower
      .split('')
      .map((char) => replacements[char] ?? char)
      .join()
      .replaceAll(RegExp(r'\s+'), ' ');
}

String _detectDelimiter(String headerLine) {
  final semicolons = ';'.allMatches(headerLine).length;
  final commas = ','.allMatches(headerLine).length;
  final tabs = '\t'.allMatches(headerLine).length;
  if (tabs > semicolons && tabs > commas) {
    return '\t';
  }
  return semicolons >= commas ? ';' : ',';
}

List<String> _parseCsvLine(String line, String delimiter) {
  final values = <String>[];
  final buffer = StringBuffer();
  var quoted = false;

  for (var index = 0; index < line.length; index += 1) {
    final char = line[index];
    final next = index + 1 < line.length ? line[index + 1] : null;
    if (char == '"' && quoted && next == '"') {
      buffer.write('"');
      index += 1;
      continue;
    }
    if (char == '"') {
      quoted = !quoted;
      continue;
    }
    if (char == delimiter && !quoted) {
      values.add(buffer.toString());
      buffer.clear();
      continue;
    }
    buffer.write(char);
  }

  values.add(buffer.toString());
  return values;
}

DateTime? parseFlexibleDate(String input) {
  final value = input.trim();
  if (value.isEmpty) {
    return null;
  }

  final iso = DateTime.tryParse(value);
  if (iso != null) {
    return DateTime(iso.year, iso.month, iso.day);
  }

  final br = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{2,4})$').firstMatch(value);
  if (br != null) {
    final day = int.parse(br.group(1)!);
    final month = int.parse(br.group(2)!);
    final rawYear = int.parse(br.group(3)!);
    final year = rawYear < 100 ? 2000 + rawYear : rawYear;
    return DateTime(year, month, day);
  }

  return parseOfxDate(value);
}

DateTime? parseOfxDate(String input) {
  final digits = RegExp(r'^\d{8}').firstMatch(input.trim())?.group(0);
  if (digits == null) {
    return null;
  }

  return DateTime(
    int.parse(digits.substring(0, 4)),
    int.parse(digits.substring(4, 6)),
    int.parse(digits.substring(6, 8)),
  );
}

int? parseAmountCents(String input) {
  var normalized = input.trim();
  if (normalized.isEmpty) {
    return null;
  }

  var negative = normalized.startsWith('-') || normalized.startsWith('(');
  normalized = normalized
      .replaceAll(RegExp(r'[R$\s]'), '')
      .replaceAll('(', '')
      .replaceAll(')', '');

  final lastComma = normalized.lastIndexOf(',');
  final lastDot = normalized.lastIndexOf('.');
  final decimalIndex = lastComma > lastDot ? lastComma : lastDot;

  String centsText;
  if (decimalIndex >= 0) {
    final whole = normalized
        .substring(0, decimalIndex)
        .replaceAll(RegExp(r'[^0-9]'), '');
    final fraction = normalized
        .substring(decimalIndex + 1)
        .replaceAll(RegExp(r'[^0-9]'), '')
        .padRight(2, '0')
        .substring(0, 2);
    centsText = '$whole$fraction';
  } else {
    centsText = normalized.replaceAll(RegExp(r'[^0-9]'), '');
  }

  if (centsText.isEmpty) {
    return null;
  }

  final cents = int.parse(centsText);
  return negative ? -cents : cents;
}

class _CsvMapping {
  const _CsvMapping({
    required this.date,
    required this.description,
    required this.amount,
    required this.externalId,
  });

  final String? date;
  final String? description;
  final String? amount;
  final String? externalId;

  static _CsvMapping fromHeaders(List<String> headers) {
    String? first(List<String> candidates) {
      for (final candidate in candidates) {
        if (headers.contains(candidate)) {
          return candidate;
        }
      }
      return null;
    }

    return _CsvMapping(
      date: first(['data', 'date', 'data da compra', 'data de operacao']),
      description: first([
        'descricao',
        'description',
        'titulo',
        'nome',
        'detalhe',
        'tipo de operacao',
      ]),
      amount: first(['valor', 'amount', 'valor da compra', 'quantia']),
      externalId: first(['id', 'identificador', 'codigo de operacao', 'fitid']),
    );
  }
}

class CsvImportMapping {
  const CsvImportMapping({
    required this.dateColumn,
    required this.descriptionColumn,
    required this.amountColumn,
    this.externalIdColumn,
  });

  final String dateColumn;
  final String descriptionColumn;
  final String amountColumn;
  final String? externalIdColumn;
}
