import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'design/instrument_display.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'registries_page.dart';

class NewTransactionPage extends StatefulWidget {
  const NewTransactionPage({
    required this.database,
    required this.onSaved,
    required this.onOpenSettings,
    super.key,
  });

  final AppDatabase database;
  final VoidCallback onSaved;
  final VoidCallback onOpenSettings;

  @override
  State<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  final amountController = TextEditingController(text: '0,00');
  final descriptionController = TextEditingController();
  late Future<_NewTransactionData> dataFuture;
  var kind = 'expense';
  String? accountId;
  String? categoryId;
  String? costCenterId;
  String? payerId;
  Set<String> beneficiaryIds = {};
  var saving = false;
  String? error;

  @override
  void initState() {
    super.initState();
    dataFuture = _load();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<_NewTransactionData> _load() async {
    final registry = await widget.database.getRegistrySnapshot(
      includeInactive: false,
    );
    final startup = await widget.database.getStartupState();
    accountId =
        registry.accounts.any(
          (item) => item.account.id == startup.primaryAccountId,
        )
        ? startup.primaryAccountId
        : registry.accounts.firstOrNull?.account.id;
    payerId =
        registry.people.any((person) => person.id == startup.primaryPersonId)
        ? startup.primaryPersonId
        : registry.people.firstOrNull?.id;
    if (payerId != null) {
      beneficiaryIds = {payerId!};
    }
    return _NewTransactionData(registry);
  }

  int? _amountCents() {
    var value = amountController.text
        .trim()
        .replaceAll('R\$', '')
        .replaceAll(' ', '');
    if (value.contains(',')) {
      value = value.replaceAll('.', '').replaceAll(',', '.');
    }
    final parsed = double.tryParse(value);
    return parsed == null ? null : (parsed.abs() * 100).round();
  }

  Future<void> save() async {
    final cents = _amountCents();
    if (cents == null ||
        cents == 0 ||
        descriptionController.text.trim().isEmpty ||
        accountId == null) {
      setState(() {
        error = 'Informe valor, descrição e conta.';
      });
      return;
    }
    setState(() {
      saving = true;
      error = null;
    });
    final needsReview = categoryId == null && kind != 'transfer';
    try {
      await widget.database.createManualTransaction(
        NewTransactionInput(
          kind: kind,
          amountCents: cents,
          description: descriptionController.text,
          accountId: accountId!,
          payerPersonId: payerId,
          categoryId: kind == 'transfer' ? null : categoryId,
          costCenterId: kind == 'transfer' ? null : costCenterId,
          beneficiaryIds: beneficiaryIds.toList(),
        ),
      );
      if (!mounted) return;
      amountController.text = '0,00';
      descriptionController.clear();
      setState(() {
        categoryId = null;
        costCenterId = null;
        saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            needsReview
                ? 'Lançamento enviado para revisão.'
                : 'Lançamento salvo.',
          ),
        ),
      );
      widget.onSaved();
    } catch (_) {
      if (mounted) {
        setState(() {
          saving = false;
          error = 'Não foi possível salvar o lançamento.';
        });
      }
    }
  }

  Future<void> createCategoryInline() async {
    final id = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => CategoryFormPage(
          database: widget.database,
          initialKind: kind == 'income' ? 'income' : 'expense',
        ),
      ),
    );
    if (id == null || !mounted) return;
    final registry = await widget.database.getRegistrySnapshot(
      includeInactive: false,
    );
    if (!mounted) return;
    setState(() {
      categoryId = id;
      dataFuture = Future.value(_NewTransactionData(registry));
    });
  }

  Future<void> createCostCenterInline() async {
    final id = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => CostCenterFormPage(database: widget.database),
      ),
    );
    if (id == null || !mounted) return;
    final registry = await widget.database.getRegistrySnapshot(
      includeInactive: false,
    );
    if (!mounted) return;
    setState(() {
      costCenterId = id;
      dataFuture = Future.value(_NewTransactionData(registry));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text(
          'Novo lançamento',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(letterSpacing: -.5),
        ),
      ),
      body: FutureBuilder<_NewTransactionData>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Não foi possível carregar.'));
          }
          final registry = snapshot.data!.registry;
          if (registry.accounts.isEmpty || registry.people.isEmpty) {
            return _MissingSetup(onOpenSettings: widget.onOpenSettings);
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 112),
            children: [
              ZimbaCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VALOR',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ZimbaColors.secondaryText,
                        letterSpacing: 0.7,
                      ),
                    ),
                    TextField(
                      key: const ValueKey('new-transaction-amount'),
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      decoration: const InputDecoration(
                        prefixText: 'R\$ ',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _TransactionKindPicker(
                      selected: kind,
                      onSelected: (value) => setState(() => kind = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const ZimbaSectionTitle('Descrição'),
              ZimbaCard(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  key: const ValueKey('new-transaction-description'),
                  controller: descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Ex.: Padaria da esquina',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const ZimbaSectionTitle('Conta'),
              Column(
                children: [
                  for (final item in registry.accounts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InstrumentChoice(
                        instrument: InstrumentDisplay.account(item),
                        selected: accountId == item.account.id,
                        onTap: () =>
                            setState(() => accountId = item.account.id),
                      ),
                    ),
                ],
              ),
              if (kind != 'transfer') ...[
                const SizedBox(height: 20),
                _SectionHeader(
                  title: 'Categoria',
                  actionLabel: 'Criar',
                  onAction: createCategoryInline,
                ),
                _OptionWrap(
                  children: [
                    for (final category in registry.categories.where(
                      (item) => item.kind == kind,
                    ))
                      _FormOption(
                        label: category.name,
                        leading: ClassificationBadge(
                          iconKey: category.iconKey,
                          colorKey: category.colorKey,
                          compact: true,
                        ),
                        selected: categoryId == category.id,
                        onTap: () => setState(
                          () => categoryId = categoryId == category.id
                              ? null
                              : category.id,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                _SectionHeader(
                  title: 'Centro de custo',
                  actionLabel: 'Criar',
                  onAction: createCostCenterInline,
                ),
                _OptionWrap(
                  children: [
                    for (final center in registry.costCenters)
                      _FormOption(
                        label: center.name,
                        leading: ClassificationBadge(
                          iconKey: center.iconKey,
                          colorKey: center.colorKey,
                          compact: true,
                        ),
                        selected: costCenterId == center.id,
                        onTap: () => setState(
                          () => costCenterId = costCenterId == center.id
                              ? null
                              : center.id,
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              const ZimbaSectionTitle('Beneficiários'),
              _OptionWrap(
                children: [
                  for (final person in registry.people)
                    _FormOption(
                      label: person.displayName,
                      selected: beneficiaryIds.contains(person.id),
                      onTap: () {
                        setState(() {
                          if (!beneficiaryIds.contains(person.id)) {
                            beneficiaryIds.add(person.id);
                          } else {
                            beneficiaryIds.remove(person.id);
                          }
                        });
                      },
                    ),
                ],
              ),
              if (error != null) ...[
                const SizedBox(height: 16),
                Text(
                  error!,
                  style: const TextStyle(color: ZimbaColors.destructive),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: saving ? null : save,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar lançamento'),
              ),
              if (saving) ...[
                const SizedBox(height: 14),
                const LinearProgressIndicator(),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _OptionWrap extends StatelessWidget {
  const _OptionWrap({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      padding: const EdgeInsets.all(12),
      child: Wrap(spacing: 8, runSpacing: 8, children: children),
    );
  }
}

class _TransactionKindPicker extends StatelessWidget {
  const _TransactionKindPicker({
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const options = [
      ('expense', 'Despesa', ZimbaTone.danger),
      ('income', 'Receita', ZimbaTone.success),
      ('transfer', 'Transferência', ZimbaTone.accent),
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
                child: _KindButton(
                  label: options[index].$2,
                  selected: selected == options[index].$1,
                  tone: options[index].$3,
                  onTap: () => onSelected(options[index].$1),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _KindButton extends StatelessWidget {
  const _KindButton({
    required this.label,
    required this.selected,
    required this.tone,
    required this.onTap,
  });

  final String label;
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
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected ? colors.$2 : ZimbaColors.secondaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormOption extends StatelessWidget {
  const _FormOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 6)],
                Flexible(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ZimbaSectionTitle(title)),
        TextButton.icon(
          onPressed: onAction,
          icon: const Icon(Icons.add, size: 18),
          label: Text(actionLabel),
        ),
      ],
    );
  }
}

class _MissingSetup extends StatelessWidget {
  const _MissingSetup({required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_balance_wallet_outlined, size: 44),
              const SizedBox(height: 14),
              Text(
                'Configure uma conta primeiro',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'O lançamento precisa de uma pessoa e uma conta reais.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: onOpenSettings,
                child: const Text('Abrir cadastros'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewTransactionData {
  const _NewTransactionData(this.registry);

  final RegistrySnapshot registry;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
