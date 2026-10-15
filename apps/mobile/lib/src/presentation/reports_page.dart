import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart' show formatBrl;
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({required this.database, super.key, this.referenceDate});
  final AppDatabase database;
  final DateTime? referenceDate;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        ZimbaCompactHeader(
          title: 'Relatórios',
          subtitle: 'Leituras e previsões',
          leading: IconButton(
            tooltip: 'Voltar',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, size: 21),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ReportCard(
                icon: Icons.calendar_month_outlined,
                title: 'Relatório mensal',
                subtitle:
                    'Realizados, pendências e classificação por competência.',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => MonthlyReportPage(
                      database: database,
                      initialMonth: referenceDate == null
                          ? null
                          : _monthKey(referenceDate!),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _ReportCard(
                icon: Icons.fact_check_outlined,
                title: 'Fechamento mensal',
                subtitle:
                    'Concilie OFX e notificacoes Nubank sem ocultar divergencias.',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => MonthlyReconciliationPage(
                      database: database,
                      initialMonth: referenceDate == null
                          ? null
                          : _monthKey(referenceDate!),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _ReportCard(
                icon: Icons.event_repeat_outlined,
                title: 'Parcelas futuras',
                subtitle: 'Parcelas e recorrências previstas até o término.',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => FutureCommitmentsReportPage(
                      database: database,
                      referenceDate: referenceDate,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class MonthlyReconciliationPage extends StatefulWidget {
  const MonthlyReconciliationPage({
    required this.database,
    super.key,
    this.initialMonth,
  });

  final AppDatabase database;
  final String? initialMonth;

  @override
  State<MonthlyReconciliationPage> createState() =>
      _MonthlyReconciliationPageState();
}

class _MonthlyReconciliationPageState extends State<MonthlyReconciliationPage> {
  late String month = widget.initialMonth ?? _monthKey(DateTime.now());
  late Future<List<MonthlyReconciliationRunSummary>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _load();
  }

  Future<List<MonthlyReconciliationRunSummary>> _load() =>
      widget.database.rebuildMonthlyReconciliation(month);

  void _reload() => setState(() => dataFuture = _load());

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        ZimbaCompactHeader(
          title: 'Fechamento mensal',
          subtitle: 'OFX confirma; notificacoes so adicionam evidencia',
          leading: IconButton(
            tooltip: 'Voltar',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, size: 21),
          ),
          trailing: IconButton(
            tooltip: 'Atualizar fechamento',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ),
        _MonthSelector(
          month: month,
          onChanged: (value) {
            setState(() {
              month = value;
              dataFuture = _load();
            });
          },
        ),
        Expanded(
          child: FutureBuilder<List<MonthlyReconciliationRunSummary>>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ZimbaStateMessage(
                  icon: Icons.error_outline,
                  title: 'Nao foi possivel montar o fechamento',
                  body:
                      'Os lancamentos permanecem preservados. Tente atualizar.',
                );
              }
              if (!snapshot.hasData) {
                return const ZimbaLoadingState(
                  label: 'Conferindo evidencias locais',
                );
              }
              final runs = snapshot.data!;
              if (runs.isEmpty) {
                return const ZimbaStateMessage(
                  icon: Icons.account_balance_outlined,
                  title: 'Nenhum instrumento Nubank',
                  body:
                      'Cadastre a conta ou cartao Nubank para fechar este mes.',
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const ZimbaCard(
                    child: Text(
                      'OFX e a fonte de fechamento. Nome e descricao servem apenas para busca; notificacao nunca confirma uma movimentacao sozinha.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final run in runs) ...[
                    _MonthlyReconciliationRunCard(
                      database: widget.database,
                      summary: run,
                      onChanged: _reload,
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _MonthlyReconciliationRunCard extends StatefulWidget {
  const _MonthlyReconciliationRunCard({
    required this.database,
    required this.summary,
    required this.onChanged,
  });

  final AppDatabase database;
  final MonthlyReconciliationRunSummary summary;
  final VoidCallback onChanged;

  @override
  State<_MonthlyReconciliationRunCard> createState() =>
      _MonthlyReconciliationRunCardState();
}

class _MonthlyReconciliationRunCardState
    extends State<_MonthlyReconciliationRunCard> {
  late Future<List<MonthlyReconciliationItemDetails>> itemsFuture;

  @override
  void initState() {
    super.initState();
    itemsFuture = widget.database.listMonthlyReconciliationItems(
      widget.summary.run.id,
    );
  }

  Future<void> _closeWithReservations() async {
    await widget.database.closeMonthlyReconciliationWithReservations(
      widget.summary.run.id,
    );
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final status = summary.hasReservations
        ? 'Fechado com ressalvas'
        : 'Sem divergencias';
    return ZimbaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  summary.account?.name ?? 'Instrumento removido',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ZimbaBadge(
                label: status,
                tone: summary.hasReservations
                    ? ZimbaTone.warning
                    : ZimbaTone.success,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ReconciliationCount('Conciliados', summary.autoReconciled),
              _ReconciliationCount('So notificacao', summary.notificationOnly),
              _ReconciliationCount('So OFX', summary.ofxOnly),
              _ReconciliationCount(
                'Pagamentos candidatos',
                summary.paymentCandidates,
              ),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<MonthlyReconciliationItemDetails>>(
            future: itemsFuture,
            builder: (context, snapshot) {
              final items =
                  snapshot.data ?? const <MonthlyReconciliationItemDetails>[];
              if (items.isEmpty) return const SizedBox.shrink();
              return ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text('Evidencias e divergencias'),
                children: [
                  for (final item in items)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        item.transaction?.displayDescription ??
                            item.transaction?.descriptionRaw ??
                            'Evidencia local',
                      ),
                      subtitle: Text(_reconciliationItemLabel(item.item.state)),
                      trailing: item.transaction == null
                          ? null
                          : Text(
                              formatBrl(item.transaction!.amountCents.abs()),
                            ),
                    ),
                ],
              );
            },
          ),
          if (summary.run.status != 'closed_with_reservations')
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _closeWithReservations,
                child: const Text('Fechar com ressalvas'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReconciliationCount extends StatelessWidget {
  const _ReconciliationCount(this.label, this.value);
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => ZimbaBadge(
    label: '$label: $value',
    tone: value == 0 ? ZimbaTone.neutral : ZimbaTone.accent,
  );
}

String _reconciliationItemLabel(String state) => switch (state) {
  'auto_reconciled' => 'Conciliado automaticamente por evidencia forte',
  'notification_only' => 'Somente notificacao: revisar',
  'ofx_only' => 'Somente OFX: conferir notificacao',
  'payment_candidate' => 'Pagamento candidato: confirmar em Faturas',
  'payment_confirmed' => 'Pagamento confirmado explicitamente',
  'manually_merged' => 'Mesclado por decisao manual',
  'kept_separate' => 'Mantido separado',
  'ignored' => 'Ignorado com auditoria',
  _ => state.replaceAll('_', ' '),
};

class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({
    required this.database,
    super.key,
    this.initialMonth,
  });
  final AppDatabase database;
  final String? initialMonth;
  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  late String month = widget.initialMonth ?? _monthKey(DateTime.now());
  var breakdown = _ExpenseBreakdown.category;

  @override
  Widget build(
    BuildContext context,
  ) => StreamBuilder<List<ReviewTransactionDetails>>(
    stream: widget.database.watchAllTransactionDetails(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Scaffold(
          body: ZimbaStateMessage(
            icon: Icons.error_outline,
            title: 'Não foi possível calcular o relatório',
            body: 'Tente abrir esta competência novamente.',
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting &&
          !snapshot.hasData) {
        return const Scaffold(
          body: ZimbaLoadingState(label: 'Calculando o mês'),
        );
      }
      final rows = (snapshot.data ?? const <ReviewTransactionDetails>[])
          .where(
            (row) =>
                row.transaction.competenceMonth == month &&
                row.transaction.kind != 'transfer',
          )
          .toList();
      final confirmed = rows.where(
        (row) => row.transaction.reviewStatus == 'confirmed',
      );
      final pending = rows
          .where((row) => row.transaction.reviewStatus == 'pending')
          .toList();
      final income = confirmed
          .where((row) => row.transaction.kind == 'income')
          .fold(0, (sum, row) => sum + row.transaction.amountCents.abs());
      final expense = confirmed
          .where((row) => row.transaction.kind == 'expense')
          .fold(0, (sum, row) => sum + row.transaction.amountCents.abs());
      final confirmedExpenses = confirmed
          .where((row) => row.transaction.kind == 'expense')
          .toList(growable: false);
      final activeBreakdown = switch (breakdown) {
        _ExpenseBreakdown.category => _buildExpenseHierarchy(
          confirmedExpenses,
          labelsFor: (row) => [row.categoryLabel, row.subcategoryLabel],
        ),
        _ExpenseBreakdown.person => _buildExpenseHierarchy(
          confirmedExpenses,
          labelsFor: (row) => [
            row.beneficiaries.isEmpty
                ? 'Sem pessoa'
                : row.beneficiaries
                      .map((person) => person.displayName)
                      .join(', '),
            row.categoryLabel,
            row.subcategoryLabel,
          ],
        ),
        _ExpenseBreakdown.context => _buildExpenseHierarchy(
          confirmedExpenses,
          labelsFor: (row) => [row.costCenterLabel],
        ),
      };
      return Scaffold(
        body: Column(
          children: [
            ZimbaCompactHeader(
              title: 'Relatório mensal',
              subtitle: _monthLabel(month),
              leading: IconButton(
                tooltip: 'Voltar',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, size: 21),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _MonthSelector(
                    month: month,
                    onChanged: (value) => setState(() => month = value),
                  ),
                  const SizedBox(height: 12),
                  ZimbaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REALIZADO',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: ZimbaColors.secondaryText),
                        ),
                        const SizedBox(height: 10),
                        _Metric('Receitas', income, ZimbaColors.success),
                        _Metric('Despesas', expense, ZimbaColors.destructive),
                        _Metric('Saldo', income - expense, ZimbaColors.accent),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ZimbaFeedbackBanner(
                    icon: Icons.swap_horiz_outlined,
                    title: 'Movimentos neutros',
                    body:
                        '${formatBrl(rows.where((row) => row.transaction.reviewStatus == 'confirmed' && row.transaction.kind == 'transfer').fold<int>(0, (sum, row) => sum + row.transaction.amountCents.abs()))} em transferências; não entram nos totais.',
                    tone: ZimbaTone.accent,
                  ),
                  if (pending.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ZimbaFeedbackBanner(
                      icon: Icons.pending_actions_outlined,
                      title: '${pending.length} pendência(s) de revisão',
                      body: 'Elas não entram nos totais realizados.',
                      tone: ZimbaTone.warning,
                    ),
                  ],
                  const SizedBox(height: 22),
                  const ZimbaSectionTitle('Detalhamento de despesas'),
                  ZimbaSegmentedControl<_ExpenseBreakdown>(
                    segments: const [
                      ButtonSegment(
                        value: _ExpenseBreakdown.category,
                        label: Text('Categoria'),
                      ),
                      ButtonSegment(
                        value: _ExpenseBreakdown.person,
                        label: Text('Pessoa'),
                      ),
                      ButtonSegment(
                        value: _ExpenseBreakdown.context,
                        label: Text('Contexto'),
                      ),
                    ],
                    selected: {breakdown},
                    onSelectionChanged: (selection) =>
                        setState(() => breakdown = selection.first),
                  ),
                  const SizedBox(height: 10),
                  _BreakdownTree(items: activeBreakdown),
                  if (rows.isEmpty) ...[
                    const SizedBox(height: 20),
                    const ZimbaStateMessage(
                      icon: Icons.calendar_today_outlined,
                      title: 'Mês vazio',
                      body: 'Não há lançamentos nesta competência.',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class FutureCommitmentsReportPage extends StatelessWidget {
  const FutureCommitmentsReportPage({
    required this.database,
    super.key,
    this.referenceDate,
  });
  final AppDatabase database;
  final DateTime? referenceDate;
  @override
  Widget build(BuildContext context) => FutureBuilder<FamilyStructureSnapshot>(
    future: database.getFamilyStructureSnapshot(),
    builder: (context, snapshot) {
      final structure = snapshot.data;
      final forecast = structure == null
          ? const _FutureReport.empty()
          : _buildFutureReport(structure, referenceDate ?? DateTime.now());
      return Scaffold(
        body: Column(
          children: [
            ZimbaCompactHeader(
              title: 'Parcelas futuras',
              subtitle: 'Projeção por competência',
              leading: IconButton(
                tooltip: 'Voltar',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, size: 21),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  const ZimbaFeedbackBanner(
                    icon: Icons.info_outline,
                    title: 'Previsão, não despesa realizada',
                    body:
                        'Os valores abaixo servem para planejamento e não criam lançamentos.',
                    tone: ZimbaTone.neutral,
                  ),
                  const SizedBox(height: 14),
                  ZimbaCard(
                    child: Text(
                      '${forecast.remainingInstallments} parcelas restantes em ${forecast.months.length} competência(s).',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (forecast.months.isEmpty) ...[
                    const SizedBox(height: 18),
                    const ZimbaStateMessage(
                      icon: Icons.event_available_outlined,
                      title: 'Sem previsões',
                      body: 'Nenhuma parcela restante ou recorrência ativa.',
                    ),
                  ],
                  for (final item in forecast.months) ...[
                    const SizedBox(height: 22),
                    _FutureMonth(items: item),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ZimbaCard(
    padding: EdgeInsets.zero,
    child: ListTile(
      onTap: onTap,
      leading: Icon(icon, color: ZimbaColors.accent),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.amount, this.color);
  final String label;
  final int amount;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          formatBrl(amount),
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

enum _ExpenseBreakdown { category, person, context }

class _ExpenseBreakdownNode {
  const _ExpenseBreakdownNode({
    required this.label,
    required this.amountCents,
    this.children = const [],
  });

  final String label;
  final int amountCents;
  final List<_ExpenseBreakdownNode> children;
}

class _MutableExpenseBreakdownNode {
  _MutableExpenseBreakdownNode(this.label);

  final String label;
  var amountCents = 0;
  final Map<String, _MutableExpenseBreakdownNode> children = {};

  _ExpenseBreakdownNode freeze() {
    final orderedChildren =
        children.values.map((child) => child.freeze()).toList()..sort(
          (left, right) => right.amountCents.compareTo(left.amountCents),
        );
    return _ExpenseBreakdownNode(
      label: label,
      amountCents: amountCents,
      children: orderedChildren,
    );
  }
}

List<_ExpenseBreakdownNode> _buildExpenseHierarchy(
  List<ReviewTransactionDetails> rows, {
  required List<String> Function(ReviewTransactionDetails row) labelsFor,
}) {
  final roots = <String, _MutableExpenseBreakdownNode>{};
  for (final row in rows) {
    final amount = row.transaction.amountCents.abs();
    final labels = labelsFor(row);
    if (labels.isEmpty) continue;

    Map<String, _MutableExpenseBreakdownNode> siblings = roots;
    _MutableExpenseBreakdownNode? current;
    for (final label in labels) {
      current = siblings.putIfAbsent(
        label,
        () => _MutableExpenseBreakdownNode(label),
      );
      current.amountCents += amount;
      siblings = current.children;
    }
  }
  final hierarchy = roots.values.map((item) => item.freeze()).toList()
    ..sort((left, right) => right.amountCents.compareTo(left.amountCents));
  return hierarchy;
}

class _BreakdownTree extends StatelessWidget {
  const _BreakdownTree({required this.items});

  final List<_ExpenseBreakdownNode> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyText('Sem despesas realizadas.');
    final maxAmount = items.fold<int>(
      0,
      (current, item) =>
          item.amountCents > current ? item.amountCents : current,
    );
    return ZimbaCard(
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _BreakdownTreeNode(
              item: items[index],
              level: 0,
              parentAmount: maxAmount,
            ),
            if (index < items.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _BreakdownTreeNode extends StatelessWidget {
  const _BreakdownTreeNode({
    required this.item,
    required this.level,
    required this.parentAmount,
  });

  final _ExpenseBreakdownNode item;
  final int level;
  final int parentAmount;

  @override
  Widget build(BuildContext context) {
    final indentation = level * 14.0;
    final progress = parentAmount == 0 ? 0.0 : item.amountCents / parentAmount;
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: level == 0 ? FontWeight.w700 : FontWeight.w400,
      color: item.label == 'Sem subcategoria' || item.label == 'Sem pessoa'
          ? ZimbaColors.secondaryText
          : null,
    );
    final amount = Text(
      formatBrl(item.amountCents),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
    );
    final label = Row(
      children: [
        if (level > 0) ...[
          const Icon(
            Icons.subdirectory_arrow_right,
            size: 15,
            color: ZimbaColors.secondaryText,
          ),
          const SizedBox(width: 3),
        ],
        Expanded(
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: labelStyle,
          ),
        ),
      ],
    );
    return Padding(
      padding: EdgeInsets.only(left: indentation, top: level == 0 ? 0 : 7),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            if (constraints.maxWidth <= 360) ...[
              label,
              const SizedBox(height: 2),
              Align(alignment: Alignment.centerRight, child: amount),
            ] else
              Row(
                children: [
                  Expanded(child: label),
                  const SizedBox(width: 8),
                  amount,
                ],
              ),
            const SizedBox(height: 3),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1),
                minHeight: level == 0 ? 5 : 3,
                backgroundColor: ZimbaColors.muted,
                color: level == 0
                    ? ZimbaColors.accent
                    : ZimbaColors.accent.withValues(alpha: .55),
              ),
            ),
            for (final child in item.children)
              _BreakdownTreeNode(
                item: child,
                level: level + 1,
                parentAmount: item.amountCents,
              ),
          ],
        ),
      ),
    );
  }
}

class _FutureReport {
  const _FutureReport({
    required this.months,
    required this.remainingInstallments,
  });

  const _FutureReport.empty() : months = const [], remainingInstallments = 0;

  final List<_FutureMonthData> months;
  final int remainingInstallments;
}

class _FutureMonthData {
  const _FutureMonthData({required this.month, required this.items});

  final String month;
  final List<_ForecastItem> items;

  int get totalCents =>
      items.fold(0, (sum, item) => sum + item.amountCents.abs());
}

class _ForecastItem {
  const _ForecastItem({
    required this.label,
    required this.detail,
    required this.amountCents,
    required this.tag,
  });

  final String label;
  final String detail;
  final int amountCents;
  final String tag;
}

_FutureReport _buildFutureReport(
  FamilyStructureSnapshot structure,
  DateTime referenceDate,
) {
  final start = _monthKey(referenceDate);
  final plans = structure.installmentPlans
      .where((item) => item.active)
      .toList();
  final schedules = structure.recurringSchedules
      .where((item) => item.active)
      .toList();
  final monthItems = <String, List<_ForecastItem>>{};
  var horizon = start;
  var remainingInstallments = 0;

  for (final plan in plans) {
    final remaining = (plan.totalInstallments - plan.currentInstallment + 1)
        .clamp(0, plan.totalInstallments);
    remainingInstallments += remaining;
    final first = _laterMonth(start, plan.startMonth);
    for (var index = 0; index < remaining; index++) {
      final month = _shiftMonth(first, index);
      if (plan.endMonth != null && month.compareTo(plan.endMonth!) > 0) break;
      horizon = _laterMonth(horizon, month);
      monthItems
          .putIfAbsent(month, () => [])
          .add(
            _ForecastItem(
              label: plan.label,
              detail:
                  'Parcela ${plan.currentInstallment + index}/${plan.totalInstallments}',
              amountCents: plan.installmentAmountCents,
              tag: 'Parcela',
            ),
          );
    }
  }
  for (final schedule in schedules) {
    if (schedule.endMonth != null) {
      horizon = _laterMonth(horizon, schedule.endMonth!);
    }
  }
  for (
    var month = start;
    month.compareTo(horizon) <= 0;
    month = _shiftMonth(month, 1)
  ) {
    for (final schedule in schedules) {
      if (month.compareTo(schedule.startMonth) < 0 ||
          (schedule.endMonth != null &&
              month.compareTo(schedule.endMonth!) > 0)) {
        continue;
      }
      monthItems
          .putIfAbsent(month, () => [])
          .add(
            _ForecastItem(
              label: schedule.label,
              detail: schedule.endMonth == null
                  ? 'Recorrência contínua'
                  : 'Recorrência até ${schedule.endMonth}',
              amountCents: schedule.amountCents,
              tag: schedule.kind == 'transfer' ? 'Neutra' : 'Contínua',
            ),
          );
    }
  }
  final months = [
    for (final entry in monthItems.entries)
      _FutureMonthData(month: entry.key, items: entry.value),
  ]..sort((left, right) => left.month.compareTo(right.month));
  return _FutureReport(
    months: months,
    remainingInstallments: remainingInstallments,
  );
}

class _FutureMonth extends StatelessWidget {
  const _FutureMonth({required this.items});
  final _FutureMonthData items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(child: ZimbaSectionTitle(_monthLabel(items.month))),
          Text(
            formatBrl(items.totalCents),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ZimbaRows(
        children: [
          for (final item in items.items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final content = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.detail,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: ZimbaColors.secondaryText),
                            ),
                          ),
                          const SizedBox(width: 6),
                          ZimbaBadge(
                            label: item.tag,
                            tone: item.tag == 'Neutra'
                                ? ZimbaTone.accent
                                : ZimbaTone.neutral,
                          ),
                        ],
                      ),
                    ],
                  );
                  final amount = Text(
                    formatBrl(item.amountCents.abs()),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  );
                  if (constraints.maxWidth < 380) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        content,
                        const SizedBox(height: 6),
                        Align(alignment: Alignment.centerRight, child: amount),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: content),
                      const SizedBox(width: 12),
                      amount,
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    ],
  );
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => ZimbaCard(
    child: Text(text, style: const TextStyle(color: ZimbaColors.secondaryText)),
  );
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({required this.month, required this.onChanged});
  final String month;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        tooltip: 'Competência anterior',
        onPressed: () => onChanged(_shiftMonth(month, -1)),
        icon: const Icon(Icons.chevron_left),
      ),
      Expanded(
        child: Center(
          child: Text(month, style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
      IconButton(
        tooltip: 'Próxima competência',
        onPressed: () => onChanged(_shiftMonth(month, 1)),
        icon: const Icon(Icons.chevron_right),
      ),
    ],
  );
}

String _monthKey(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}';
String _shiftMonth(String month, int delta) {
  final parts = month.split('-');
  return _monthKey(DateTime(int.parse(parts[0]), int.parse(parts[1]) + delta));
}

String _laterMonth(String left, String right) =>
    left.compareTo(right) >= 0 ? left : right;

String _monthLabel(String month) {
  final parts = month.split('-');
  final index = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 1;
  const names = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];
  return '${names[(index - 1).clamp(0, 11)]} ${parts.first}';
}
