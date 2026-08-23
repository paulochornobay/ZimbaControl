import 'package:flutter/material.dart';

import '../../data/local/app_database.dart';
import 'zimba_theme.dart';

String instrumentProviderLabel(String provider) {
  return switch (provider.trim().toLowerCase()) {
    'nubank' => 'Nubank',
    'mercado_pago' => 'Mercado Pago',
    'itau' => 'Itaú',
    'caixa' => 'Caixa',
    'bradesco' => 'Bradesco',
    'santander' => 'Santander',
    'manual' || 'zimba_control' => 'Manual',
    final value when value.isNotEmpty =>
      value
          .split('_')
          .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
          .join(' '),
    _ => 'Instituição não informada',
  };
}

String instrumentTypeLabel(String type) => switch (type) {
  'credit_card' => 'Cartão de crédito',
  'checking' => 'Conta corrente',
  'savings' => 'Poupança',
  'wallet' => 'Carteira',
  'statement' => 'Demonstrativo',
  _ => 'Conta',
};

IconData instrumentTypeIcon(String type) => switch (type) {
  'credit_card' => Icons.credit_card_outlined,
  'checking' => Icons.account_balance_outlined,
  'savings' => Icons.savings_outlined,
  'wallet' => Icons.account_balance_wallet_outlined,
  'statement' => Icons.description_outlined,
  _ => Icons.account_balance_wallet_outlined,
};

class InstrumentDisplay extends StatelessWidget {
  const InstrumentDisplay({
    required this.name,
    required this.provider,
    required this.type,
    this.ownerName,
    this.last4,
    this.compact = false,
    this.subtitleOverride,
    super.key,
  });

  factory InstrumentDisplay.account(
    AccountWithOwner item, {
    bool compact = false,
    Key? key,
  }) {
    return InstrumentDisplay(
      key: key,
      name: item.account.name,
      provider: item.account.provider,
      type: item.account.type,
      ownerName: item.ownerLabel,
      last4: item.account.last4,
      compact: compact,
    );
  }

  factory InstrumentDisplay.card(
    CreditCardWithOwner item, {
    bool compact = false,
    Key? key,
  }) {
    return InstrumentDisplay(
      key: key,
      name: item.creditCard.name,
      provider: item.creditCard.provider,
      type: 'credit_card',
      ownerName: item.ownerLabel,
      last4: item.creditCard.last4,
      compact: compact,
    );
  }

  final String name;
  final String provider;
  final String type;
  final String? ownerName;
  final String? last4;
  final bool compact;
  final String? subtitleOverride;

  @override
  Widget build(BuildContext context) {
    final normalizedLast4 = last4?.trim();
    final metadata =
        subtitleOverride ??
        [
          instrumentProviderLabel(provider),
          instrumentTypeLabel(type),
          if (ownerName?.trim().isNotEmpty == true) ownerName!.trim(),
        ].join(' · ');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 30 : 38,
          height: compact ? 30 : 38,
          decoration: BoxDecoration(
            color: type == 'credit_card'
                ? const Color(0xFFF3E8FF)
                : ZimbaColors.accentSoft,
            borderRadius: BorderRadius.circular(compact ? 9 : 11),
          ),
          child: Icon(
            instrumentTypeIcon(type),
            size: compact ? 16 : 20,
            color: type == 'credit_card'
                ? const Color(0xFF7E22CE)
                : ZimbaColors.accent,
          ),
        ),
        SizedBox(width: compact ? 8 : 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: compact ? 13 : null,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                metadata,
                maxLines: compact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ZimbaColors.secondaryText,
                  fontSize: compact ? 10.5 : null,
                ),
              ),
            ],
          ),
        ),
        if (normalizedLast4 != null && normalizedLast4.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text(
            '•••• $normalizedLast4',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ZimbaColors.secondaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class InstrumentChoice extends StatelessWidget {
  const InstrumentChoice({
    required this.instrument,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final InstrumentDisplay instrument;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected ? ZimbaColors.accentSoft : Colors.white,
            border: Border.all(
              color: selected ? ZimbaColors.accent : ZimbaColors.border,
              width: selected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(child: instrument),
              const SizedBox(width: 8),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                size: 20,
                color: selected ? ZimbaColors.accent : ZimbaColors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const classificationIconKeys = <String>[
  'tag',
  'cart',
  'health',
  'education',
  'transport',
  'home',
  'leisure',
  'income',
  'child',
  'work',
  'car',
  'personal',
];

const classificationColorKeys = <String>[
  'slate',
  'blue',
  'green',
  'red',
  'amber',
  'purple',
  'cyan',
  'pink',
];

IconData classificationIcon(String key) => switch (key) {
  'cart' => Icons.shopping_cart_outlined,
  'health' => Icons.medical_services_outlined,
  'education' => Icons.school_outlined,
  'transport' => Icons.directions_car_outlined,
  'home' => Icons.home_outlined,
  'leisure' => Icons.movie_outlined,
  'income' => Icons.trending_up,
  'child' => Icons.child_care_outlined,
  'work' => Icons.work_outline,
  'car' => Icons.directions_car_filled_outlined,
  'personal' => Icons.person_outline,
  _ => Icons.sell_outlined,
};

Color classificationColor(String key) => switch (key) {
  'blue' => const Color(0xFF2563EB),
  'green' => const Color(0xFF16A34A),
  'red' => const Color(0xFFDC2626),
  'amber' => const Color(0xFFD97706),
  'purple' => const Color(0xFF7E22CE),
  'cyan' => const Color(0xFF0891B2),
  'pink' => const Color(0xFFDB2777),
  _ => const Color(0xFF64748B),
};

(String, String) suggestClassificationVisual(
  String name, {
  String kind = 'expense',
  bool costCenter = false,
}) {
  final normalized = _foldVisualText(name);
  if (costCenter) {
    if (normalized.contains('casa')) return ('home', 'green');
    if (normalized.contains('filh') || normalized.contains('crian')) {
      return ('child', 'purple');
    }
    if (normalized.contains('carro') || normalized.contains('veicul')) {
      return ('car', 'cyan');
    }
    if (normalized.contains('trabalh')) return ('work', 'blue');
    if (normalized.contains('pessoal')) return ('personal', 'slate');
    return ('tag', 'slate');
  }
  if (kind == 'income' || normalized.contains('renda')) {
    return ('income', 'green');
  }
  if (normalized.contains('mercad') || normalized.contains('aliment')) {
    return ('cart', 'amber');
  }
  if (normalized.contains('saud')) return ('health', 'red');
  if (normalized.contains('educ') || normalized.contains('escola')) {
    return ('education', 'blue');
  }
  if (normalized.contains('transport') || normalized.contains('uber')) {
    return ('transport', 'cyan');
  }
  if (normalized.contains('casa') || normalized.contains('moradia')) {
    return ('home', 'green');
  }
  if (normalized.contains('lazer')) return ('leisure', 'purple');
  return ('tag', 'slate');
}

String _foldVisualText(String value) {
  return value.trim().toLowerCase().replaceAllMapped(
    RegExp('[áàâãäéèêëíìîïóòôõöúùûüç]'),
    (match) => switch (match[0]) {
      'á' || 'à' || 'â' || 'ã' || 'ä' => 'a',
      'é' || 'è' || 'ê' || 'ë' => 'e',
      'í' || 'ì' || 'î' || 'ï' => 'i',
      'ó' || 'ò' || 'ô' || 'õ' || 'ö' => 'o',
      'ú' || 'ù' || 'û' || 'ü' => 'u',
      'ç' => 'c',
      _ => match[0]!,
    },
  );
}

class ClassificationBadge extends StatelessWidget {
  const ClassificationBadge({
    required this.iconKey,
    required this.colorKey,
    this.label,
    this.compact = false,
    super.key,
  });

  final String iconKey;
  final String colorKey;
  final String? label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = classificationColor(colorKey);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: label == null
            ? 0
            : compact
            ? 7
            : 9,
        vertical: label == null
            ? 0
            : compact
            ? 5
            : 7,
      ),
      width: label == null ? (compact ? 28 : 36) : null,
      height: label == null ? (compact ? 28 : 36) : null,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(compact ? 9 : 11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            classificationIcon(iconKey),
            size: compact ? 15 : 18,
            color: color,
          ),
          if (label != null) ...[
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label!,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
