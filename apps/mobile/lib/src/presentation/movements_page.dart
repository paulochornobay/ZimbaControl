import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart';
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
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Movimentacoes'),
                Text(
                  'Busca, filtros e importacao',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
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
        children: [
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
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Somente mes atual'),
            value: currentMonthOnly,
            onChanged: (value) => onChanged(monthOnly: value),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Todos'),
                selected: kindFilter == 'all',
                onSelected: (_) => onChanged(kind: 'all'),
              ),
              FilterChip(
                label: const Text('Receitas'),
                selected: kindFilter == 'income',
                onSelected: (_) => onChanged(kind: 'income'),
              ),
              FilterChip(
                label: const Text('Despesas'),
                selected: kindFilter == 'expense',
                onSelected: (_) => onChanged(kind: 'expense'),
              ),
              FilterChip(
                label: const Text('Transfer.'),
                selected: kindFilter == 'transfer',
                onSelected: (_) => onChanged(kind: 'transfer'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: statusFilter,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
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
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: sourceFilter,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Origem',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Todas')),
                    DropdownMenuItem(
                      value: 'notification',
                      child: Text('Notif.'),
                    ),
                    DropdownMenuItem(value: 'csv', child: Text('CSV')),
                    DropdownMenuItem(value: 'ofx', child: Text('OFX')),
                    DropdownMenuItem(value: 'manual', child: Text('Manual')),
                  ],
                  onChanged: (value) => onChanged(source: value),
                ),
              ),
            ],
          ),
        ],
      ),
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
      child: Row(
        children: [
          Expanded(
            child: MovementMetric(
              icon: Icons.format_list_bulleted,
              label: 'Itens',
              value: count.toString(),
            ),
          ),
          Expanded(
            child: MovementMetric(
              icon: Icons.trending_up,
              label: 'Entradas',
              value: formatBrl(incomeCents),
            ),
          ),
          Expanded(
            child: MovementMetric(
              icon: Icons.trending_down,
              label: 'Saidas',
              value: formatBrl(expenseCents.abs()),
            ),
          ),
        ],
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
