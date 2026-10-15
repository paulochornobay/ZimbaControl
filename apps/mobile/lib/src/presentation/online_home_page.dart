import 'package:flutter/material.dart';

import '../infrastructure/online_finance_client.dart';
import 'design/zimba_theme.dart';

/// Online-only financial home. Every read and write goes through the API.
class OnlineHomePage extends StatefulWidget {
  const OnlineHomePage({
    required this.client,
    required this.email,
    required this.onSignOut,
    super.key,
  });

  final OnlineFinanceClient client;
  final String email;
  final Future<void> Function() onSignOut;

  @override
  State<OnlineHomePage> createState() => _OnlineHomePageState();
}

class _OnlineHomePageState extends State<OnlineHomePage> {
  late Future<List<OnlineEntitySnapshot>> _transactions = _load();

  Future<List<OnlineEntitySnapshot>> _load() => widget.client.listTransactions();

  void _refresh() => setState(() => _transactions = _load());

  Future<void> _openCreateTransaction() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _OnlineTransactionForm(client: widget.client),
    );
    if (created == true && mounted) _refresh();
  }

  Future<void> _openRegistries() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _OnlineRegistriesSheet(client: widget.client),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZimbaControl'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: () async => widget.onSignOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateTransaction,
        icon: const Icon(Icons.add),
        label: const Text('Lançamento'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) _openRegistries();
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Resumo'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Cadastros'),
        ],
      ),
      body: FutureBuilder<List<OnlineEntitySnapshot>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return _OfflineState(onRetry: _refresh);
          final rows = snapshot.data ?? const <OnlineEntitySnapshot>[];
          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: _OnlineDashboard(
              email: widget.email,
              rows: rows,
              onCreateTransaction: _openCreateTransaction,
            ),
          );
        },
      ),
    );
  }
}

class _OnlineDashboard extends StatelessWidget {
  const _OnlineDashboard({
    required this.email,
    required this.rows,
    required this.onCreateTransaction,
  });

  final String email;
  final List<OnlineEntitySnapshot> rows;
  final VoidCallback onCreateTransaction;

  @override
  Widget build(BuildContext context) {
    var income = 0;
    var expense = 0;
    for (final snapshot in rows) {
      final transaction = snapshot.payload['transaction'];
      final row = transaction is Map<Object?, Object?>
          ? Map<String, Object?>.from(transaction)
          : const <String, Object?>{};
      final amount = row['amountCents'] as int? ?? 0;
      if (amount >= 0) {
        income += amount;
      } else {
        expense += amount;
      }
    }
    final balance = income + expense;
    final name = email.split('@').first;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 104),
      children: [
        Text('Olá, $name', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        const Text('Visão geral da sua conta online', style: TextStyle(color: ZimbaColors.secondaryText)),
        const SizedBox(height: 18),
        Card(
          color: ZimbaColors.primary,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo disponível', style: TextStyle(color: Color(0xFFCBD5E1), fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  _formatCents(balance),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _Metric(label: 'Receitas', value: _formatCents(income), color: const Color(0xFF86EFAC))),
                    Container(width: 1, height: 38, color: const Color(0xFF334155)),
                    Expanded(child: _Metric(label: 'Despesas', value: _formatCents(expense.abs()), color: const Color(0xFFFDA4AF))),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(rows.isEmpty ? 'Comece por aqui' : 'Lançamentos recentes', style: Theme.of(context).textTheme.titleMedium),
            if (rows.isNotEmpty) Text('${rows.length} no total', style: const TextStyle(fontSize: 12, color: ZimbaColors.secondaryText)),
          ],
        ),
        const SizedBox(height: 10),
        if (rows.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: ZimbaColors.accentSoft, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.add_chart_outlined, color: ZimbaColors.accent),
                  ),
                  const SizedBox(height: 16),
                  Text('Registre seu primeiro lançamento', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  const Text('Ele será salvo imediatamente na sua conta MongoDB e aparecerá também no web.'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: onCreateTransaction,
                    icon: const Icon(Icons.add),
                    label: const Text('Cadastrar lançamento'),
                  ),
                ],
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: [
                for (var index = 0; index < rows.length; index++) ...[
                  _TransactionRow(snapshot: rows[index]),
                  if (index < rows.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11)),
            const SizedBox(height: 3),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

class _OnlineRegistriesSheet extends StatelessWidget {
  const _OnlineRegistriesSheet({required this.client});

  final OnlineFinanceClient client;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: FutureBuilder<List<List<OnlineEntitySnapshot>>>(
          future: Future.wait([client.listEntities('account'), client.listEntities('category')]),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(height: 240, child: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasError) {
              return const SizedBox(
                height: 240,
                child: Center(child: Text('Sem conexão para consultar os cadastros.')),
              );
            }
            final accounts = snapshot.data![0];
            final categories = snapshot.data![1];
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cadastros online', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                const Text('Consultados diretamente na sua conta; nada é lido do aparelho.'),
                const SizedBox(height: 20),
                _RegistryGroup(
                  icon: Icons.account_balance_outlined,
                  title: 'Contas e cartões',
                  rows: accounts.map(_registryLabel).toList(growable: false),
                  empty: 'Nenhuma conta cadastrada ainda.',
                ),
                const SizedBox(height: 18),
                _RegistryGroup(
                  icon: Icons.sell_outlined,
                  title: 'Categorias',
                  rows: categories.map(_registryLabel).toList(growable: false),
                  empty: 'Nenhuma categoria cadastrada.',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _registryLabel(OnlineEntitySnapshot snapshot) {
    for (final value in snapshot.payload.values) {
      if (value is Map<Object?, Object?> && value['name'] is String) return value['name']! as String;
      if (value is Map<Object?, Object?> && value['label'] is String) return value['label']! as String;
    }
    return snapshot.entityId;
  }
}

class _RegistryGroup extends StatelessWidget {
  const _RegistryGroup({
    required this.icon,
    required this.title,
    required this.rows,
    required this.empty,
  });

  final IconData icon;
  final String title;
  final List<String> rows;
  final String empty;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 18, color: ZimbaColors.accent), const SizedBox(width: 8), Text(title, style: Theme.of(context).textTheme.titleSmall)]),
          const SizedBox(height: 8),
          Card(
            child: rows.isEmpty
                ? Padding(padding: const EdgeInsets.all(14), child: Text(empty, style: const TextStyle(color: ZimbaColors.secondaryText)))
                : Column(
                    children: [
                      for (var index = 0; index < rows.length; index++) ...[
                        ListTile(dense: true, title: Text(rows[index])),
                        if (index < rows.length - 1) const Divider(height: 1),
                      ],
                    ],
                  ),
          ),
        ],
      );
}

String _formatCents(int cents) {
  final absolute = (cents.abs() / 100).toStringAsFixed(2).replaceAll('.', ',');
  return '${cents < 0 ? '-' : ''}R\$ $absolute';
}

class _OnlineTransactionForm extends StatefulWidget {
  const _OnlineTransactionForm({required this.client});

  final OnlineFinanceClient client;

  @override
  State<_OnlineTransactionForm> createState() => _OnlineTransactionFormState();
}

class _OnlineTransactionFormState extends State<_OnlineTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  var _isExpense = true;
  var _date = DateUtils.dateOnly(DateTime.now());
  var _saving = false;
  String? _error;

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null && mounted) setState(() => _date = selected);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final cents = _parseCents(_amount.text);
    if (cents == null || cents == 0) {
      setState(() => _error = 'Informe um valor maior que zero.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final id = 'transaction-${DateTime.now().microsecondsSinceEpoch}';
    final now = DateTime.now().toUtc().toIso8601String();
    final occurredAt = DateTime(_date.year, _date.month, _date.day, 12).toUtc().toIso8601String();
    final competence = '${_date.year.toString().padLeft(4, '0')}-${_date.month.toString().padLeft(2, '0')}';
    try {
      await widget.client.createTransaction(
        entityId: id,
        payload: {
          'schemaVersion': 1,
          'transaction': {
            'id': id,
            // The API overwrites scope from the bearer token.
            'householdId': 'resolved-by-server',
            'kind': _isExpense ? 'expense' : 'income',
            'reviewStatus': 'confirmed',
            'duplicateStatus': 'none',
            'occurredAt': occurredAt,
            'postedAt': null,
            'competenceMonth': competence,
            'amountCents': _isExpense ? -cents : cents,
            'currencyCode': 'BRL',
            'descriptionRaw': _description.text.trim(),
            'displayDescription': null,
            'accountId': null,
            'transferFromAccountId': null,
            'transferToAccountId': null,
            'recurringScheduleId': null,
            'installmentPlanId': null,
            'merchantId': null,
            'categoryId': null,
            'costCenterId': null,
            'payerId': null,
            'appliedRuleId': null,
            'sourceConfidence': 1,
            'updatedAt': now,
            'deletedAt': null,
          },
          'beneficiaries': <Object?>[],
          'sources': <Object?>[],
        },
      );
      if (mounted) Navigator.of(context).pop(true);
    } on OnlineFinanceException catch (exception) {
      if (mounted) setState(() => _error = _messageFor(exception));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, bottom + 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Cadastrar lançamento', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 18),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Despesa'), icon: Icon(Icons.remove)),
                  ButtonSegment(value: false, label: Text('Receita'), icon: Icon(Icons.add)),
                ],
                selected: {_isExpense},
                onSelectionChanged: (value) => setState(() => _isExpense = value.first),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _description,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Informe a descrição.' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Valor', prefixText: 'R\$ '),
                validator: (value) => _parseCents(value ?? '') == null ? 'Informe um valor válido.' : null,
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _selectDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text('${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}'),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 14),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Salvando…' : 'Salvar online'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int? _parseCents(String raw) {
    final compact = raw.trim().replaceAll(RegExp(r'\s+'), '');
    final normalized = compact.contains(',')
        ? compact.replaceAll('.', '').replaceAll(',', '.')
        : compact;
    final value = double.tryParse(normalized);
    if (value == null || value <= 0) return null;
    return (value * 100).round();
  }

  String _messageFor(OnlineFinanceException exception) {
    if (exception.code == 'network_unavailable') return 'Sem conexão. O lançamento não foi salvo.';
    if (exception.code.startsWith('session_rejected')) return 'Sua sessão expirou. Entre novamente.';
    return 'Não foi possível salvar agora. Tente novamente.';
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.snapshot});

  final OnlineEntitySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final transaction = snapshot.payload['transaction'];
    final row = transaction is Map<Object?, Object?>
        ? Map<String, Object?>.from(transaction)
        : const <String, Object?>{};
    final amount = row['amountCents'] as int? ?? 0;
    final description = row['displayDescription'] ?? row['descriptionRaw'] ?? 'Lançamento';
    final occurredAt = row['occurredAt'] as String? ?? '';
    final isExpense = amount < 0;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      title: Text('$description'),
      subtitle: Text(occurredAt),
      trailing: Text(
        '${isExpense ? '-' : '+'}R\$ ${(amount.abs() / 100).toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isExpense ? Theme.of(context).colorScheme.error : Colors.green.shade700,
        ),
      ),
    );
  }
}

class _OfflineState extends StatelessWidget {
  const _OfflineState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 44),
              const SizedBox(height: 14),
              Text('Sem conexão com seus dados', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              const Text(
                'Nenhum dado financeiro é mantido neste aparelho. Conecte-se para consultar ou alterar seus lançamentos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton(onPressed: onRetry, child: const Text('Tentar novamente')),
            ],
          ),
        ),
      );
}
