class FinancialInstitution {
  const FinancialInstitution({
    required this.key,
    required this.displayName,
    required this.aliases,
    this.bankIds = const [],
  });

  final String key;
  final String displayName;
  final List<String> aliases;
  final List<String> bankIds;
}

class ResolvedFinancialInstitution {
  const ResolvedFinancialInstitution({
    required this.key,
    required this.displayName,
    required this.confidence,
    this.rawName,
  });

  final String key;
  final String displayName;
  final double confidence;
  final String? rawName;

  bool get isKnown => key != 'unknown';
}

/// One local, extensible place for normalising OFX institution metadata.
/// No account identifiers or statement payloads are retained here.
class FinancialInstitutionRegistry {
  FinancialInstitutionRegistry._();

  static const _institutions = <FinancialInstitution>[
    FinancialInstitution(
      key: 'nubank',
      displayName: 'Nubank',
      aliases: ['nubank', 'nu pagamentos', 'nu financeira'],
      bankIds: ['260'],
    ),
    FinancialInstitution(
      key: 'mercado_pago',
      displayName: 'Mercado Pago',
      aliases: ['mercado pago', 'mercadopago', 'mercado livre'],
    ),
    FinancialInstitution(
      key: 'itau',
      displayName: 'Itaú',
      aliases: ['itau', 'itaú', 'banco itau', 'banco itaú'],
      bankIds: ['341'],
    ),
    FinancialInstitution(
      key: 'banco_do_brasil',
      displayName: 'Banco do Brasil',
      aliases: ['banco do brasil', 'bb'],
      bankIds: ['001'],
    ),
    FinancialInstitution(
      key: 'santander',
      displayName: 'Santander',
      aliases: ['santander', 'banco santander'],
      bankIds: ['033'],
    ),
    FinancialInstitution(
      key: 'bradesco',
      displayName: 'Bradesco',
      aliases: ['bradesco', 'banco bradesco'],
      bankIds: ['237'],
    ),
    FinancialInstitution(
      key: 'caixa',
      displayName: 'Caixa',
      aliases: ['caixa', 'caixa economica', 'caixa econômica federal'],
      bankIds: ['104'],
    ),
    FinancialInstitution(
      key: 'inter',
      displayName: 'Inter',
      aliases: ['inter', 'banco inter'],
      bankIds: ['077'],
    ),
    FinancialInstitution(
      key: 'c6',
      displayName: 'C6 Bank',
      aliases: ['c6', 'c6 bank', 'banco c6'],
      bankIds: ['336'],
    ),
    FinancialInstitution(
      key: 'sicredi',
      displayName: 'Sicredi',
      aliases: ['sicredi'],
      bankIds: ['748'],
    ),
    FinancialInstitution(
      key: 'sicoob',
      displayName: 'Sicoob',
      aliases: ['sicoob'],
      bankIds: ['756'],
    ),
  ];

  static ResolvedFinancialInstitution resolve({
    String? org,
    String? fid,
    String? bankId,
    String? fallback,
  }) {
    final raw = [org, fid, fallback]
        .whereType<String>()
        .map((value) => value.trim())
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');
    final normalized = _normalize(
      [org, fid, fallback].whereType<String>().join(' '),
    );
    final cleanBankId = bankId?.trim().padLeft(3, '0');
    for (final institution in _institutions) {
      if (cleanBankId != null && institution.bankIds.contains(cleanBankId)) {
        return ResolvedFinancialInstitution(
          key: institution.key,
          displayName: institution.displayName,
          confidence: 0.96,
          rawName: raw.isEmpty ? null : raw,
        );
      }
      if (institution.aliases.any(
        (alias) => normalized.contains(_normalize(alias)),
      )) {
        return ResolvedFinancialInstitution(
          key: institution.key,
          displayName: institution.displayName,
          confidence: 0.9,
          rawName: raw.isEmpty ? null : raw,
        );
      }
    }
    return ResolvedFinancialInstitution(
      key: 'unknown',
      displayName: raw.isEmpty ? 'Instituição não identificada' : raw,
      confidence: 0,
      rawName: raw.isEmpty ? null : raw,
    );
  }

  static String displayNameFor(String key) {
    for (final institution in _institutions) {
      if (institution.key == key) return institution.displayName;
    }
    return key == 'unknown' ? 'Instituição não identificada' : key;
  }

  static String _normalize(String value) {
    const replacements = {
      'á': 'a',
      'à': 'a',
      'ã': 'a',
      'â': 'a',
      'ä': 'a',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ï': 'i',
      'ó': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ú': 'u',
      'ü': 'u',
      'ç': 'c',
    };
    return value
        .toLowerCase()
        .split('')
        .map((char) => replacements[char] ?? char)
        .join();
  }
}
