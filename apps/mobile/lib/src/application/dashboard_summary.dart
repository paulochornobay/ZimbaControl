import '../data/local/app_database.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.incomeCents,
    required this.expenseCents,
    required this.pendingCount,
  });

  final int incomeCents;
  final int expenseCents;
  final int pendingCount;

  int get balanceCents => incomeCents + expenseCents;
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
