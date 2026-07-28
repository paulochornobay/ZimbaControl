import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart';
import 'edit_transaction_page.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FinanceTransaction>>(
      stream: database.watchPendingReview(),
      builder: (context, snapshot) {
        final transactions = snapshot.data ?? const <FinanceTransaction>[];

        return Scaffold(
          appBar: AppBar(
            title: Text('Caixa de revisao (${transactions.length})'),
          ),
          body: transactions.isEmpty
              ? const Center(child: Text('Nada pendente por enquanto.'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return ReviewTransactionCard(
                      transaction: transaction,
                      onConfirm: () =>
                          database.confirmTransaction(transaction.id),
                      onIgnore: () =>
                          database.ignoreTransaction(transaction.id),
                      onDuplicate: () =>
                          database.markProbableDuplicate(transaction.id),
                      onEdit: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => EditTransactionPage(
                              database: database,
                              transactionId: transaction.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemCount: transactions.length,
                ),
        );
      },
    );
  }
}

class ReviewTransactionCard extends StatelessWidget {
  const ReviewTransactionCard({
    required this.transaction,
    required this.onConfirm,
    required this.onIgnore,
    required this.onDuplicate,
    required this.onEdit,
    super.key,
  });

  final FinanceTransaction transaction;
  final VoidCallback onConfirm;
  final VoidCallback onIgnore;
  final VoidCallback onDuplicate;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ReviewBadge(label: transaction.kind),
                const SizedBox(width: 8),
                ReviewBadge(
                  label: '${(transaction.sourceConfidence * 100).round()}%',
                ),
                if (transaction.duplicateStatus != 'none') ...[
                  const SizedBox(width: 8),
                  ReviewBadge(label: transaction.duplicateStatus),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              transaction.descriptionRaw,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(formatBrl(transaction.amountCents)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: onConfirm,
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmar'),
                ),
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar'),
                ),
                OutlinedButton.icon(
                  onPressed: onDuplicate,
                  icon: const Icon(Icons.merge_outlined),
                  label: const Text('Duplicado'),
                ),
                TextButton.icon(
                  onPressed: onIgnore,
                  icon: const Icon(Icons.close),
                  label: const Text('Ignorar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewBadge extends StatelessWidget {
  const ReviewBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(label, style: Theme.of(context).textTheme.labelSmall),
      ),
    );
  }
}
