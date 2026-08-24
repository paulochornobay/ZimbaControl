import 'package:flutter/material.dart';

import '../application/dashboard_summary.dart';
import '../data/local/app_database.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({required this.database, this.referenceDate, super.key});

  final AppDatabase database;
  final DateTime? referenceDate;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int breakdownIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReviewTransactionDetails>>(
      stream: widget.database.watchAllTransactionDetails(),
      builder: (context, transactionSnapshot) {
        return FutureBuilder<FamilyStructureSnapshot>(
          future: widget.database.getFamilyStructureSnapshot(),
          builder: (context, structureSnapshot) {
            final details =
                transactionSnapshot.data ?? const <ReviewTransactionDetails>[];
            final structure = structureSnapshot.data;
            final summary = buildOperationalDashboardSummary(
              details: details,
              recurringSchedules: structure?.recurringSchedules ?? const [],
              installmentPlans: structure?.installmentPlans ?? const [],
              now: widget.referenceDate,
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
                      _monthTitle(widget.referenceDate ?? DateTime.now()),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ZimbaColors.secondaryText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
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
                    if (summary.pendingCount > 0) ...[
                      PendingReviewCard(summary: summary),
                      const SizedBox(height: 18),
                    ] else
                      const SizedBox(height: 6),
                    MonthlyReadingSection(
                      summary: summary,
                      selectedIndex: breakdownIndex,
                      onSelected: (value) =>
                          setState(() => breakdownIndex = value),
                    ),
                    const SizedBox(height: 12),
                    SourceSummarySection(items: summary.bySource),
                    const SizedBox(height: 12),
                    UpcomingCommitmentsSection(
                      structure: structure,
                      referenceDate: widget.referenceDate,
                    ),
                    const SizedBox(height: 12),
                    _SectionHeader(
                      title: 'Últimas movimentações',
                      icon: Icons.receipt_long_outlined,
                    ),
                    const SizedBox(height: 8),
                    if (recent.isEmpty)
                      const EmptyCompactState(
                        icon: Icons.receipt_long_outlined,
                        text: 'Nenhuma movimentação local ainda.',
                      )
                    else
                      for (final item in recent)
                        TransactionTile(
                          details: item,
                          onConfirm: item.transaction.reviewStatus == 'pending'
                              ? () => widget.database.confirmTransaction(
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
                  label: 'Saídas',
                  value: formatBrl(summary.expenseCents.abs()),
                  color: Colors.red,
                ),
              ),
            ],
          ),
          if (summary.transferCents > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: ZimbaColors.accentSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.compare_arrows_outlined,
                    size: 18,
                    color: ZimbaColors.accent,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Transferências internas',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: ZimbaColors.accent,
                      ),
                    ),
                  ),
                  Text(
                    formatBrl(summary.transferCents),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: ZimbaColors.accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PendingReviewCard extends StatelessWidget {
  const PendingReviewCard({required this.summary, super.key});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.inbox_outlined, color: ZimbaColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${summary.pendingCount} lançamentos aguardando revisão',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  '${formatBrl(summary.pendingCents)} ainda não consolidados',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ZimbaColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const ZimbaBadge(label: 'Pendente'),
        ],
      ),
    );
  }
}

class MonthlyReadingSection extends StatelessWidget {
  const MonthlyReadingSection({
    required this.summary,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final DashboardSummary summary;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = switch (selectedIndex) {
      1 => summary.byCategory,
      2 => summary.byCostCenter,
      _ => summary.byPerson,
    };
    final visible = items.take(5).toList(growable: false);
    final maximum = visible.fold<int>(
      1,
      (current, item) =>
          item.amountCents.abs() > current ? item.amountCents.abs() : current,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LEITURA DO MÊS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: ZimbaColors.secondaryText,
            letterSpacing: .75,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<int>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: 0, label: Text('Pessoa')),
            ButtonSegment(value: 1, label: Text('Categoria')),
            ButtonSegment(value: 2, label: Text('Centro')),
          ],
          selected: {selectedIndex},
          onSelectionChanged: (value) => onSelected(value.first),
        ),
        const SizedBox(height: 8),
        ZimbaCard(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          child: visible.isEmpty
              ? const EmptyCompactState(
                  icon: Icons.remove_circle_outline,
                  text: 'Sem dados neste mês.',
                )
              : Column(
                  children: [
                    for (final item in visible) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatBrl(item.amountCents),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      LinearProgressIndicator(
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(3),
                        value: item.amountCents.abs() / maximum,
                        backgroundColor: ZimbaColors.accentSoft,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class SourceSummarySection extends StatelessWidget {
  const SourceSummarySection({required this.items, super.key});

  final List<SummaryBreakdownItem> items;

  @override
  Widget build(BuildContext context) {
    final visible = items.take(4).toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FONTES DOS DADOS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: ZimbaColors.secondaryText,
            letterSpacing: .75,
          ),
        ),
        const SizedBox(height: 8),
        ZimbaCard(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: visible.isEmpty
              ? const EmptyCompactState(
                  icon: Icons.hub_outlined,
                  text: 'Sem fontes neste mês.',
                )
              : Row(
                  children: [
                    for (final item in visible)
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              item.count.toString(),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: ZimbaColors.secondaryText),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ],
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
                text: 'Sem dados neste mês.',
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
          SizedBox(
            width: 30,
            child: Text(
              '${item.count}x',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                formatBrl(item.amountCents),
                style: TextStyle(color: color, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingCommitmentsSection extends StatelessWidget {
  const UpcomingCommitmentsSection({
    required this.structure,
    this.referenceDate,
    super.key,
  });

  final FamilyStructureSnapshot? structure;
  final DateTime? referenceDate;

  @override
  Widget build(BuildContext context) {
    final schedules = structure?.recurringSchedules ?? const [];
    final plans = structure?.installmentPlans ?? const [];
    final now = referenceDate ?? DateTime.now();
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
              title: 'Próximos compromissos',
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
          details.displayTitle,
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
