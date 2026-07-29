import 'package:flutter/material.dart';

import '../application/dashboard_summary.dart';
import '../data/local/app_database.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReviewTransactionDetails>>(
      stream: database.watchAllTransactionDetails(),
      builder: (context, transactionSnapshot) {
        return FutureBuilder<FamilyStructureSnapshot>(
          future: database.getFamilyStructureSnapshot(),
          builder: (context, structureSnapshot) {
            final details =
                transactionSnapshot.data ?? const <ReviewTransactionDetails>[];
            final structure = structureSnapshot.data;
            final summary = buildOperationalDashboardSummary(
              details: details,
              recurringSchedules: structure?.recurringSchedules ?? const [],
              installmentPlans: structure?.installmentPlans ?? const [],
            );
            final recent = details.take(5).toList(growable: false);

            return Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_monthTitle(DateTime.now())),
                    const Text(
                      'Resumo familiar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    tooltip: 'Criar lancamento local',
                    onPressed: database.createManualDraft,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                children: [
                  if (transactionSnapshot.connectionState ==
                          ConnectionState.waiting &&
                      details.isEmpty)
                    const LinearProgressIndicator(),
                  SummaryCard(summary: summary),
                  const SizedBox(height: 12),
                  OperationalCards(summary: summary),
                  const SizedBox(height: 12),
                  BreakdownSection(
                    title: 'Por pessoa',
                    icon: Icons.people_alt_outlined,
                    items: summary.byPerson,
                  ),
                  const SizedBox(height: 12),
                  BreakdownSection(
                    title: 'Categorias',
                    icon: Icons.category_outlined,
                    items: summary.byCategory,
                  ),
                  const SizedBox(height: 12),
                  BreakdownSection(
                    title: 'Centros de custo',
                    icon: Icons.account_tree_outlined,
                    items: summary.byCostCenter,
                  ),
                  const SizedBox(height: 12),
                  BreakdownSection(
                    title: 'Origens',
                    icon: Icons.hub_outlined,
                    items: summary.bySource,
                  ),
                  const SizedBox(height: 12),
                  UpcomingCommitmentsSection(structure: structure),
                  const SizedBox(height: 12),
                  _SectionHeader(
                    title: 'Ultimas movimentacoes',
                    icon: Icons.receipt_long_outlined,
                  ),
                  const SizedBox(height: 8),
                  if (recent.isEmpty)
                    const EmptyCompactState(
                      icon: Icons.receipt_long_outlined,
                      text: 'Nenhuma movimentacao local ainda.',
                    )
                  else
                    for (final item in recent)
                      TransactionTile(
                        details: item,
                        onConfirm: item.transaction.reviewStatus == 'pending'
                            ? () => database.confirmTransaction(
                                item.transaction.id,
                              )
                            : null,
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

class SummaryCard extends StatelessWidget {
  const SummaryCard({required this.summary, super.key});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo do mes',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 6),
            Text(
              formatBrl(summary.balanceCents),
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: StatPill(
                    label: 'Entradas',
                    value: formatBrl(summary.incomeCents),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatPill(
                    label: 'Saidas',
                    value: formatBrl(summary.expenseCents.abs()),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OperationalCards extends StatelessWidget {
  const OperationalCards({required this.summary, super.key});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.55,
      children: [
        CompactMetric(
          icon: Icons.inbox_outlined,
          label: 'Pendentes',
          value: summary.pendingCount.toString(),
        ),
        CompactMetric(
          icon: Icons.compare_arrows_outlined,
          label: 'Transfer.',
          value: summary.transferCount.toString(),
        ),
        CompactMetric(
          icon: Icons.event_repeat_outlined,
          label: 'Compromissos',
          value: formatBrl(summary.futureCommitmentCents),
        ),
        CompactMetric(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Projetado',
          value: formatBrl(
            summary.balanceCents - summary.futureCommitmentCents,
          ),
        ),
      ],
    );
  }
}

class CompactMetric extends StatelessWidget {
  const CompactMetric({
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
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}

class BreakdownSection extends StatelessWidget {
  const BreakdownSection({
    required this.title,
    required this.icon,
    required this.items,
    super.key,
  });

  final String title;
  final IconData icon;
  final List<SummaryBreakdownItem> items;

  @override
  Widget build(BuildContext context) {
    final visible = items.take(4).toList(growable: false);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: title, icon: icon),
            const SizedBox(height: 8),
            if (visible.isEmpty)
              const EmptyCompactState(
                icon: Icons.remove_circle_outline,
                text: 'Sem dados neste mes.',
              )
            else
              for (final item in visible) BreakdownRow(item: item),
          ],
        ),
      ),
    );
  }
}

class BreakdownRow extends StatelessWidget {
  const BreakdownRow({required this.item, super.key});

  final SummaryBreakdownItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.amountCents >= 0 ? Colors.green : Colors.red;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          Text('${item.count}x', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 10),
          Text(
            formatBrl(item.amountCents),
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class UpcomingCommitmentsSection extends StatelessWidget {
  const UpcomingCommitmentsSection({required this.structure, super.key});

  final FamilyStructureSnapshot? structure;

  @override
  Widget build(BuildContext context) {
    final schedules = structure?.recurringSchedules ?? const [];
    final plans = structure?.installmentPlans ?? const [];
    final items = <_CommitmentItem>[
      for (final schedule in schedules.where((item) => item.active))
        _CommitmentItem(
          label: schedule.label,
          subtitle: 'dia ${schedule.dayOfMonth} · ${_kindLabel(schedule.kind)}',
          amountCents: schedule.amountCents,
        ),
      for (final plan in plans.where((item) => item.active))
        _CommitmentItem(
          label: plan.label,
          subtitle: '${plan.currentInstallment}/${plan.totalInstallments}',
          amountCents: -plan.installmentAmountCents,
        ),
    ]..sort((left, right) => left.label.compareTo(right.label));

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
              title: 'Proximos compromissos',
              icon: Icons.calendar_month_outlined,
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const EmptyCompactState(
                icon: Icons.event_available_outlined,
                text: 'Sem compromissos cadastrados.',
              )
            else
              for (final item in items.take(5))
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(item.subtitle),
                  trailing: Text(
                    formatBrl(item.amountCents),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.details,
    required this.onConfirm,
    super.key,
  });

  final ReviewTransactionDetails details;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final transaction = details.transaction;
    final isIncome = transaction.amountCents > 0;
    final isTransfer = transaction.kind == 'transfer';
    return Card(
      elevation: 0,
      child: ListTile(
        dense: true,
        title: Text(
          transaction.descriptionRaw,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${_kindLabel(transaction.kind)} · ${details.providerLabel} · ${transaction.reviewStatus}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? Colors.green.shade50
              : isTransfer
              ? Colors.blue.shade50
              : Colors.red.shade50,
          child: Icon(
            isIncome
                ? Icons.trending_up
                : isTransfer
                ? Icons.compare_arrows_outlined
                : Icons.trending_down,
            color: isIncome
                ? Colors.green
                : isTransfer
                ? Colors.blue
                : Colors.red,
            size: 20,
          ),
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            Text(
              formatBrl(transaction.amountCents),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isIncome ? Colors.green : null,
              ),
            ),
            if (onConfirm != null)
              IconButton(
                tooltip: 'Confirmar',
                onPressed: onConfirm,
                icon: const Icon(Icons.check_circle_outline),
              ),
          ],
        ),
      ),
    );
  }
}

class EmptyCompactState extends StatelessWidget {
  const EmptyCompactState({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class StatPill extends StatelessWidget {
  const StatPill({
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommitmentItem {
  const _CommitmentItem({
    required this.label,
    required this.subtitle,
    required this.amountCents,
  });

  final String label;
  final String subtitle;
  final int amountCents;
}

String _monthTitle(DateTime date) {
  const months = [
    'Janeiro',
    'Fevereiro',
    'Marco',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];
  return months[date.month - 1];
}

String _kindLabel(String kind) {
  return switch (kind) {
    'income' => 'Receita',
    'transfer' => 'Transferencia',
    'refund' => 'Estorno',
    'adjustment' => 'Ajuste',
    _ => 'Despesa',
  };
}

String formatBrl(int cents) {
  final sign = cents < 0 ? '-' : '';
  final absolute = cents.abs();
  final reais = absolute ~/ 100;
  final centavos = (absolute % 100).toString().padLeft(2, '0');
  final reaisText = reais.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match.group(1)}.',
  );
  return '${sign}R\$ $reaisText,$centavos';
}
