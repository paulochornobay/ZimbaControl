import '../data/local/app_database.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.incomeCents,
    required this.expenseCents,
    required this.pendingCount,
    this.transferCount = 0,
    this.transferCents = 0,
    this.pendingCents = 0,
    this.futureCommitmentCents = 0,
    this.byPerson = const [],
    this.byCategory = const [],
    this.byCostCenter = const [],
    this.bySource = const [],
  });

  final int incomeCents;
  final int expenseCents;
  final int pendingCount;
  final int transferCount;
  final int transferCents;
  final int pendingCents;
  final int futureCommitmentCents;
  final List<SummaryBreakdownItem> byPerson;
  final List<SummaryBreakdownItem> byCategory;
  final List<SummaryBreakdownItem> byCostCenter;
  final List<SummaryBreakdownItem> bySource;

  int get balanceCents => incomeCents + expenseCents;
}

class SummaryBreakdownItem {
  const SummaryBreakdownItem({
    required this.label,
    required this.amountCents,
    required this.count,
  });

  final String label;
  final int amountCents;
  final int count;
}

DashboardSummary buildDashboardSummary(List<FinanceTransaction> transactions) {
  final income = transactions
      .where((tx) => tx.kind == 'income')
      .fold<int>(0, (sum, tx) => sum + tx.amountCents);
  final expense = transactions
      .where((tx) => tx.kind == 'expense')
      .fold<int>(0, (sum, tx) => sum + tx.amountCents);
  final pending = transactions.where((tx) => tx.reviewStatus == 'pending');

  return DashboardSummary(
    incomeCents: income,
    expenseCents: expense,
    pendingCount: pending.length,
  );
}

DashboardSummary buildOperationalDashboardSummary({
  required List<ReviewTransactionDetails> details,
  required List<RecurringScheduleRow> recurringSchedules,
  required List<InstallmentPlanRow> installmentPlans,
  DateTime? now,
}) {
  final current = now ?? DateTime.now();
  final currentMonth =
      '${current.year.toString().padLeft(4, '0')}-'
      '${current.month.toString().padLeft(2, '0')}';
  final monthDetails = details
      .where((item) => item.transaction.competenceMonth == currentMonth)
      .toList(growable: false);
  final summary = buildDashboardSummary(
    monthDetails.map((item) => item.transaction).toList(growable: false),
  );

  final commitmentCents =
      recurringSchedules
          .where((schedule) => schedule.active)
          .fold<int>(0, (sum, item) => sum + item.amountCents.abs()) +
      installmentPlans
          .where((plan) => plan.active)
          .fold<int>(0, (sum, item) => sum + item.installmentAmountCents.abs());

  return DashboardSummary(
    incomeCents: summary.incomeCents,
    expenseCents: summary.expenseCents,
    pendingCount: summary.pendingCount,
    transferCount: monthDetails
        .where((item) => item.transaction.kind == 'transfer')
        .length,
    transferCents: monthDetails
        .where((item) => item.transaction.kind == 'transfer')
        .fold<int>(0, (sum, item) => sum + item.transaction.amountCents.abs()),
    pendingCents: monthDetails
        .where((item) => item.transaction.reviewStatus == 'pending')
        .fold<int>(0, (sum, item) => sum + item.transaction.amountCents),
    futureCommitmentCents: commitmentCents,
    byPerson: _breakdown(
      monthDetails,
      labelFor: (item) => item.beneficiaries.isEmpty
          ? 'Sem beneficiario'
          : item.beneficiaries.map((person) => person.displayName).join(', '),
    ),
    byCategory: _breakdown(
      monthDetails,
      labelFor: (item) => item.category?.name ?? 'Sem categoria',
    ),
    byCostCenter: _breakdown(
      monthDetails,
      labelFor: (item) => item.costCenter?.name ?? 'Sem centro',
    ),
    bySource: _breakdown(
      monthDetails,
      labelFor: (item) => item.sourceLabel,
      includeTransfers: true,
    ),
  );
}

List<SummaryBreakdownItem> _breakdown(
  List<ReviewTransactionDetails> details, {
  required String Function(ReviewTransactionDetails item) labelFor,
  bool includeTransfers = false,
}) {
  final amounts = <String, int>{};
  final counts = <String, int>{};

  for (final item in details) {
    final tx = item.transaction;
    if (!includeTransfers && tx.kind == 'transfer') {
      continue;
    }
    final label = labelFor(item);
    amounts[label] = (amounts[label] ?? 0) + tx.amountCents;
    counts[label] = (counts[label] ?? 0) + 1;
  }

  final items = [
    for (final entry in amounts.entries)
      SummaryBreakdownItem(
        label: entry.key,
        amountCents: entry.value,
        count: counts[entry.key] ?? 0,
      ),
  ];
  items.sort(
    (left, right) => right.amountCents.abs().compareTo(left.amountCents.abs()),
  );
  return items;
}
