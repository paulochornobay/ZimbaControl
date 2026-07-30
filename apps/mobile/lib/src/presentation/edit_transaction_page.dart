import 'package:flutter/material.dart';

import '../data/local/app_database.dart';

class EditTransactionPage extends StatefulWidget {
  const EditTransactionPage({
    required this.database,
    required this.transactionId,
    super.key,
  });

  final AppDatabase database;
  final String transactionId;

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final competenceController = TextEditingController();

  FinanceTransaction? transaction;
  List<CategoryRow> categories = const [];
  List<CostCenterRow> costCenters = const [];
  List<AccountWithOwner> accounts = const [];
  List<PersonRow> people = const [];
  Set<String> beneficiaryIds = const {};
  String kind = 'expense';
  String? accountId;
  String? categoryId;
  String? costCenterId;
  String? payerId;
  DateTime occurredAt = DateTime.now();
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    competenceController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    final loadedTransaction = await widget.database.getTransaction(
      widget.transactionId,
    );
    final loadedCategories = await widget.database.listCategories(
      includeInactive: true,
    );
    final loadedCostCenters = await widget.database.listCostCenters(
      includeInactive: true,
    );
    final loadedAccounts = await widget.database.listAccountsWithOwners(
      includeInactive: true,
    );
    final loadedPeople = await widget.database.watchPeople().first;
    final loadedDetails = await widget.database
        .watchAllTransactionDetails()
        .first;
    ReviewTransactionDetails? details;
    for (final item in loadedDetails) {
      if (item.transaction.id == widget.transactionId) {
        details = item;
        break;
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      transaction = loadedTransaction;
      categories = loadedCategories;
      costCenters = loadedCostCenters;
      accounts = loadedAccounts;
      people = loadedPeople;
      descriptionController.text = loadedTransaction?.descriptionRaw ?? '';
      amountController.text = loadedTransaction == null
          ? ''
          : centsToInput(loadedTransaction.amountCents);
      kind = loadedTransaction?.kind ?? 'expense';
      accountId = loadedTransaction?.accountId;
      categoryId = loadedTransaction?.categoryId;
      costCenterId = loadedTransaction?.costCenterId;
      payerId = loadedTransaction?.payerId;
      occurredAt = loadedTransaction?.occurredAt ?? DateTime.now();
      competenceController.text =
          loadedTransaction?.competenceMonth ?? monthKey(occurredAt);
      beneficiaryIds = {
        for (final person in details?.beneficiaries ?? const <PersonRow>[])
          person.id,
      };
      loading = false;
    });
  }

  Future<void> save({bool closeAfterSave = true}) async {
    final parsedCents = parseBrlInput(amountController.text);
    final fallbackPayerId =
        payerId ?? (people.isEmpty ? null : people.first.id);
    final selectedBeneficiaries =
        beneficiaryIds.isEmpty && fallbackPayerId != null
        ? [fallbackPayerId]
        : beneficiaryIds.toList();

    setState(() => saving = true);
    await widget.database.updateTransactionDetails(
      id: widget.transactionId,
      description: descriptionController.text.trim().isEmpty
          ? 'Lancamento sem descricao'
          : descriptionController.text.trim(),
      amountCents: parsedCents,
      kind: kind,
      occurredAt: occurredAt,
      competenceMonth: competenceController.text.trim().isEmpty
          ? monthKey(occurredAt)
          : competenceController.text.trim(),
      accountId: accountId,
      categoryId: kind == 'transfer' ? null : categoryId,
      costCenterId: kind == 'transfer' ? null : costCenterId,
      payerId: fallbackPayerId,
      beneficiaryIds: selectedBeneficiaries,
    );

    if (!mounted) {
      return;
    }

    setState(() => saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lancamento salvo localmente.')),
    );
    if (closeAfterSave) {
      Navigator.of(context).pop();
    }
  }

  Future<void> pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: occurredAt,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (selected == null) {
      return;
    }
    setState(() {
      occurredAt = selected;
      competenceController.text = monthKey(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar lancamento')),
        body: const Center(child: Text('Lancamento nao encontrado')),
      );
    }

    final visibleAccounts = accounts
        .where((item) => item.account.active || item.account.id == accountId)
        .toList(growable: false);
    final visibleCategories = categories
        .where((item) => item.active || item.id == categoryId)
        .toList(growable: false);
    final visibleCostCenters = costCenters
        .where((item) => item.active || item.id == costCenterId)
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Editar lancamento'),
            Text(
              'Classificacao completa',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Salvar',
            onPressed: saving ? null : save,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          _SectionCard(
            title: 'Valor',
            icon: Icons.payments_outlined,
            child: Column(
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: const InputDecoration(
                    prefixText: 'R\$ ',
                    helperText: 'Ex.: 487,32 ou -48732',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'expense',
                      label: Text('Despesa'),
                      icon: Icon(Icons.trending_down),
                    ),
                    ButtonSegment(
                      value: 'income',
                      label: Text('Receita'),
                      icon: Icon(Icons.trending_up),
                    ),
                    ButtonSegment(
                      value: 'transfer',
                      label: Text('Transfer.'),
                      icon: Icon(Icons.compare_arrows),
                    ),
                  ],
                  selected: {kind},
                  onSelectionChanged: (selection) {
                    setState(() => kind = selection.first);
                  },
                ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Descricao e data',
            icon: Icons.edit_note_outlined,
            child: Column(
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descricao',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: pickDate,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(formatInputDate(occurredAt)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: competenceController,
                        decoration: const InputDecoration(
                          labelText: 'Competencia',
                          helperText: 'AAAA-MM',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Conta e responsaveis',
            icon: Icons.account_balance_wallet_outlined,
            child: Column(
              children: [
                DropdownButtonFormField<String?>(
                  initialValue: accountId,
                  decoration: const InputDecoration(
                    labelText: 'Conta / cartao',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Sem conta definida'),
                    ),
                    for (final item in visibleAccounts)
                      DropdownMenuItem(
                        value: item.account.id,
                        child: Text(
                          '${item.account.name} · ${_accountTypeLabel(item.account.type)}',
                        ),
                      ),
                  ],
                  onChanged: (value) => setState(() => accountId = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: payerId,
                  decoration: const InputDecoration(
                    labelText: 'Pagador',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Sem pagador'),
                    ),
                    for (final person in people)
                      DropdownMenuItem(
                        value: person.id,
                        child: Text(person.displayName),
                      ),
                  ],
                  onChanged: (value) => setState(() => payerId = value),
                ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Classificacao',
            icon: Icons.category_outlined,
            child: Column(
              children: [
                DropdownButtonFormField<String?>(
                  initialValue: categoryId,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Sem categoria'),
                    ),
                    for (final category in visibleCategories)
                      DropdownMenuItem(
                        value: category.id,
                        child: Text(
                          category.active
                              ? category.name
                              : '${category.name} (arquivada)',
                        ),
                      ),
                  ],
                  onChanged: kind == 'transfer'
                      ? null
                      : (value) => setState(() => categoryId = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: costCenterId,
                  decoration: const InputDecoration(
                    labelText: 'Centro de custo',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Sem centro de custo'),
                    ),
                    for (final costCenter in visibleCostCenters)
                      DropdownMenuItem(
                        value: costCenter.id,
                        child: Text(
                          costCenter.active
                              ? costCenter.name
                              : '${costCenter.name} (arquivado)',
                        ),
                      ),
                  ],
                  onChanged: kind == 'transfer'
                      ? null
                      : (value) => setState(() => costCenterId = value),
                ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Beneficiarios',
            icon: Icons.people_alt_outlined,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final person in people)
                  FilterChip(
                    label: Text(person.displayName),
                    selected: beneficiaryIds.contains(person.id),
                    onSelected: (selected) {
                      setState(() {
                        final next = beneficiaryIds.toSet();
                        if (selected) {
                          next.add(person.id);
                        } else {
                          next.remove(person.id);
                        }
                        beneficiaryIds = next;
                      });
                    },
                  ),
              ],
            ),
          ),
          if (saving) const LinearProgressIndicator(),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: saving ? null : save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Salvar localmente'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

String centsToInput(int cents) {
  final sign = cents < 0 ? '-' : '';
  final value = cents.abs();
  final reais = value ~/ 100;
  final centavos = (value % 100).toString().padLeft(2, '0');
  return '$sign$reais,$centavos';
}

int parseBrlInput(String input) {
  final normalized = input.trim();
  if (normalized.isEmpty) {
    return 0;
  }

  if (!normalized.contains(',') && !normalized.contains('.')) {
    return int.tryParse(normalized) ?? 0;
  }

  final sign = normalized.startsWith('-') ? -1 : 1;
  final digits = normalized.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) {
    return 0;
  }

  final padded = digits.padLeft(3, '0');
  final reais = int.parse(padded.substring(0, padded.length - 2));
  final centavos = int.parse(padded.substring(padded.length - 2));
  return sign * ((reais * 100) + centavos);
}

String monthKey(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}';
}

String formatInputDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

String _accountTypeLabel(String type) {
  return switch (type) {
    'credit_card' => 'Cartao',
    'account' => 'Conta',
    _ => type,
  };
}
