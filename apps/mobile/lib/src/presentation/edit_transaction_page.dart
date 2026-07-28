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

  FinanceTransaction? transaction;
  List<CategoryRow> categories = const [];
  List<CostCenterRow> costCenters = const [];
  String kind = 'expense';
  String? categoryId;
  String? costCenterId;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    final loadedTransaction = await widget.database.getTransaction(
      widget.transactionId,
    );
    final loadedCategories = await widget.database.listCategories();
    final loadedCostCenters = await widget.database.listCostCenters();

    if (!mounted) {
      return;
    }

    setState(() {
      transaction = loadedTransaction;
      categories = loadedCategories;
      costCenters = loadedCostCenters;
      descriptionController.text = loadedTransaction?.descriptionRaw ?? '';
      amountController.text = loadedTransaction == null
          ? ''
          : centsToInput(loadedTransaction.amountCents);
      kind = loadedTransaction?.kind ?? 'expense';
      categoryId = loadedTransaction?.categoryId;
      costCenterId = loadedTransaction?.costCenterId;
      loading = false;
    });
  }

  Future<void> save() async {
    final parsedCents = parseBrlInput(amountController.text);
    final signedCents = kind == 'expense' && parsedCents > 0
        ? -parsedCents
        : parsedCents;

    await widget.database.updateTransactionCore(
      id: widget.transactionId,
      description: descriptionController.text.trim(),
      amountCents: signedCents,
      kind: kind,
      categoryId: categoryId,
      costCenterId: costCenterId,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
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

    return Scaffold(
      appBar: AppBar(title: const Text('Editar lancamento')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descricao',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Valor em centavos ou BRL',
              helperText: 'Ex.: 487,32 ou -48732',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'expense', label: Text('Despesa')),
              ButtonSegment(value: 'income', label: Text('Receita')),
              ButtonSegment(value: 'transfer', label: Text('Transferencia')),
            ],
            selected: {kind},
            onSelectionChanged: (selection) {
              setState(() => kind = selection.first);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            initialValue: categoryId,
            decoration: const InputDecoration(
              labelText: 'Categoria',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Sem categoria')),
              for (final category in categories)
                DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                ),
            ],
            onChanged: (value) => setState(() => categoryId = value),
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
              for (final costCenter in costCenters)
                DropdownMenuItem(
                  value: costCenter.id,
                  child: Text(costCenter.name),
                ),
            ],
            onChanged: (value) => setState(() => costCenterId = value),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Salvar localmente'),
          ),
          const SizedBox(height: 8),
          Text(
            'Esta tela e funcional e simples. O refinamento visual deve vir do Lovable.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
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
