import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart' show formatBrl;
import 'design/instrument_display.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'registries_page.dart';

class EditTransactionPage extends StatefulWidget {
  const EditTransactionPage({
    required this.database,
    required this.transactionId,
    super.key,
    this.onNavigate,
  });

  final AppDatabase database;
  final String transactionId;
  final ValueChanged<int>? onNavigate;

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final competenceController = TextEditingController();

  FinanceTransaction? transaction;
  ReviewTransactionDetails? details;
  List<CategoryRow> categories = const [];
  List<CostCenterRow> costCenters = const [];
  List<AccountWithOwner> accounts = const [];
  List<PersonRow> people = const [];
  List<InstallmentPlanRow> installmentPlans = const [];
  Set<String> beneficiaryIds = const {};
  String kind = 'expense';
  String? accountId;
  String? categoryId;
  String? costCenterId;
  String? payerId;
  DateTime occurredAt = DateTime.now();
  bool loading = true;
  bool saving = false;
  bool editing = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    competenceController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    final results = await Future.wait<Object?>([
      widget.database.getTransaction(widget.transactionId),
      widget.database.listCategories(includeInactive: true),
      widget.database.listCostCenters(includeInactive: true),
      widget.database.listAccountsWithOwners(includeInactive: true),
      widget.database.listPeople(),
      widget.database.listInstallmentPlans(),
    ]);
    final loadedTransaction = results[0] as FinanceTransaction?;

    if (!mounted) return;
    setState(() {
      transaction = loadedTransaction;
      categories = results[1] as List<CategoryRow>;
      costCenters = results[2] as List<CostCenterRow>;
      accounts = results[3] as List<AccountWithOwner>;
      people = results[4] as List<PersonRow>;
      installmentPlans = results[5] as List<InstallmentPlanRow>;
      titleController.text =
          loadedTransaction?.displayDescription ??
          loadedTransaction?.descriptionRaw ??
          '';
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
        if (loadedTransaction?.payerId != null) loadedTransaction!.payerId!,
      };
      loading = false;
    });
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final allDetails = await widget.database.watchAllTransactionDetails().first;
    final loadedDetail = allDetails
        .where((item) => item.transaction.id == widget.transactionId)
        .firstOrNull;
    if (!mounted || loadedDetail == null) return;
    setState(() {
      details = loadedDetail;
      beneficiaryIds = {
        for (final person in loadedDetail.beneficiaries) person.id,
      };
    });
  }

  Future<void> save({bool closeAfterSave = false}) async {
    final fallbackPayerId =
        payerId ?? (people.isEmpty ? null : people.first.id);
    final selectedBeneficiaries =
        beneficiaryIds.isEmpty && fallbackPayerId != null
        ? [fallbackPayerId]
        : beneficiaryIds.toList();
    setState(() => saving = true);
    await widget.database.updateTransactionDetails(
      id: widget.transactionId,
      displayDescription: titleController.text.trim().isEmpty
          ? 'Lancamento sem descricao'
          : titleController.text.trim(),
      amountCents: parseBrlInput(amountController.text),
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
    await load();
    if (!mounted) return;
    setState(() {
      saving = false;
      editing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lançamento salvo localmente.'),
        duration: Duration(seconds: 3),
        persist: false,
        showCloseIcon: true,
      ),
    );
    if (closeAfterSave) Navigator.of(context).pop();
  }

  Future<void> pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: occurredAt,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (selected == null || !mounted) return;
    setState(() {
      occurredAt = selected;
      competenceController.text = monthKey(selected);
    });
  }

  Future<void> pickValue({
    required String title,
    required List<_PickerOption> options,
    required String? selectedId,
    required ValueChanged<String?> onSelected,
  }) async {
    final value = await showModalBottomSheet<_PickedValue>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _PickerSheet(
        title: title,
        options: options,
        selectedId: selectedId,
        onSelected: (value) => Navigator.of(sheetContext).pop(value),
      ),
    );
    if (value != null && mounted) onSelected(value.id);
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
    await load();
    if (mounted) setState(() => categoryId = id);
  }

  Future<void> createCostCenterInline() async {
    final id = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => CostCenterFormPage(database: widget.database),
      ),
    );
    if (id == null || !mounted) return;
    await load();
    if (mounted) setState(() => costCenterId = id);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lançamento')),
        body: const Center(child: Text('Lançamento não encontrado')),
      );
    }

    final current = transaction!;
    final visibleAccounts = accounts
        .where((item) => item.account.active || item.account.id == accountId)
        .toList(growable: false);
    final visibleCategories = categories
        .where((item) => item.active || item.id == categoryId)
        .toList(growable: false);
    final visibleCostCenters = costCenters
        .where((item) => item.active || item.id == costCenterId)
        .toList(growable: false);
    final selectedPlan = installmentPlans
        .where((item) => item.id == current.installmentPlanId)
        .firstOrNull;
    final accountName =
        visibleAccounts
            .where((item) => item.account.id == accountId)
            .map((item) => item.account.name)
            .firstOrNull ??
        'Conta não definida';
    final selectedAccount = visibleAccounts
        .where((item) => item.account.id == accountId)
        .firstOrNull;
    final categoryName =
        visibleCategories
            .where((item) => item.id == categoryId)
            .map((item) => item.name)
            .firstOrNull ??
        'Sem categoria';
    final costCenterName =
        visibleCostCenters
            .where((item) => item.id == costCenterId)
            .map((item) => item.name)
            .firstOrNull ??
        'Sem centro';
    final payerName =
        people
            .where((item) => item.id == payerId)
            .map((item) => item.displayName)
            .firstOrNull ??
        'Sem pagador';

    return Scaffold(
      appBar: _DetailAppBar(
        onBack: () => Navigator.of(context).pop(),
        editing: editing,
        onEdit: () => setState(() => editing = true),
        onCancel: () async {
          await load();
          if (mounted) setState(() => editing = false);
        },
      ),
      bottomNavigationBar: widget.onNavigate == null
          ? null
          : ZimbaBottomNavigation(
              selectedIndex: 1,
              onSelected: (index) {
                Navigator.of(context).pop();
                widget.onNavigate!(index);
              },
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          _TransactionSummaryCard(
            titleController: titleController,
            amountController: amountController,
            originalDescription: current.descriptionRaw,
            amountCents: current.amountCents,
            status: _reviewStatusLabel(current.reviewStatus),
            provider: details?.providerLabel ?? 'ZimbaControl',
            date: _formatDetailDate(occurredAt),
            currency: current.currencyCode,
            isIncome: kind == 'income',
            editing: editing,
            showSuggestion:
                editing &&
                current.reviewStatus == 'pending' &&
                categoryId == null &&
                kind != 'transfer',
            onAcceptSuggestion: () => pickValue(
              title: 'Categoria',
              selectedId: categoryId,
              options: [
                const _PickerOption(null, 'Sem categoria'),
                for (final item in visibleCategories)
                  _PickerOption(item.id, item.name),
              ],
              onSelected: (value) => setState(() => categoryId = value),
            ),
          ),
          const SizedBox(height: 28),
          const ZimbaSectionTitle('Classificação'),
          ZimbaRows(
            children: [
              _DetailSelectRow(
                label: 'Tipo do lançamento',
                value: _kindLabel(kind),
                onTap: editing
                    ? () => pickValue(
                        title: 'Tipo do lançamento',
                        selectedId: kind,
                        options: const [
                          _PickerOption('expense', 'Despesa'),
                          _PickerOption('income', 'Receita'),
                          _PickerOption('transfer', 'Transferência'),
                        ],
                        onSelected: (value) =>
                            setState(() => kind = value ?? kind),
                      )
                    : null,
              ),
              _DetailSelectRow(
                label: 'Categoria',
                value: kind == 'transfer' ? 'Não se aplica' : categoryName,
                enabled: kind != 'transfer',
                onTap: editing && kind != 'transfer'
                    ? () => pickValue(
                        title: 'Categoria',
                        selectedId: categoryId,
                        options: [
                          const _PickerOption(null, 'Sem categoria'),
                          for (final item in visibleCategories)
                            _PickerOption(
                              item.id,
                              item.name,
                              content: Row(
                                children: [
                                  ClassificationBadge(
                                    iconKey: item.iconKey,
                                    colorKey: item.colorKey,
                                    compact: true,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(item.name)),
                                ],
                              ),
                            ),
                        ],
                        onSelected: (value) =>
                            setState(() => categoryId = value),
                      )
                    : null,
              ),
              _DetailSelectRow(
                label: 'Centro de custo',
                value: kind == 'transfer' ? 'Não se aplica' : costCenterName,
                enabled: kind != 'transfer',
                onTap: editing && kind != 'transfer'
                    ? () => pickValue(
                        title: 'Centro de custo',
                        selectedId: costCenterId,
                        options: [
                          const _PickerOption(null, 'Sem centro de custo'),
                          for (final item in visibleCostCenters)
                            _PickerOption(
                              item.id,
                              item.name,
                              content: Row(
                                children: [
                                  ClassificationBadge(
                                    iconKey: item.iconKey,
                                    colorKey: item.colorKey,
                                    compact: true,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(item.name)),
                                ],
                              ),
                            ),
                        ],
                        onSelected: (value) =>
                            setState(() => costCenterId = value),
                      )
                    : null,
              ),
              _DetailSelectRow(
                label: 'Conta / Cartão',
                value: accountName,
                valueWidget: selectedAccount == null
                    ? null
                    : InstrumentDisplay.account(selectedAccount, compact: true),
                onTap: editing
                    ? () => pickValue(
                        title: 'Conta / Cartão',
                        selectedId: accountId,
                        options: [
                          const _PickerOption(null, 'Conta não definida'),
                          for (final item in visibleAccounts)
                            _PickerOption(
                              item.account.id,
                              item.account.name,
                              content: InstrumentDisplay.account(item),
                            ),
                        ],
                        onSelected: (value) =>
                            setState(() => accountId = value),
                      )
                    : null,
              ),
              _DetailSelectRow(
                label: 'Competência',
                value: competenceController.text,
                onTap: editing ? pickDate : null,
              ),
            ],
          ),
          if (editing && kind != 'transfer') ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: createCategoryInline,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Criar categoria'),
                ),
                OutlinedButton.icon(
                  onPressed: createCostCenterInline,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Criar centro'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          const ZimbaSectionTitle('Beneficiários'),
          ZimbaCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final person in people)
                      _BeneficiaryChip(
                        label: person.displayName,
                        selected: beneficiaryIds.contains(person.id),
                        onTap: editing
                            ? () => setState(() {
                                final next = beneficiaryIds.toSet();
                                next.contains(person.id)
                                    ? next.remove(person.id)
                                    : next.add(person.id);
                                beneficiaryIds = next;
                              })
                            : null,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ZimbaColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Rateio automático em partes iguais entre ${beneficiaryIds.length} ${beneficiaryIds.length == 1 ? 'pessoa' : 'pessoas'}.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ZimbaColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const ZimbaSectionTitle('Origem & parcelamento'),
          ZimbaRows(
            children: [
              _DetailStaticRow(
                label: 'Fonte do dado',
                value: _sourceDescription(details?.sourceLabel),
              ),
              _DetailStaticRow(
                label: 'Parcelamento',
                value: selectedPlan == null
                    ? 'À vista'
                    : '${selectedPlan.currentInstallment} de ${selectedPlan.totalInstallments}',
                icon: Icons.layers_outlined,
              ),
              _DetailSelectRow(
                label: 'Pagador',
                value: payerName,
                onTap: editing
                    ? () => pickValue(
                        title: 'Pagador',
                        selectedId: payerId,
                        options: [
                          const _PickerOption(null, 'Sem pagador'),
                          for (final person in people)
                            _PickerOption(person.id, person.displayName),
                        ],
                        onSelected: (value) => setState(() => payerId = value),
                      )
                    : null,
              ),
            ],
          ),
          if (editing) ...[
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: saving ? null : save,
                child: saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Salvar alterações'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DetailAppBar({
    required this.onBack,
    required this.editing,
    required this.onEdit,
    required this.onCancel,
  });

  final VoidCallback onBack;
  final bool editing;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  @override
  Size get preferredSize => const Size.fromHeight(82);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 82,
      leadingWidth: 52,
      leading: IconButton(
        onPressed: onBack,
        tooltip: 'Voltar',
        icon: const Icon(Icons.arrow_back, size: 22),
        color: ZimbaColors.accent,
      ),
      title: Text(
        'Lançamento',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -.6,
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: editing ? onCancel : onEdit,
          icon: Icon(editing ? Icons.close : Icons.edit_outlined, size: 18),
          label: Text(editing ? 'Cancelar' : 'Editar'),
        ),
        const SizedBox(width: 8),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: ZimbaColors.border),
      ),
    );
  }
}

class _TransactionSummaryCard extends StatelessWidget {
  const _TransactionSummaryCard({
    required this.titleController,
    required this.amountController,
    required this.originalDescription,
    required this.amountCents,
    required this.status,
    required this.provider,
    required this.date,
    required this.currency,
    required this.isIncome,
    required this.editing,
    required this.showSuggestion,
    required this.onAcceptSuggestion,
  });

  final TextEditingController titleController;
  final TextEditingController amountController;
  final String originalDescription;
  final int amountCents;
  final String status;
  final String provider;
  final String date;
  final String currency;
  final bool isIncome;
  final bool editing;
  final bool showSuggestion;
  final VoidCallback onAcceptSuggestion;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ZimbaBadge(label: status, tone: ZimbaTone.info),
              const Spacer(),
              Flexible(
                child: Text(
                  '$provider · $date',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ZimbaColors.secondaryText,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (editing)
            TextField(
              controller: titleController,
              maxLines: 2,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 22,
                height: 1.2,
                fontWeight: FontWeight.w600,
                letterSpacing: -.45,
              ),
              decoration: const InputDecoration(
                labelText: 'Título amigável',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            )
          else
            Text(
              titleController.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 22,
                height: 1.2,
                fontWeight: FontWeight.w600,
                letterSpacing: -.45,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: editing
                    ? TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        style: _amountStyle(context, isIncome),
                        decoration: const InputDecoration(
                          labelText: 'Valor',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      )
                    : Text(
                        formatBrl(amountCents),
                        style: _amountStyle(context, isIncome),
                      ),
              ),
              const SizedBox(width: 8),
              Text(
                currency,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ZimbaColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ZimbaColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DESCRIÇÃO ORIGINAL',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ZimbaColors.secondaryText,
                    letterSpacing: .6,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  '“$originalDescription”',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ZimbaColors.secondaryText,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (showSuggestion) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ZimbaColors.accentSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_outlined,
                    color: ZimbaColors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Escolha uma categoria para completar a classificação.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: onAcceptSuggestion,
                    style: TextButton.styleFrom(
                      backgroundColor: ZimbaColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Escolher'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  TextStyle? _amountStyle(BuildContext context, bool isIncome) =>
      Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: 32,
        height: 1,
        fontWeight: FontWeight.w600,
        color: isIncome ? ZimbaColors.success : ZimbaColors.foreground,
        letterSpacing: -.9,
      );
}

class _DetailSelectRow extends StatelessWidget {
  const _DetailSelectRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.enabled = true,
    this.valueWidget,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool enabled;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) => _DetailRow(
    label: label,
    value: value,
    enabled: enabled,
    onTap: enabled ? onTap : null,
    valueWidget: valueWidget,
  );
}

class _DetailStaticRow extends StatelessWidget {
  const _DetailStaticRow({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) =>
      _DetailRow(label: label, value: value, icon: icon);
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.onTap,
    this.icon,
    this.enabled = true,
    this.valueWidget,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool enabled;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: enabled
                        ? ZimbaColors.secondaryText
                        : ZimbaColors.secondaryText.withValues(alpha: .55),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 16, color: ZimbaColors.secondaryText),
                      const SizedBox(width: 6),
                    ],
                    Expanded(
                      child:
                          valueWidget ??
                          Text(
                            value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: enabled
                                      ? ZimbaColors.foreground
                                      : ZimbaColors.secondaryText,
                                ),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
        ],
      ),
    );
    return onTap == null ? content : InkWell(onTap: onTap, child: content);
  }
}

class _BeneficiaryChip extends StatelessWidget {
  const _BeneficiaryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? ZimbaColors.accentSoft : ZimbaColors.surface,
            border: Border.all(
              color: selected ? ZimbaColors.accent : ZimbaColors.border,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check, size: 14, color: ZimbaColors.accent),
                const SizedBox(width: 5),
              ],
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected
                        ? ZimbaColors.accent
                        : ZimbaColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerOption {
  const _PickerOption(this.id, this.label, {this.content});

  final String? id;
  final String label;
  final Widget? content;
}

class _PickedValue {
  const _PickedValue(this.id);

  final String? id;
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  final String title;
  final List<_PickerOption> options;
  final String? selectedId;
  final ValueChanged<_PickedValue> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 520),
        decoration: const BoxDecoration(
          color: ZimbaColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: ZimbaColors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final selected = option.id == selectedId;
                  return ListTile(
                    onTap: () => onSelected(_PickedValue(option.id)),
                    title: option.content ?? Text(option.label),
                    trailing: selected
                        ? const Icon(Icons.check, color: ZimbaColors.accent)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _reviewStatusLabel(String status) => switch (status) {
  'pending' => 'Sugerido',
  'confirmed' => 'Revisado',
  'ignored' => 'Ignorado',
  _ => 'Lançamento',
};

String _sourceDescription(String? label) => switch (label) {
  'Notificacao' => 'Notificação Android',
  'CSV' => 'Importação CSV',
  'OFX' => 'Importação OFX',
  'Manual' => 'Cadastro manual',
  _ => 'Cadastro local',
};

String _formatDetailDate(DateTime value) {
  final now = DateTime.now();
  final isToday =
      value.year == now.year &&
      value.month == now.month &&
      value.day == now.day;
  final time =
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  return isToday
      ? 'Hoje · $time'
      : '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')} · $time';
}

String _kindLabel(String kind) => switch (kind) {
  'income' => 'Receita',
  'transfer' => 'Transferência',
  _ => 'Despesa',
};

String monthKey(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}';

String centsToInput(int cents) {
  final sign = cents < 0 ? '-' : '';
  final value = cents.abs();
  return '$sign${value ~/ 100},${(value % 100).toString().padLeft(2, '0')}';
}

int parseBrlInput(String input) {
  final normalized = input.trim();
  if (normalized.isEmpty) return 0;
  if (!normalized.contains(',') && !normalized.contains('.')) {
    return int.tryParse(normalized) ?? 0;
  }
  final sign = normalized.startsWith('-') ? -1 : 1;
  final digits = normalized.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return 0;
  final padded = digits.padLeft(3, '0');
  final reais = int.parse(padded.substring(0, padded.length - 2));
  final cents = int.parse(padded.substring(padded.length - 2));
  return sign * ((reais * 100) + cents);
}
