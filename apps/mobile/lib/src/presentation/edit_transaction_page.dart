import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

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
        toolbarHeight: 82,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Editar lançamento',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(letterSpacing: -.5),
            ),
            const SizedBox(height: 3),
            Text(
              'Classificação completa',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ZimbaColors.secondaryText,
                fontWeight: FontWeight.w400,
              ),
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
        children: [
          _SectionCard(
            title: 'Valor',
            icon: Icons.payments_outlined,
            child: Column(
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: const InputDecoration(
                    prefixText: 'R\$ ',
                    helperText: 'Ex.: 487,32 ou -48732',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                _EditKindPicker(
                  selected: kind,
                  onSelected: (value) => setState(() => kind = value),
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
                  isExpanded: true,
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
                  isExpanded: true,
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
                  isExpanded: true,
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
                  isExpanded: true,
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
                  _EditChoice(
                    label: person.displayName,
                    selected: beneficiaryIds.contains(person.id),
                    onTap: () {
                      setState(() {
                        final next = beneficiaryIds.toSet();
                        if (!next.contains(person.id)) {
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

class _EditKindPicker extends StatelessWidget {
  const _EditKindPicker({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const options = [
      ('expense', 'Despesa', Icons.trending_down, ZimbaTone.danger),
      ('income', 'Receita', Icons.trending_up, ZimbaTone.success),
      ('transfer', 'Transferência', Icons.compare_arrows, ZimbaTone.accent),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 380;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var index = 0; index < options.length; index++)
              SizedBox(
                width: narrow && index == options.length - 1
                    ? constraints.maxWidth
                    : narrow
                    ? (constraints.maxWidth - 8) / 2
                    : (constraints.maxWidth - 16) / 3,
                child: _EditKindButton(
                  label: options[index].$2,
                  icon: options[index].$3,
                  selected: selected == options[index].$1,
                  tone: options[index].$4,
                  onTap: () => onSelected(options[index].$1),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EditKindButton extends StatelessWidget {
  const _EditKindButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.tone,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final ZimbaTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      ZimbaTone.danger => (
        ZimbaColors.destructiveSoft,
        ZimbaColors.destructive,
      ),
      ZimbaTone.success => (ZimbaColors.successSoft, ZimbaColors.success),
      _ => (ZimbaColors.accentSoft, ZimbaColors.accent),
    };
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 40,
          decoration: BoxDecoration(
            color: selected ? colors.$1 : ZimbaColors.surfaceMuted,
            border: Border.all(
              color: selected ? colors.$2 : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? colors.$2 : ZimbaColors.secondaryText,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected ? colors.$2 : ZimbaColors.secondaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditChoice extends StatelessWidget {
  const _EditChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? ZimbaColors.accentSoft : ZimbaColors.surface,
            border: Border.all(
              color: selected ? ZimbaColors.accent : ZimbaColors.border,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected
                    ? ZimbaColors.accent
                    : ZimbaColors.secondaryText,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ZimbaCard(
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
