import 'package:flutter/material.dart';

import '../application/dashboard_summary.dart';
import '../data/local/app_database.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FinanceTransaction>>(
      stream: database.watchRecentTransactions(),
      builder: (context, snapshot) {
        final transactions = snapshot.data ?? const <FinanceTransaction>[];
        final pending = transactions
            .where((tx) => tx.reviewStatus == 'pending')
            .toList(growable: false);
        final summary = buildDashboardSummary(transactions);

        return Scaffold(
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Julho'),
                Text(
                  'Visao da familia',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
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
              SummaryCard(summary: summary),
              const SizedBox(height: 16),
              PendingReviewCard(
                count: pending.length,
                onConfirmFirst: pending.isEmpty
                    ? null
                    : () => database.confirmTransaction(pending.first.id),
              ),
              const SizedBox(height: 16),
              PeopleSection(database: database),
              const SizedBox(height: 16),
              Text('Recentes', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              for (final tx in transactions)
                TransactionTile(
                  transaction: tx,
                  onConfirm: tx.reviewStatus == 'pending'
                      ? () => database.confirmTransaction(tx.id)
                      : null,
                ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.inbox_outlined),
                label: 'Revisao',
              ),
              NavigationDestination(
                icon: Icon(Icons.tune_outlined),
                label: 'Filtros',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                label: 'Ajustes',
              ),
            ],
          ),
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
        padding: const EdgeInsets.all(20),
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
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
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

class PendingReviewCard extends StatelessWidget {
  const PendingReviewCard({
    required this.count,
    required this.onConfirmFirst,
    super.key,
  });

  final int count;
  final VoidCallback? onConfirmFirst;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text('$count lancamentos aguardando revisao'),
        subtitle: const Text('Dados locais primeiro, sync depois'),
        trailing: FilledButton.icon(
          onPressed: onConfirmFirst,
          icon: const Icon(Icons.check),
          label: const Text('Confirmar'),
        ),
      ),
    );
  }
}

class PeopleSection extends StatelessWidget {
  const PeopleSection({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PersonRow>>(
      stream: database.watchPeople(),
      builder: (context, snapshot) {
        final people = snapshot.data ?? const <PersonRow>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Por pessoa', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final person in people)
                  Chip(
                    label: Text(person.displayName),
                    avatar: CircleAvatar(
                      child: Text(person.displayName.characters.first),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.transaction,
    required this.onConfirm,
    super.key,
  });

  final FinanceTransaction transaction;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.amountCents > 0;
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text(transaction.descriptionRaw),
        subtitle: Text(
          '${transaction.reviewStatus} · confianca '
          '${(transaction.sourceConfidence * 100).round()}%',
        ),
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? Colors.green.shade50
              : Colors.blue.shade50,
          child: Icon(
            isIncome ? Icons.trending_up : Icons.trending_down,
            color: isIncome ? Colors.green : Colors.blue,
          ),
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text(
              formatBrl(transaction.amountCents),
              style: TextStyle(
                fontWeight: FontWeight.w700,
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
        borderRadius: BorderRadius.circular(16),
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
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

String formatBrl(int cents) {
  final sign = cents < 0 ? '-' : '';
  final value = cents.abs();
  final reais = value ~/ 100;
  final centavos = (value % 100).toString().padLeft(2, '0');
  final reaisText = reais.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]}.',
  );
  return '${sign}R\$ $reaisText,$centavos';
}
