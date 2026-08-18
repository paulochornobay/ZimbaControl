import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'import_page.dart';

class MovementsPage extends StatefulWidget {
  const MovementsPage({required this.database, super.key});

  final AppDatabase database;

  @override
  State<MovementsPage> createState() => _MovementsPageState();
}

class _MovementsPageState extends State<MovementsPage> {
  final searchController = TextEditingController();
  var kindFilter = 'all';
  var statusFilter = 'all';
  var sourceFilter = 'all';
  var currentMonthOnly = true;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReviewTransactionDetails>>(
      stream: widget.database.watchAllTransactionDetails(),
      builder: (context, snapshot) {
        final all = snapshot.data ?? const <ReviewTransactionDetails>[];
        final filtered = _filter(all);
        final income = filtered
            .where((item) => item.transaction.kind == 'income')
            .fold<int>(0, (sum, item) => sum + item.transaction.amountCents);
        final expense = filtered
            .where((item) => item.transaction.kind == 'expense')
            .fold<int>(0, (sum, item) => sum + item.transaction.amountCents);

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 82,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Movimentações',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(letterSpacing: -.5),
                ),
                const SizedBox(height: 3),
                Text(
                  '${filtered.length} nesta visão',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ZimbaColors.secondaryText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Importar CSV/OFX',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ImportPage(database: widget.database),
                  ),
                ),
                icon: const Icon(Icons.upload_file_outlined),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            children: [
              if (snapshot.connectionState == ConnectionState.waiting &&
                  all.isEmpty)
                const LinearProgressIndicator(),
              MovementFilterPanel(
                searchController: searchController,
                kindFilter: kindFilter,
                statusFilter: statusFilter,
                sourceFilter: sourceFilter,
                currentMonthOnly: currentMonthOnly,
                onChanged:
                    ({
                      String? kind,
                      String? status,
                      String? source,
                      bool? monthOnly,
                    }) {
                      setState(() {
                        kindFilter = kind ?? kindFilter;
                        statusFilter = status ?? statusFilter;
                        sourceFilter = source ?? sourceFilter;
                        currentMonthOnly = monthOnly ?? currentMonthOnly;
                      });
                    },
                onSearchChanged: () => setState(() {}),
              ),
              const SizedBox(height: 12),
              MovementTotalsCard(
                count: filtered.length,
                incomeCents: income,
                expenseCents: expense,
              ),
              const SizedBox(height: 12),
              if (filtered.isEmpty)
                const EmptyCompactState(
                  icon: Icons.search_off_outlined,
                  text: 'Nenhuma movimentacao encontrada para os filtros.',
                )
              else
                for (final item in filtered)
                  TransactionTile(details: item, onConfirm: null),
            ],
          ),
        );
      },
    );
  }

  List<ReviewTransactionDetails> _filter(List<ReviewTransactionDetails> items) {
    return filterMovementDetails(
      items: items,
      query: searchController.text,
      kindFilter: kindFilter,
      statusFilter: statusFilter,
      sourceFilter: sourceFilter,
      currentMonthOnly: currentMonthOnly,
    );
  }
}

List<ReviewTransactionDetails> filterMovementDetails({
  required List<ReviewTransactionDetails> items,
  required String query,
  required String kindFilter,
  required String statusFilter,
  required String sourceFilter,
  required bool currentMonthOnly,
  DateTime? now,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  final month = now ?? DateTime.now();
  final monthKey =
      '${month.year.toString().padLeft(4, '0')}-'
      '${month.month.toString().padLeft(2, '0')}';

  return items
      .where((item) {
        final tx = item.transaction;
        if (currentMonthOnly && tx.competenceMonth != monthKey) {
          return false;
        }
        if (kindFilter != 'all' && tx.kind != kindFilter) {
          return false;
        }
        if (statusFilter != 'all' && tx.reviewStatus != statusFilter) {
          return false;
        }
        if (sourceFilter != 'all' &&
            !item.sources.any((source) => source.sourceKind == sourceFilter)) {
          return false;
        }
        if (normalizedQuery.isEmpty) {
          return true;
        }
        final haystack = [
          tx.descriptionRaw,
          item.merchant?.displayName,
          item.category?.name,
          item.costCenter?.name,
          item.providerLabel,
          ...item.beneficiaries.map((person) => person.displayName),
        ].whereType<String>().join(' ').toLowerCase();
        return haystack.contains(normalizedQuery);
      })
      .toList(growable: false);
}

class MovementFilterPanel extends StatelessWidget {
  const MovementFilterPanel({
    required this.searchController,
    required this.kindFilter,
    required this.statusFilter,
    required this.sourceFilter,
    required this.currentMonthOnly,
    required this.onChanged,
    required this.onSearchChanged,
    super.key,
  });

  final TextEditingController searchController;
  final String kindFilter;
  final String statusFilter;
  final String sourceFilter;
  final bool currentMonthOnly;
  final void Function({
    String? kind,
    String? status,
    String? source,
    bool? monthOnly,
  })
  onChanged;
  final VoidCallback onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FILTROS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ZimbaColors.secondaryText,
              letterSpacing: .7,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: searchController,
            onChanged: (_) => onSearchChanged(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar descricao, pessoa, categoria...',
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          _MovementPeriodToggle(
            currentMonthOnly: currentMonthOnly,
            onChanged: (value) => onChanged(monthOnly: value),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MovementPill(
                label: 'Todos',
                selected: kindFilter == 'all',
                onTap: () => onChanged(kind: 'all'),
              ),
              _MovementPill(
                label: 'Receitas',
                selected: kindFilter == 'income',
                onTap: () => onChanged(kind: 'income'),
              ),
              _MovementPill(
                label: 'Despesas',
                selected: kindFilter == 'expense',
                onTap: () => onChanged(kind: 'expense'),
              ),
              _MovementPill(
                label: 'Transferências',
                selected: kindFilter == 'transfer',
                onTap: () => onChanged(kind: 'transfer'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final fields = [
                _MovementSelect(
                  label: 'Status',
                  value: statusFilter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Todos')),
                    DropdownMenuItem(value: 'pending', child: Text('Pendente')),
                    DropdownMenuItem(
                      value: 'confirmed',
                      child: Text('Confirmado'),
                    ),
                    DropdownMenuItem(value: 'ignored', child: Text('Ignorado')),
                  ],
                  onChanged: (value) => onChanged(status: value),
                ),
                _MovementSelect(
                  label: 'Origem',
                  value: sourceFilter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Todas')),
                    DropdownMenuItem(
                      value: 'notification',
                      child: Text('Notificação'),
                    ),
                    DropdownMenuItem(value: 'csv', child: Text('CSV')),
                    DropdownMenuItem(value: 'ofx', child: Text('OFX')),
                    DropdownMenuItem(value: 'manual', child: Text('Manual')),
                  ],
                  onChanged: (value) => onChanged(source: value),
                ),
              ];
              if (constraints.maxWidth < 360) {
                return Column(
                  children: [
                    fields.first,
                    const SizedBox(height: 8),
                    fields.last,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: fields.first),
                  const SizedBox(width: 8),
                  Expanded(child: fields.last),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MovementPeriodToggle extends StatelessWidget {
  const _MovementPeriodToggle({
    required this.currentMonthOnly,
    required this.onChanged,
  });

  final bool currentMonthOnly;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(!currentMonthOnly),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Somente mês atual',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Switch(value: currentMonthOnly, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovementPill extends StatelessWidget {
  const _MovementPill({
    required this.label,
    required this.selected,
    required this.onTap,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? ZimbaColors.foreground : ZimbaColors.surface,
            border: Border.all(
              color: selected ? ZimbaColors.foreground : ZimbaColors.border,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected ? Colors.white : ZimbaColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}

class _MovementSelect extends StatelessWidget {
  const _MovementSelect({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(isDense: true, labelText: label),
      items: items,
      onChanged: onChanged,
    );
  }
}

class MovementTotalsCard extends StatelessWidget {
  const MovementTotalsCard({
    required this.count,
    required this.incomeCents,
    required this.expenseCents,
    super.key,
  });

  final int count;
  final int incomeCents;
  final int expenseCents;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final metrics = [
            MovementMetric(
              icon: Icons.format_list_bulleted,
              label: 'Itens',
              value: count.toString(),
            ),
            MovementMetric(
              icon: Icons.trending_up,
              label: 'Entradas',
              value: formatBrl(incomeCents),
            ),
            MovementMetric(
              icon: Icons.trending_down,
              label: 'Saídas',
              value: formatBrl(expenseCents.abs()),
            ),
          ];
          if (constraints.maxWidth < 390) {
            return Wrap(
              spacing: 8,
              runSpacing: 10,
              children: [
                for (final metric in metrics)
                  SizedBox(
                    width: (constraints.maxWidth - 8) / 2,
                    child: metric,
                  ),
              ],
            );
          }
          return Row(
            children: [for (final metric in metrics) Expanded(child: metric)],
          );
        },
      ),
    );
  }
}

class MovementMetric extends StatelessWidget {
  const MovementMetric({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
