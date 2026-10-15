import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../application/dashboard_summary.dart';
import '../data/local/app_database.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'import_page.dart';
import 'registries_page.dart';
import 'reports_page.dart';

/// Dashboard presentation follows the local Lovable `/summary` hierarchy.
/// Domain values are still calculated exclusively by Drift.
class DashboardPage extends StatefulWidget {
  const DashboardPage({
    required this.database,
    this.referenceDate,
    this.onNavigate,
    this.onOpenRegistries,
    this.onOpenImport,
    this.detailsStream,
    this.structureFuture,
    super.key,
  });

  final AppDatabase database;
  final DateTime? referenceDate;
  final ValueChanged<int>? onNavigate;
  final ValueChanged<String>? onOpenRegistries;
  final VoidCallback? onOpenImport;
  @visibleForTesting
  final Stream<List<ReviewTransactionDetails>>? detailsStream;
  @visibleForTesting
  final Future<FamilyStructureSnapshot>? structureFuture;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int breakdownIndex = 0;
  late DateTime _referenceDate;
  late final Future<FamilyStructureSnapshot> _structureFuture;
  late final Stream<List<ReviewTransactionDetails>> _detailsStream;

  @override
  void initState() {
    super.initState();
    _referenceDate = widget.referenceDate ?? DateTime.now();
    _structureFuture =
        widget.structureFuture ?? widget.database.getFamilyStructureSnapshot();
    _detailsStream =
        widget.detailsStream ?? widget.database.watchAllTransactionDetails();
  }

  @override
  Widget build(BuildContext context) {
    final referenceDate = _referenceDate;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _DashboardHeader(month: _monthTitle(referenceDate)),
            Expanded(
              child: StreamBuilder<List<ReviewTransactionDetails>>(
                stream: _detailsStream,
                builder: (context, transactionSnapshot) =>
                    FutureBuilder<FamilyStructureSnapshot>(
                      future: _structureFuture,
                      builder: (context, structureSnapshot) {
                        final details =
                            transactionSnapshot.data ??
                            const <ReviewTransactionDetails>[];
                        final structure = structureSnapshot.data;
                        final summary = buildOperationalDashboardSummary(
                          details: details,
                          recurringSchedules:
                              structure?.recurringSchedules ?? const [],
                          installmentPlans:
                              structure?.installmentPlans ?? const [],
                          now: referenceDate,
                        );
                        return ListView(
                          padding: const EdgeInsets.only(bottom: 24),
                          children: [
                            if (transactionSnapshot.connectionState ==
                                    ConnectionState.waiting &&
                                details.isEmpty)
                              const LinearProgressIndicator(minHeight: 1),
                            if (structure != null &&
                                structure.accounts.isEmpty &&
                                structure.creditCards.isEmpty)
                              ZimbaSection(
                                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: _InitialHomeState(
                                  onOpenAccount: () => _openRegistry('account'),
                                  onOpenCard: () => _openRegistry('card'),
                                  onOpenImport: _openImport,
                                ),
                              )
                            else if (details.isEmpty)
                              const ZimbaSection(
                                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: _EmptyDashboardState(),
                              )
                            else ...[
                              ZimbaSection(
                                padding: const EdgeInsets.fromLTRB(
                                  17,
                                  16,
                                  16,
                                  0,
                                ),
                                child: Column(
                                  children: [
                                    _SummaryMonthSelector(
                                      referenceDate: referenceDate,
                                      onPrevious: () => setState(
                                        () => _referenceDate = DateTime(
                                          referenceDate.year,
                                          referenceDate.month - 1,
                                        ),
                                      ),
                                      onNext: () => setState(
                                        () => _referenceDate = DateTime(
                                          referenceDate.year,
                                          referenceDate.month + 1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SummaryCard(summary: summary),
                                  ],
                                ),
                              ),
                              ZimbaSection(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  0,
                                ),
                                child: OutlinedButton.icon(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => ReportsPage(
                                        database: widget.database,
                                        referenceDate: referenceDate,
                                      ),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.assessment_outlined,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Ver relatórios mensais e parcelas',
                                  ),
                                ),
                              ),
                              ZimbaSection(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  12,
                                  16,
                                  0,
                                ),
                                child: PendingReviewCard(
                                  summary: summary,
                                  onTap: () => widget.onNavigate?.call(1),
                                ),
                              ),
                              ZimbaSection(
                                title: 'Leitura do mês',
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  23,
                                  16,
                                  0,
                                ),
                                child: MonthlyReadingSection(
                                  summary: summary,
                                  selectedIndex: breakdownIndex,
                                  onSelected: (value) =>
                                      setState(() => breakdownIndex = value),
                                ),
                              ),
                              ZimbaSection(
                                title: 'Fontes dos dados',
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  22,
                                  16,
                                  0,
                                ),
                                child: SourceSummarySection(
                                  items: summary.bySource,
                                ),
                              ),
                              ZimbaSection(
                                title: 'Próximos compromissos',
                                child: UpcomingCommitmentsSection(
                                  structure: structure,
                                  referenceDate: referenceDate,
                                ),
                              ),
                              ZimbaSection(
                                title: 'Últimas movimentações',
                                action: TextButton(
                                  onPressed: () => widget.onNavigate?.call(3),
                                  style: TextButton.styleFrom(
                                    foregroundColor: ZimbaColors.accent,
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: const Text('Ver todas'),
                                ),
                                child: RecentTransactionsRows(
                                  details: details
                                      .take(5)
                                      .toList(growable: false),
                                ),
                              ),
                              ZimbaSection(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  20,
                                  16,
                                  16,
                                ),
                                child: _OpenMovementsButton(
                                  onPressed: () => widget.onNavigate?.call(3),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openRegistry(String kind) {
    if (widget.onOpenRegistries != null) {
      widget.onOpenRegistries!(kind);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RegistriesPage(
          database: widget.database,
          initialTabIndex: 1,
          initialInstrumentKind: kind,
        ),
      ),
    );
  }

  void _openImport() {
    if (widget.onOpenImport != null) {
      widget.onOpenImport!();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ImportPage(database: widget.database)),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.month});
  final String month;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    // AppShell reserves an empty leading grid cell; its title starts at 24.
    padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
    decoration: const BoxDecoration(
      color: ZimbaColors.background,
      border: Border(bottom: BorderSide(color: ZimbaColors.border)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo',
          style: _text(
            context,
            19,
            FontWeight.w600,
            height: 1.2,
            letterSpacing: -.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          month,
          style: _text(
            context,
            12,
            FontWeight.w400,
            color: ZimbaColors.secondaryText,
          ),
        ),
      ],
    ),
  );
}

class _SummaryMonthSelector extends StatelessWidget {
  const _SummaryMonthSelector({
    required this.referenceDate,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime referenceDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => ZimbaCard(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Competência anterior',
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                _monthTitle(referenceDate),
                style: _text(context, 14, FontWeight.w600),
              ),
              Text(
                'Competência',
                style: _text(
                  context,
                  11,
                  FontWeight.w400,
                  color: ZimbaColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Próxima competência',
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    ),
  );
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({required this.summary, super.key});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) => ZimbaCard(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SALDO DO MÊS',
          style: _text(
            context,
            11,
            FontWeight.w600,
            color: ZimbaColors.secondaryText,
            letterSpacing: .7,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatBrl(summary.balanceCents),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _text(context, 30, FontWeight.w600, height: 1),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryMetric(
                label: 'ENTRADAS',
                value: formatBrl(summary.incomeCents),
                delta: '+0,0% vs jul',
                background: ZimbaColors.successSoft,
                labelColor: ZimbaColors.success,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryMetric(
                label: 'SAÍDAS',
                value: formatBrl(summary.expenseCents.abs()),
                delta: '+0,0% vs jul',
                background: ZimbaColors.destructiveSoft,
                labelColor: ZimbaColors.destructive,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: ZimbaColors.accentSoft,
            borderRadius: BorderRadius.circular(ZimbaRadii.md),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final label = Text(
                'Transferências internas (não contam como despesa)',
                maxLines: constraints.maxWidth < 320 ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: _text(
                  context,
                  12,
                  FontWeight.w500,
                  color: ZimbaColors.accent,
                ),
              );
              final amount = Text(
                formatBrl(summary.transferCents),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _text(
                  context,
                  13,
                  FontWeight.w600,
                  color: ZimbaColors.accent,
                ),
              );
              if (constraints.maxWidth < 320) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.repeat2,
                          color: ZimbaColors.accent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(child: label),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Align(alignment: Alignment.centerRight, child: amount),
                  ],
                );
              }
              return Row(
                children: [
                  const Icon(
                    LucideIcons.repeat2,
                    color: ZimbaColors.accent,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Expanded(child: label),
                  const SizedBox(width: 8),
                  Flexible(child: amount),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.delta,
    required this.background,
    required this.labelColor,
  });
  final String label;
  final String value;
  final String delta;
  final Color background;
  final Color labelColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(ZimbaRadii.md),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _text(context, 10, FontWeight.w600, color: labelColor),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _text(context, 15, FontWeight.w600),
        ),
        Text(
          delta,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _text(
            context,
            10,
            FontWeight.w400,
            color: ZimbaColors.secondaryText,
          ),
        ),
      ],
    ),
  );
}

class PendingReviewCard extends StatelessWidget {
  const PendingReviewCard({required this.summary, this.onTap, super.key});
  final DashboardSummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(ZimbaRadii.lg),
    child: ZimbaCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${summary.pendingCount} lançamentos aguardando revisão',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _text(context, 13, FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${formatBrl(summary.pendingCents)} ainda não consolidados',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _text(
                    context,
                    12,
                    FontWeight.w400,
                    color: ZimbaColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            LucideIcons.arrowRight,
            size: 16,
            color: ZimbaColors.accent,
          ),
        ],
      ),
    ),
  );
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
      0 => summary.byPerson,
      1 => summary.byCategory,
      _ => summary.byCostCenter,
    };
    return Column(
      children: [
        _DashboardSegmented(
          selectedIndex: selectedIndex,
          onSelected: onSelected,
        ),
        const SizedBox(height: 10),
        ZimbaCard(
          padding: const EdgeInsets.all(12),
          child: items.isEmpty
              ? const EmptyCompactState(
                  icon: LucideIcons.chartNoAxesColumn,
                  text: 'Sem dados neste mês.',
                )
              : _BreakdownRows(items: _orderedItems(items, selectedIndex)),
        ),
        const SizedBox(height: 3),
      ],
    );
  }
}

class _DashboardSegmented extends StatelessWidget {
  const _DashboardSegmented({
    required this.selectedIndex,
    required this.onSelected,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  static const labels = ['Pessoa', 'Categoria', 'Centro'];

  @override
  Widget build(BuildContext context) => Container(
    height: 36,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: ZimbaColors.muted,
      borderRadius: BorderRadius.circular(ZimbaRadii.md),
    ),
    child: Row(
      children: [
        for (var index = 0; index < labels.length; index++)
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(ZimbaRadii.sm),
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                key: ValueKey('dashboard-lens-$index'),
                duration: const Duration(milliseconds: 160),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? ZimbaColors.accentSoft
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(ZimbaRadii.sm),
                  boxShadow: selectedIndex == index ? ZimbaShadows.card : null,
                ),
                child: Text(
                  labels[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _text(
                    context,
                    12,
                    FontWeight.w600,
                    color: selectedIndex == index
                        ? ZimbaColors.foreground
                        : ZimbaColors.secondaryText,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class _BreakdownRows extends StatelessWidget {
  const _BreakdownRows({required this.items});
  final List<SummaryBreakdownItem> items;
  @override
  Widget build(BuildContext context) {
    final max = items.fold<int>(
      0,
      (value, item) =>
          item.amountCents.abs() > value ? item.amountCents.abs() : value,
    );
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  items[index].label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _text(context, 13, FontWeight.w400, height: 1.3),
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 124),
                child: Text(
                  formatBrl(items[index].amountCents),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: _text(context, 13, FontWeight.w600, height: 1.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: ZimbaColors.muted),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: max == 0
                        ? 0
                        : items[index].amountCents.abs() / max,
                    child: const ColoredBox(color: ZimbaColors.accent),
                  ),
                ],
              ),
            ),
          ),
          if (index < items.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

List<SummaryBreakdownItem> _orderedItems(
  List<SummaryBreakdownItem> source,
  int selectedIndex,
) {
  final order = switch (selectedIndex) {
    1 => const ['Casa', 'Educação', 'Mercado', 'Transporte', 'Saúde', 'Lazer'],
    2 => const ['Casa', 'Filhos', 'Carro', 'Pessoal'],
    _ => const <String>[],
  };
  if (order.isEmpty) return source;
  final rank = {
    for (var index = 0; index < order.length; index++) order[index]: index,
  };
  return [...source]..sort(
    (left, right) => (rank[left.label] ?? order.length).compareTo(
      rank[right.label] ?? order.length,
    ),
  );
}

class SourceSummarySection extends StatelessWidget {
  const SourceSummarySection({required this.items, super.key});
  final List<SummaryBreakdownItem> items;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: ZimbaCard(
      padding: const EdgeInsets.all(12),
      child: items.isEmpty
          ? const EmptyCompactState(
              icon: LucideIcons.database,
              text: 'Sem fontes neste mês.',
            )
          : Row(
              children: [
                for (final item in items.take(4))
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${item.count}',
                          style: _text(context, 16, FontWeight.w600),
                        ),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: _text(
                            context,
                            10,
                            FontWeight.w400,
                            color: ZimbaColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    ),
  );
}

class UpcomingCommitmentsSection extends StatelessWidget {
  const UpcomingCommitmentsSection({
    required this.structure,
    required this.referenceDate,
    super.key,
  });
  final FamilyStructureSnapshot? structure;
  final DateTime referenceDate;
  @override
  Widget build(BuildContext context) {
    final items = <_CommitmentItem>[
      for (final item in structure?.recurringSchedules ?? const [])
        if (item.active)
          _CommitmentItem(
            label: item.label,
            date: _commitmentDate(referenceDate, item.dayOfMonth),
            tag: 'RECORRÊNCIA',
            amountCents: item.amountCents,
          ),
      for (final item in structure?.installmentPlans ?? const [])
        if (item.active)
          _CommitmentItem(
            label:
                '${item.label} ${item.currentInstallment}/${item.totalInstallments}',
            date: _commitmentDate(referenceDate, item.dueDay ?? 1),
            tag: 'PARCELA',
            amountCents: -item.installmentAmountCents.abs(),
          ),
    ]..sort((left, right) => left.date.compareTo(right.date));
    if (items.isEmpty) {
      return ZimbaCard(
        padding: const EdgeInsets.all(16),
        child: const EmptyCompactState(
          icon: LucideIcons.calendarCheck,
          text: 'Sem compromissos cadastrados.',
        ),
      );
    }
    return ZimbaRows(
      children: [
        for (final item in items.take(5))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _text(context, 13, FontWeight.w500),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            _shortDate(item.date),
                            style: _text(
                              context,
                              11,
                              FontWeight.w400,
                              color: ZimbaColors.secondaryText,
                            ),
                          ),
                          const SizedBox(width: 6),
                          ZimbaBadge(label: item.tag),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 112),
                  child: Text(
                    formatBrl(item.amountCents),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: _amountStyle(context, item.amountCents),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class RecentTransactionsRows extends StatelessWidget {
  const RecentTransactionsRows({required this.details, super.key});
  final List<ReviewTransactionDetails> details;
  @override
  Widget build(BuildContext context) {
    if (details.isEmpty) {
      return ZimbaCard(
        padding: const EdgeInsets.all(16),
        child: const EmptyCompactState(
          icon: LucideIcons.receiptText,
          text: 'Nenhuma movimentação local ainda.',
        ),
      );
    }
    return ZimbaRows(
      children: [
        for (final item in details)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.displayTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _text(context, 13, FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _BeneficiaryDots(details: item),
                          if (item.beneficiaries.isNotEmpty)
                            const SizedBox(width: 6),
                          ZimbaBadge(
                            label: _reviewStatusLabel(
                              item.transaction.reviewStatus,
                            ),
                            tone: item.transaction.reviewStatus == 'confirmed'
                                ? ZimbaTone.success
                                : ZimbaTone.neutral,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 112),
                      child: Text(
                        formatBrl(item.transaction.amountCents),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: _amountStyle(
                          context,
                          item.transaction.amountCents,
                        ),
                      ),
                    ),
                    Text(
                      _shortDate(item.transaction.occurredAt),
                      style: _text(
                        context,
                        10,
                        FontWeight.w400,
                        color: ZimbaColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _BeneficiaryDots extends StatelessWidget {
  const _BeneficiaryDots({required this.details});
  final ReviewTransactionDetails details;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: details.beneficiaries.take(4).length * 14 + 6,
    height: 20,
    child: Stack(
      children: [
        for (
          var index = 0;
          index < details.beneficiaries.take(4).length;
          index++
        )
          Positioned(
            left: index * 14,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: [
                ZimbaColors.accentSoft,
                ZimbaColors.infoSoft,
                ZimbaColors.warningSoft,
                ZimbaColors.successSoft,
              ][index],
              child: Text(
                details.beneficiaries[index].displayName
                    .substring(0, 1)
                    .toUpperCase(),
                style: _text(context, 9, FontWeight.w600),
              ),
            ),
          ),
      ],
    ),
  );
}

class _OpenMovementsButton extends StatelessWidget {
  const _OpenMovementsButton({required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onPressed,
      child: const Text('Abrir movimentações'),
    ),
  );
}

class EmptyCompactState extends StatelessWidget {
  const EmptyCompactState({required this.icon, required this.text, super.key});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: ZimbaColors.secondaryText),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: _text(
            context,
            12,
            FontWeight.w400,
            color: ZimbaColors.secondaryText,
          ),
        ),
      ),
    ],
  );
}

class _EmptyDashboardState extends StatelessWidget {
  const _EmptyDashboardState();
  @override
  Widget build(BuildContext context) => ZimbaCard(
    child: const EmptyCompactState(
      icon: LucideIcons.receiptText,
      text: 'Seu resumo começa aqui. Adicione ou importe um lançamento.',
    ),
  );
}

class _InitialHomeState extends StatelessWidget {
  const _InitialHomeState({
    required this.onOpenAccount,
    required this.onOpenCard,
    required this.onOpenImport,
  });

  final VoidCallback onOpenAccount;
  final VoidCallback onOpenCard;
  final VoidCallback onOpenImport;

  @override
  Widget build(BuildContext context) => ZimbaCard(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.sparkles, color: ZimbaColors.accent, size: 28),
          const SizedBox(height: 14),
          Text('Seu controle começa aqui', style: _text(context, 20, FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Nada será criado automaticamente. Adicione apenas o que quiser acompanhar.',
            style: _text(
              context,
              14,
              FontWeight.w400,
              color: ZimbaColors.secondaryText,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onOpenAccount,
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: const Text('Adicionar conta'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpenCard,
              icon: const Icon(Icons.credit_card_outlined),
              label: const Text('Adicionar cartão'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onOpenImport,
              icon: const Icon(Icons.file_upload_outlined),
              label: const Text('Importar OFX ou CSV'),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ao importar, você confirmará a conta ou cartão de destino.',
            style: _text(context, 12, FontWeight.w400, color: ZimbaColors.secondaryText),
          ),
        ],
      ),
    ),
  );
}

class _CommitmentItem {
  const _CommitmentItem({
    required this.label,
    required this.date,
    required this.tag,
    required this.amountCents,
  });
  final String label;
  final DateTime date;
  final String tag;
  final int amountCents;
}

TextStyle _text(
  BuildContext context,
  double size,
  FontWeight weight, {
  Color? color,
  double? letterSpacing,
  double? height,
}) => Theme.of(context).textTheme.bodyMedium!.copyWith(
  fontSize: size,
  fontWeight: weight,
  color: color,
  letterSpacing: letterSpacing,
  height: height,
);

TextStyle _amountStyle(BuildContext context, int amount) => _text(
  context,
  13,
  FontWeight.w600,
  color: amount > 0 ? ZimbaColors.success : ZimbaColors.foreground,
);

String _reviewStatusLabel(String status) => switch (status) {
  'pending' => 'PENDENTE',
  'confirmed' => 'REVISADO',
  'ignored' => 'IGNORADO',
  'duplicate' => 'DUPLICADO',
  _ => status.toUpperCase(),
};

DateTime _commitmentDate(DateTime now, int day) {
  final current = DateTime(
    now.year,
    now.month,
    _clampDay(now.year, now.month, day),
  );
  return current.isBefore(DateTime(now.year, now.month, now.day))
      ? DateTime(
          now.year,
          now.month + 1,
          _clampDay(now.year, now.month + 1, day),
        )
      : current;
}

int _clampDay(int year, int month, int day) =>
    day.clamp(1, DateTime(year, month + 1, 0).day);

String _shortDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

String _monthTitle(DateTime date) {
  const months = [
    'Janeiro',
    'Fevereiro',
    'Março',
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

String formatBrl(int cents) {
  final sign = cents < 0 ? '-' : '';
  final absolute = cents.abs();
  final reais = (absolute ~/ 100).toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match.group(1)}.',
  );
  return '${sign}R\$ $reais,${(absolute % 100).toString().padLeft(2, '0')}';
}
