import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo lançamento')),
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
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: Theme.of(context).textTheme.headlineMedium,
                      decoration: const InputDecoration(
                        prefixText: 'R\$ ',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SegmentedButton<String>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(value: 'expense', label: Text('Despesa')),
                        ButtonSegment(value: 'income', label: Text('Receita')),
                        ButtonSegment(
                          value: 'transfer',
                          label: Text('Transfer.'),
                        ),
                      ],
                      selected: {kind},
                      onSelectionChanged: (value) {
                        setState(() => kind = value.first);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const ZimbaSectionTitle('Descrição'),
              TextField(
                controller: descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Ex.: Padaria da esquina',
                ),
              ),
              const SizedBox(height: 20),
              const ZimbaSectionTitle('Conta'),
              _OptionWrap(
                children: [
                  for (final item in registry.accounts)
                    ChoiceChip(
                      label: Text(item.account.name),
                      selected: accountId == item.account.id,
                      onSelected: (_) =>
                          setState(() => accountId = item.account.id),
                    ),
                ],
              ),
              if (kind != 'transfer') ...[
                const SizedBox(height: 20),
                const ZimbaSectionTitle('Categoria'),
                _OptionWrap(
                  children: [
                    for (final category in registry.categories.where(
                      (item) => item.kind == kind,
                    ))
                      ChoiceChip(
                        label: Text(category.name),
                        selected: categoryId == category.id,
                        onSelected: (selected) => setState(
                          () => categoryId = selected ? category.id : null,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                const ZimbaSectionTitle('Centro de custo'),
                _OptionWrap(
                  children: [
                    for (final center in registry.costCenters)
                      ChoiceChip(
                        label: Text(center.name),
                        selected: costCenterId == center.id,
                        onSelected: (selected) => setState(
                          () => costCenterId = selected ? center.id : null,
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
                    FilterChip(
                      label: Text(person.displayName),
                      selected: beneficiaryIds.contains(person.id),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
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
