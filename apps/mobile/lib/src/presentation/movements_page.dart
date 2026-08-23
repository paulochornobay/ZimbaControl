import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart' show EmptyCompactState, formatBrl;
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'edit_transaction_page.dart';
import 'import_page.dart';

class MovementsPage extends StatefulWidget {
  const MovementsPage({required this.database, super.key, this.referenceDate});

  final AppDatabase database;
  final DateTime? referenceDate;

  @override
  State<MovementsPage> createState() => _MovementsPageState();
}

class _MovementsPageState extends State<MovementsPage> {
  final searchController = TextEditingController();
  late final Future<RegistrySnapshot> registryFuture;
  var kindFilter = 'all';
  var statusFilter = 'all';
  late String periodFilter;
  Set<String> personIds = {};
  Set<String> accountIds = {};
  Set<String> categoryIds = {};
  Set<String> costCenterIds = {};
  Set<String> sourceKinds = {};

  @override
  void initState() {
    super.initState();
    periodFilter = movementMonthKey(widget.referenceDate ?? DateTime.now());
    registryFuture = widget.database.getRegistrySnapshot(includeInactive: true);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void clearFilters() {
    setState(() {
      kindFilter = 'all';
      statusFilter = 'all';
      periodFilter = movementMonthKey(widget.referenceDate ?? DateTime.now());
      personIds = {};
      accountIds = {};
      categoryIds = {};
      costCenterIds = {};
      sourceKinds = {};
    });
  }

  int get advancedFilterCount =>
      (periodFilter == movementMonthKey(widget.referenceDate ?? DateTime.now())
          ? 0
          : 1) +
      (statusFilter == 'all' ? 0 : 1) +
      personIds.length +
      accountIds.length +
      categoryIds.length +
      costCenterIds.length +
      sourceKinds.length;

  Future<void> openFilters(
    RegistrySnapshot registry,
    List<String> periods,
  ) async {
    final result = await showModalBottomSheet<MovementFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MovementFilterSheet(
        registry: registry,
        periods: periods,
        defaultPeriod: movementMonthKey(widget.referenceDate ?? DateTime.now()),
        initial: MovementFilterSelection(
          period: periodFilter,
          status: statusFilter,
          personIds: personIds,
          accountIds: accountIds,
          categoryIds: categoryIds,
          costCenterIds: costCenterIds,
          sourceKinds: sourceKinds,
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      periodFilter = result.period;
      statusFilter = result.status;
      personIds = result.personIds;
      accountIds = result.accountIds;
      categoryIds = result.categoryIds;
      costCenterIds = result.costCenterIds;
      sourceKinds = result.sourceKinds;
    });
  }

  Future<void> openDetail(String transactionId) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => EditTransactionPage(
          database: widget.database,
          transactionId: transactionId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RegistrySnapshot>(
      future: registryFuture,
      builder: (context, registrySnapshot) {
        return StreamBuilder<List<ReviewTransactionDetails>>(
          stream: widget.database.watchAllTransactionDetails(),
          builder: (context, snapshot) {
            final all = snapshot.data ?? const <ReviewTransactionDetails>[];
            final filtered = filterMovementDetails(
              items: all,
              query: searchController.text,
              kindFilter: kindFilter,
              statusFilter: statusFilter,
              periodFilter: periodFilter,
              personIds: personIds,
              accountIds: accountIds,
              categoryIds: categoryIds,
              costCenterIds: costCenterIds,
              sourceKinds: sourceKinds,
            );
            final periods = <String>{
              movementMonthKey(widget.referenceDate ?? DateTime.now()),
              for (final item in all) item.transaction.competenceMonth,
            }.toList()..sort((a, b) => b.compareTo(a));
            final registry = registrySnapshot.data;

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 72,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Movimentações',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 19,
                        letterSpacing: -.45,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${filtered.length} ${filtered.length == 1 ? 'lançamento' : 'lançamentos'} · ${movementPeriodLabel(periodFilter)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ZimbaColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (_) => ImportPage(database: widget.database),
                        ),
                      ),
                      icon: const Icon(Icons.file_upload_outlined, size: 18),
                      label: const Text('Importar'),
                    ),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: TextField(
                            controller: searchController,
                            onChanged: (_) => setState(() {}),
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: 'Buscar merchant ou descrição',
                              prefixIcon: const Icon(Icons.search, size: 20),
                              suffixIcon: searchController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: 'Limpar busca',
                                      onPressed: () {
                                        searchController.clear();
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.close, size: 18),
                                    ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Badge(
                        isLabelVisible: advancedFilterCount > 0,
                        label: Text('$advancedFilterCount'),
                        child: IconButton.outlined(
                          tooltip: 'Abrir filtros',
                          onPressed: registry == null
                              ? null
                              : () => openFilters(registry, periods),
                          icon: const Icon(Icons.tune, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final option in const [
                          ('all', 'Todos'),
                          ('expense', 'Despesas'),
                          ('income', 'Entradas'),
                          ('transfer', 'Transferências'),
                          ('adjustment', 'Ajustes'),
                        ]) ...[
                          MovementQuickFilter(
                            label: option.$2,
                            selected: kindFilter == option.$1,
                            onTap: () => setState(() => kindFilter = option.$1),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  if (advancedFilterCount > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$advancedFilterCount ${advancedFilterCount == 1 ? 'filtro ativo' : 'filtros ativos'}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: ZimbaColors.secondaryText),
                          ),
                        ),
                        TextButton(
                          onPressed: clearFilters,
                          child: const Text('Limpar'),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      all.isEmpty)
                    const LinearProgressIndicator()
                  else if (filtered.isEmpty)
                    const ZimbaCard(
                      child: EmptyCompactState(
                        icon: Icons.search_off_outlined,
                        text:
                            'Nenhum lançamento encontrado. Ajuste ou limpe os filtros.',
                      ),
                    )
                  else
                    ZimbaRows(
                      children: [
                        for (final item in filtered)
                          MovementTransactionRow(
                            details: item,
                            onTap: () => openDetail(item.transaction.id),
                          ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

List<ReviewTransactionDetails> filterMovementDetails({
  required List<ReviewTransactionDetails> items,
  required String query,
  required String kindFilter,
  String statusFilter = 'all',
  String sourceFilter = 'all',
  bool currentMonthOnly = false,
  String? periodFilter,
  Set<String> personIds = const {},
  Set<String> accountIds = const {},
  Set<String> categoryIds = const {},
  Set<String> costCenterIds = const {},
  Set<String> sourceKinds = const {},
  DateTime? now,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  final effectivePeriod =
      periodFilter ??
      (currentMonthOnly ? movementMonthKey(now ?? DateTime.now()) : 'all');
  final effectiveSources = {
    ...sourceKinds,
    if (sourceFilter != 'all') sourceFilter,
  };

  return items
      .where((item) {
        final tx = item.transaction;
        if (effectivePeriod != 'all' && tx.competenceMonth != effectivePeriod) {
          return false;
        }
        if (kindFilter != 'all') {
          final kindMatches = kindFilter == 'adjustment'
              ? tx.kind == 'adjustment' || tx.kind == 'refund'
              : tx.kind == kindFilter;
          if (!kindMatches) return false;
        }
        if (statusFilter != 'all' && tx.reviewStatus != statusFilter) {
          return false;
        }
        if (personIds.isNotEmpty &&
            !personIds.contains(tx.payerId) &&
            !item.beneficiaries.any(
              (person) => personIds.contains(person.id),
            )) {
          return false;
        }
        if (accountIds.isNotEmpty && !accountIds.contains(tx.accountId)) {
          return false;
        }
        if (categoryIds.isNotEmpty && !categoryIds.contains(tx.categoryId)) {
          return false;
        }
        if (costCenterIds.isNotEmpty &&
            !costCenterIds.contains(tx.costCenterId)) {
          return false;
        }
        if (effectiveSources.isNotEmpty &&
            !item.sources.any(
              (source) => effectiveSources.contains(source.sourceKind),
            )) {
          return false;
        }
        if (normalizedQuery.isEmpty) return true;
        final haystack = [
          item.displayTitle,
          tx.descriptionRaw,
          item.merchant?.displayName,
          item.category?.name,
          item.costCenter?.name,
          item.account?.name,
          item.providerLabel,
          ...item.beneficiaries.map((person) => person.displayName),
        ].whereType<String>().join(' ').toLowerCase();
        return haystack.contains(normalizedQuery);
      })
      .toList(growable: false);
}

class MovementQuickFilter extends StatelessWidget {
  const MovementQuickFilter({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? ZimbaColors.foreground : ZimbaColors.surface,
            border: Border.all(
              color: selected ? ZimbaColors.foreground : ZimbaColors.border,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected ? Colors.white : ZimbaColors.secondaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MovementTransactionRow extends StatelessWidget {
  const MovementTransactionRow({
    required this.details,
    required this.onTap,
    super.key,
  });

  final ReviewTransactionDetails details;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tx = details.transaction;
    final positive = tx.amountCents > 0;
    final transfer = tx.kind == 'transfer';
    final metadata = [
      if (details.category != null) details.category!.name,
      if (details.costCenter != null) details.costCenter!.name,
      if (details.category == null && transfer) 'Transferência',
    ].join(' · ');

    return Semantics(
      button: true,
      label:
          '${details.displayTitle}, ${formatBrl(tx.amountCents)}, ${movementStatusLabel(tx.reviewStatus)}',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      details.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ZimbaColors.foreground,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formatBrl(tx.amountCents),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: positive
                          ? ZimbaColors.success
                          : transfer
                          ? ZimbaColors.accent
                          : ZimbaColors.foreground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      metadata.isEmpty ? _kindLabel(tx.kind) : metadata,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ZimbaColors.secondaryText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    movementDateLabel(tx.occurredAt),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ZimbaColors.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (details.beneficiaries.isNotEmpty)
                    MovementInitials(people: details.beneficiaries),
                  ZimbaBadge(
                    label: movementStatusLabel(tx.reviewStatus),
                    tone: tx.reviewStatus == 'confirmed'
                        ? ZimbaTone.success
                        : tx.reviewStatus == 'pending'
                        ? ZimbaTone.warning
                        : ZimbaTone.neutral,
                  ),
                  ZimbaBadge(label: details.sourceLabel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovementInitials extends StatelessWidget {
  const MovementInitials({required this.people, super.key});

  final List<PersonRow> people;

  @override
  Widget build(BuildContext context) {
    final visible = people.take(4).toList(growable: false);
    return SizedBox(
      width: 20 + (visible.length - 1) * 14,
      height: 20,
      child: Stack(
        children: [
          for (var index = 0; index < visible.length; index++)
            Positioned(
              left: index * 14,
              child: Tooltip(
                message: visible[index].displayName,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: _avatarColors[index % _avatarColors.length],
                  child: Text(
                    movementInitials(visible[index].displayName),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: ZimbaColors.foreground,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static const _avatarColors = [
    Color(0xFFE0F2FE),
    Color(0xFFEDE9FE),
    Color(0xFFFFEDD5),
    Color(0xFFDCFCE7),
  ];
}

class MovementFilterSelection {
  const MovementFilterSelection({
    required this.period,
    required this.status,
    required this.personIds,
    required this.accountIds,
    required this.categoryIds,
    required this.costCenterIds,
    required this.sourceKinds,
  });

  final String period;
  final String status;
  final Set<String> personIds;
  final Set<String> accountIds;
  final Set<String> categoryIds;
  final Set<String> costCenterIds;
  final Set<String> sourceKinds;
}

class MovementFilterSheet extends StatefulWidget {
  const MovementFilterSheet({
    required this.registry,
    required this.periods,
    required this.defaultPeriod,
    required this.initial,
    super.key,
  });

  final RegistrySnapshot registry;
  final List<String> periods;
  final String defaultPeriod;
  final MovementFilterSelection initial;

  @override
  State<MovementFilterSheet> createState() => _MovementFilterSheetState();
}

class _MovementFilterSheetState extends State<MovementFilterSheet> {
  late String period;
  late String status;
  late Set<String> personIds;
  late Set<String> accountIds;
  late Set<String> categoryIds;
  late Set<String> costCenterIds;
  late Set<String> sourceKinds;

  @override
  void initState() {
    super.initState();
    period = widget.initial.period;
    status = widget.initial.status;
    personIds = {...widget.initial.personIds};
    accountIds = {...widget.initial.accountIds};
    categoryIds = {...widget.initial.categoryIds};
    costCenterIds = {...widget.initial.costCenterIds};
    sourceKinds = {...widget.initial.sourceKinds};
  }

  void clear() {
    setState(() {
      period = widget.defaultPeriod;
      status = 'all';
      personIds = {};
      accountIds = {};
      categoryIds = {};
      costCenterIds = {};
      sourceKinds = {};
    });
  }

  MovementFilterSelection get result => MovementFilterSelection(
    period: period,
    status: status,
    personIds: personIds,
    accountIds: accountIds,
    categoryIds: categoryIds,
    costCenterIds: costCenterIds,
    sourceKinds: sourceKinds,
  );

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: .9,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: ZimbaColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 10, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Filtros',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Fechar filtros',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                children: [
                  const MovementFilterLabel('Período'),
                  DropdownButtonFormField<String>(
                    initialValue: period,
                    isExpanded: true,
                    items: [
                      for (final value in widget.periods)
                        DropdownMenuItem(
                          value: value,
                          child: Text(movementPeriodLabel(value)),
                        ),
                      const DropdownMenuItem(
                        value: 'all',
                        child: Text('Todos os períodos'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => period = value ?? period),
                  ),
                  MovementFilterGroup(
                    label: 'Status',
                    options: const [
                      ('pending', 'Em revisão'),
                      ('confirmed', 'Revisado'),
                      ('ignored', 'Ignorado'),
                      ('conflict', 'Conflito'),
                    ],
                    selected: status == 'all' ? const {} : {status},
                    onToggle: (value) => setState(
                      () => status = status == value ? 'all' : value,
                    ),
                  ),
                  MovementFilterGroup(
                    label: 'Pessoa',
                    options: [
                      for (final person in widget.registry.people)
                        (person.id, person.displayName),
                    ],
                    selected: personIds,
                    onToggle: (value) =>
                        setState(() => _toggle(personIds, value)),
                  ),
                  MovementFilterGroup(
                    label: 'Conta / cartão',
                    options: [
                      for (final item in widget.registry.accounts)
                        (item.account.id, _accountFilterLabel(item)),
                    ],
                    selected: accountIds,
                    onToggle: (value) =>
                        setState(() => _toggle(accountIds, value)),
                  ),
                  MovementFilterGroup(
                    label: 'Categoria',
                    options: [
                      for (final item in widget.registry.categories)
                        (item.id, item.name),
                    ],
                    selected: categoryIds,
                    onToggle: (value) =>
                        setState(() => _toggle(categoryIds, value)),
                  ),
                  MovementFilterGroup(
                    label: 'Centro de custo',
                    options: [
                      for (final item in widget.registry.costCenters)
                        (item.id, item.name),
                    ],
                    selected: costCenterIds,
                    onToggle: (value) =>
                        setState(() => _toggle(costCenterIds, value)),
                  ),
                  MovementFilterGroup(
                    label: 'Origem',
                    options: const [
                      ('notification', 'Notificação'),
                      ('csv', 'CSV'),
                      ('ofx', 'OFX'),
                      ('manual', 'Manual'),
                    ],
                    selected: sourceKinds,
                    onToggle: (value) =>
                        setState(() => _toggle(sourceKinds, value)),
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: clear,
                        child: const Text('Limpar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(result),
                        child: const Text('Aplicar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggle(Set<String> values, String value) {
    values.contains(value) ? values.remove(value) : values.add(value);
  }
}

class MovementFilterLabel extends StatelessWidget {
  const MovementFilterLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: ZimbaColors.secondaryText,
        letterSpacing: .6,
      ),
    ),
  );
}

class MovementFilterGroup extends StatelessWidget {
  const MovementFilterGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onToggle,
    super.key,
  });

  final String label;
  final List<(String, String)> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovementFilterLabel(label),
          if (options.isEmpty)
            Text(
              'Nenhuma opção cadastrada',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
            )
          else
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final option in options)
                  FilterChip(
                    label: Text(option.$2),
                    selected: selected.contains(option.$1),
                    onSelected: (_) => onToggle(option.$1),
                    showCheckmark: false,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

String movementMonthKey(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}';

String movementPeriodLabel(String value) {
  if (value == 'all') return 'Todos os períodos';
  final parts = value.split('-');
  if (parts.length != 2) return value;
  return '${parts[1]}/${parts[0]}';
}

String movementDateLabel(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}';

String movementStatusLabel(String value) => switch (value) {
  'pending' => 'Em revisão',
  'confirmed' => 'Revisado',
  'ignored' => 'Ignorado',
  'conflict' => 'Conflito',
  _ => value,
};

String movementInitials(String value) {
  final words = value.trim().split(RegExp(r'\s+'));
  if (words.isEmpty || words.first.isEmpty) return '?';
  return words.take(2).map((word) => word[0].toUpperCase()).join();
}

String _kindLabel(String kind) => switch (kind) {
  'income' => 'Receita',
  'transfer' => 'Transferência',
  'refund' => 'Estorno',
  'adjustment' => 'Ajuste',
  _ => 'Despesa',
};

String _accountFilterLabel(AccountWithOwner item) {
  final type = switch (item.account.type) {
    'credit_card' => 'Cartão',
    'checking' => 'Conta corrente',
    'savings' => 'Poupança',
    _ => 'Conta',
  };
  final suffix = item.account.last4 == null ? '' : ' · •${item.account.last4}';
  return '${item.account.name} · $type$suffix';
}
