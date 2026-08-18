import 'package:flutter/material.dart';

import '../application/dashboard_summary.dart';
import '../data/local/app_database.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

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
                toolbarHeight: 82,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumo',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(letterSpacing: -.5),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _monthTitle(DateTime.now()),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ZimbaColors.secondaryText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                children: [
                  if (transactionSnapshot.connectionState ==
                          ConnectionState.waiting &&
                      details.isEmpty)
                    const LinearProgressIndicator(),
                  if (details.isEmpty) ...[
                    const _EmptyDashboardState(),
                  ] else ...[
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
    return ZimbaCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SALDO DO MÊS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ZimbaColors.secondaryText,
              letterSpacing: .65,
            ),
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
      childAspectRatio: 2.05,
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

class _EmptyDashboardState extends StatelessWidget {
  const _EmptyDashboardState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.receipt_long_outlined, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              'Seu resumo começa aqui',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 7),
            Text(
              'Adicione um lançamento na aba Novo ou importe um extrato em Ajustes.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
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
    final now = DateTime.now();
    final items = <_CommitmentItem>[
      for (final schedule in schedules.where((item) => item.active))
        _CommitmentItem(
          label: schedule.label,
          subtitle: 'dia ${schedule.dayOfMonth} · ${_kindLabel(schedule.kind)}',
          amountCents: schedule.amountCents,
          dueDate: _commitmentDate(now, schedule.dayOfMonth),
        ),
      for (final plan in plans.where((item) => item.active))
        _CommitmentItem(
          label: plan.label,
          subtitle:
              '${plan.currentInstallment}/${plan.totalInstallments} · vence dia ${plan.dueDay ?? '-'}',
          amountCents: -plan.installmentAmountCents,
          dueDate: _commitmentDate(now, plan.dueDay ?? 1),
        ),
    ]..sort((left, right) => left.dueDate.compareTo(right.dueDate));

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
          '${_kindLabel(transaction.kind)} · ${details.providerLabel} · ${_reviewStatusLabel(transaction.reviewStatus)}',
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

String _reviewStatusLabel(String status) {
  return switch (status) {
    'pending' => 'Em revisão',
    'confirmed' => 'Confirmado',
    'ignored' => 'Ignorado',
    'duplicate' => 'Duplicado',
    _ => status,
  };
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
    required this.dueDate,
  });

  final String label;
  final String subtitle;
  final int amountCents;
  final DateTime dueDate;
}

DateTime _commitmentDate(DateTime now, int day) {
  final clampedDay = _clampDay(now.year, now.month, day);
  final date = DateTime(now.year, now.month, clampedDay);
  if (date.isBefore(DateTime(now.year, now.month, now.day))) {
    final nextMonth = DateTime(now.year, now.month + 1);
    return DateTime(
      nextMonth.year,
      nextMonth.month,
      _clampDay(nextMonth.year, nextMonth.month, day),
    );
  }
  return date;
}

int _clampDay(int year, int month, int day) {
  final lastDay = DateTime(year, month + 1, 0).day;
  if (day < 1) {
    return 1;
  }
  return day > lastDay ? lastDay : day;
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
