import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart' show formatBrl;
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'edit_transaction_page.dart';
import 'registries_page.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({required this.database, super.key, this.referenceDate});

  final AppDatabase database;
  final DateTime? referenceDate;

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  late Future<_InvoicesViewData> dataFuture;
  String? selectedCardId;
  String? selectedInvoiceId;
  String? categoryFilter;
  String? personFilter;

  DateTime get referenceDate => widget.referenceDate ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    dataFuture = _load();
  }

  Future<_InvoicesViewData> _load() async {
    await widget.database.rebuildCreditCardInvoices(now: referenceDate);
    await widget.database.ensureInstallmentProjectionInvoices(
      now: referenceDate,
    );
    final cards = await widget.database.listCreditCardsWithOwners();
    for (final item in cards) {
      final current = await widget.database.ensureCreditCardInvoiceForDate(
        creditCardId: item.creditCard.id,
        transactionAt: referenceDate,
      );
      await widget.database.ensureCreditCardInvoiceForDate(
        creditCardId: item.creditCard.id,
        transactionAt: current.periodEnd.add(const Duration(days: 1)),
      );
    }
    final invoices = await widget.database.listCreditCardInvoices();
    final summaries = <String, CreditCardInvoiceSummary>{};
    final paymentSuggestions = <String, List<InvoicePaymentSuggestion>>{};
    for (final invoice in invoices) {
      summaries[invoice.id] = await widget.database.getCreditCardInvoiceSummary(
        invoice.id,
        now: referenceDate,
      );
      paymentSuggestions[invoice.id] = await widget.database
          .listInvoicePaymentSuggestions(invoice.id);
    }
    final limitSummaries = <String, CreditLimitGroupSummary>{};
    for (final groupId
        in cards
            .map((item) => item.creditCard.limitGroupId)
            .whereType<String>()
            .toSet()) {
      final summary = await widget.database.getCreditLimitGroupSummary(
        groupId,
        now: referenceDate,
      );
      if (summary != null) limitSummaries[groupId] = summary;
    }
    final paymentAccounts = (await widget.database.listAccountsWithOwners())
        .where((item) => item.account.type != 'credit_card')
        .toList(growable: false);
    final details = await widget.database.watchAllTransactionDetails().first;
    return _InvoicesViewData(
      cards: cards,
      invoices: invoices,
      summaries: summaries,
      paymentSuggestions: paymentSuggestions,
      limitSummaries: limitSummaries,
      paymentAccounts: paymentAccounts,
      detailsById: {
        for (final detail in details) detail.transaction.id: detail,
      },
    );
  }

  void reload() {
    setState(() => dataFuture = _load());
  }

  Future<void> openCardRegistry() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) =>
            RegistriesPage(database: widget.database, initialTabIndex: 1),
      ),
    );
    if (mounted) reload();
  }

  Future<void> confirmPaymentSuggestion(
    CreditCardInvoiceRow invoice,
    InvoicePaymentSuggestion suggestion,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar pagamento?'),
        content: Text(
          '${formatBrl(suggestion.amountCents)} será vinculado à fatura de '
          '${_monthLabel(invoice.competenceMonth)} como transferência. '
          'Isso não cria uma nova despesa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Confirmar pagamento'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await widget.database.confirmInvoicePaymentSuggestion(
        invoiceId: invoice.id,
        transactionId: suggestion.transaction.id,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pagamento conciliado com a fatura.')),
      );
      reload();
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Bad state: ', '')),
        ),
      );
    }
  }

  Future<void> registerManualPayment(
    CreditCardInvoiceSummary summary,
    List<AccountWithOwner> accounts,
  ) async {
    if (accounts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastre uma conta bancária antes de pagar a fatura.'),
        ),
      );
      return;
    }
    final amountController = TextEditingController(
      text: centsToInput(summary.outstandingCents),
    );
    var accountId = accounts.first.account.id;
    var paidAt = referenceDate;
    var fullPayment = true;
    final input = await showModalBottomSheet<_ManualPaymentInput>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            4,
            20,
            20 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registrar pagamento',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'O pagamento será uma transferência e não criará uma nova despesa.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ZimbaColors.secondaryText,
                ),
              ),
              const SizedBox(height: 18),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Total')),
                  ButtonSegment(value: false, label: Text('Parcial')),
                ],
                selected: {fullPayment},
                onSelectionChanged: (selection) {
                  setSheetState(() {
                    fullPayment = selection.first;
                    if (fullPayment) {
                      amountController.text = centsToInput(
                        summary.outstandingCents,
                      );
                    }
                  });
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: accountId,
                decoration: const InputDecoration(labelText: 'Conta pagadora'),
                items: [
                  for (final item in accounts)
                    DropdownMenuItem(
                      value: item.account.id,
                      child: Text(
                        item.account.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) => accountId = value ?? accountId,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                enabled: !fullPayment,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Valor pago',
                  helperText:
                      'Saldo em aberto: ${formatBrl(summary.outstandingCents)}',
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Data do pagamento'),
                subtitle: Text(_shortDate(paidAt)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: sheetContext,
                    initialDate: paidAt,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (selected != null) {
                    setSheetState(() => paidAt = selected);
                  }
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    final amount = parseBrlInput(amountController.text).abs();
                    if (amount <= 0 || amount > summary.outstandingCents) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Informe um valor válido até o saldo em aberto.',
                          ),
                        ),
                      );
                      return;
                    }
                    Navigator.of(sheetContext).pop(
                      _ManualPaymentInput(
                        accountId: accountId,
                        amountCents: amount,
                        paidAt: paidAt,
                      ),
                    );
                  },
                  icon: const Icon(Icons.compare_arrows_outlined),
                  label: const Text('Confirmar pagamento'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    amountController.dispose();
    if (input == null || !mounted) return;
    try {
      await widget.database.recordManualInvoicePayment(
        invoiceId: summary.invoice.id,
        sourceAccountId: input.accountId,
        amountCents: input.amountCents,
        paidAt: input.paidAt,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pagamento registrado e conciliado.')),
      );
      reload();
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Bad state: ', '')),
        ),
      );
    }
  }

  Future<void> exportInvoice(
    CreditCardInvoiceSummary summary,
    CreditCardWithOwner card,
  ) async {
    try {
      final bytes = await widget.database.exportInvoiceCsvBytes(
        summary.invoice.id,
      );
      final suffix = card.creditCard.last4 ?? card.creditCard.id;
      final path = await FilePicker.saveFile(
        dialogTitle: 'Exportar fatura',
        fileName:
            'zimbacontrol-fatura-${summary.invoice.competenceMonth}-$suffix.csv',
        type: FileType.custom,
        allowedExtensions: const ['csv'],
      );
      if (path == null) return;
      await File(path).writeAsBytes(bytes, flush: true);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fatura exportada em CSV.')));
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível exportar: $error')),
      );
    }
  }

  Future<void> cancelPayment(InvoicePaymentRow payment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Desfazer conciliação?'),
        content: const Text(
          'A transferência voltará para a revisão e o histórico será preservado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Desfazer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.database.cancelInvoicePayment(
      payment.id,
      reason: 'Conciliação desfeita na tela de fatura',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pagamento devolvido para revisão.')),
    );
    reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Faturas'),
            Text(
              'Compras consolidadas pelo ciclo do cartão',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Atualizar faturas',
            onPressed: reload,
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: FutureBuilder<_InvoicesViewData>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return ZimbaStateMessage(
              icon: Icons.error_outline,
              title: 'Não foi possível calcular as faturas',
              body: 'Os lançamentos não foram alterados. Tente novamente.',
              action: FilledButton.icon(
                onPressed: reload,
                icon: const Icon(Icons.refresh_outlined),
                label: const Text('Tentar novamente'),
              ),
            );
          }
          final data = snapshot.data!;
          if (data.cards.isEmpty) {
            return ZimbaStateMessage(
              icon: Icons.credit_card_off_outlined,
              title: 'Nenhum cartão cadastrado',
              body:
                  'Cadastre o cartão com fechamento e vencimento para consolidar as compras.',
              action: FilledButton.icon(
                onPressed: openCardRegistry,
                icon: const Icon(Icons.add_card_outlined),
                label: const Text('Cadastrar cartão'),
              ),
            );
          }
          return _buildContent(data);
        },
      ),
    );
  }

  Widget _buildContent(_InvoicesViewData data) {
    final cardId =
        data.cards.any((item) => item.creditCard.id == selectedCardId)
        ? selectedCardId!
        : data.cards.first.creditCard.id;
    final card = data.cards.firstWhere((item) => item.creditCard.id == cardId);
    final limitSummary = card.creditCard.limitGroupId == null
        ? null
        : data.limitSummaries[card.creditCard.limitGroupId!];
    final cardInvoices = data.invoices
        .where((invoice) => invoice.creditCardId == cardId)
        .toList(growable: false);
    final currentMonth = widget.database
        .invoiceCycleFor(card.creditCard, referenceDate)
        .competenceMonth;
    final invoice = cardInvoices.firstWhere(
      (item) => item.id == selectedInvoiceId,
      orElse: () => cardInvoices.firstWhere(
        (item) => item.competenceMonth == currentMonth,
        orElse: () => cardInvoices.first,
      ),
    );
    final summary = data.summaries[invoice.id]!;
    final paymentSuggestions =
        data.paymentSuggestions[invoice.id] ??
        const <InvoicePaymentSuggestion>[];
    final details = summary.transactions
        .map((item) => data.detailsById[item.id])
        .whereType<ReviewTransactionDetails>()
        .where(
          (item) =>
              categoryFilter == null || item.category?.id == categoryFilter,
        )
        .where(
          (item) =>
              personFilter == null ||
              item.beneficiaries.any((person) => person.id == personFilter),
        )
        .toList(growable: false);
    final categories = summary.transactions
        .map((item) => data.detailsById[item.id]?.category)
        .whereType<CategoryRow>()
        .fold<Map<String, CategoryRow>>(
          {},
          (map, category) => map..[category.id] = category,
        )
        .values
        .toList(growable: false);
    final people = summary.transactions
        .expand(
          (item) =>
              data.detailsById[item.id]?.beneficiaries ?? const <PersonRow>[],
        )
        .fold<Map<String, PersonRow>>(
          {},
          (map, person) => map..[person.id] = person,
        )
        .values
        .toList(growable: false);

    return ListView(
      key: const Key('invoice-list'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        if (data.cards.length > 1) ...[
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: data.cards.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = data.cards[index];
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: ChoiceChip(
                    avatar: const Icon(Icons.credit_card_outlined, size: 16),
                    label: Text(
                      item.creditCard.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    selected: item.creditCard.id == cardId,
                    onSelected: (_) => setState(() {
                      selectedCardId = item.creditCard.id;
                      selectedInvoiceId = null;
                      categoryFilter = null;
                      personFilter = null;
                    }),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
        ],
        _InvoiceOverview(
          card: card,
          summary: summary,
          limitSummary: limitSummary,
          onRegisterPayment: summary.outstandingCents > 0
              ? () => registerManualPayment(summary, data.paymentAccounts)
              : null,
          onExport: () => exportInvoice(summary, card),
        ),
        const SizedBox(height: 14),
        const ZimbaSectionTitle('Mês da fatura'),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var index = 0; index < cardInvoices.length; index++) ...[
                  if (index > 0) const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(
                      _monthLabel(cardInvoices[index].competenceMonth),
                    ),
                    selected: cardInvoices[index].id == invoice.id,
                    onSelected: (_) => setState(() {
                      selectedInvoiceId = cardInvoices[index].id;
                      categoryFilter = null;
                      personFilter = null;
                    }),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ZimbaFeedbackBanner(
          icon: Icons.calendar_month_outlined,
          title: '${_monthLabel(invoice.competenceMonth)} é o mês da fatura',
          body:
              'Inclui compras postadas de ${_shortDate(invoice.periodStart)} a ${_shortDate(invoice.periodEnd)}. O mês-calendário do lançamento continua preservado.',
          tone: ZimbaTone.info,
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: ZimbaSectionTitle('Compras e estornos')),
            Text(
              '${details.length}/${summary.transactions.length}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: ZimbaColors.secondaryText,
              ),
            ),
          ],
        ),
        if (categories.isNotEmpty || people.isNotEmpty) ...[
          const SizedBox(height: 8),
          _InvoiceFilters(
            categories: categories,
            people: people,
            categoryId: categoryFilter,
            personId: personFilter,
            onCategoryChanged: (value) =>
                setState(() => categoryFilter = value),
            onPersonChanged: (value) => setState(() => personFilter = value),
          ),
        ],
        const SizedBox(height: 10),
        if (details.isEmpty)
          const ZimbaCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Nenhum lançamento nesta seleção.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ZimbaRows(
            children: [
              for (final item in details)
                _InvoiceTransactionTile(
                  details: item,
                  onTap: () async {
                    await Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => EditTransactionPage(
                          database: widget.database,
                          transactionId: item.transaction.id,
                        ),
                      ),
                    );
                    if (mounted) reload();
                  },
                ),
            ],
          ),
        if (summary.installmentProjections.isNotEmpty) ...[
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(child: ZimbaSectionTitle('Parcelas projetadas')),
              Text(
                formatBrl(
                  summary.installmentProjections.fold<int>(
                    0,
                    (sum, item) => sum + item.amountCents,
                  ),
                ),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const ZimbaFeedbackBanner(
            icon: Icons.auto_graph_outlined,
            title: 'Previsão, não nova despesa',
            body:
                'Estas parcelas ajudam no planejamento e só entram no total quando o lançamento real chegar.',
            tone: ZimbaTone.info,
          ),
          const SizedBox(height: 8),
          ZimbaRows(
            children: [
              for (final projection in summary.installmentProjections)
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.calendar_month_outlined),
                  ),
                  title: Text(
                    projection.installmentPlan.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Parcela ${projection.installmentNumber}/${projection.installmentPlan.totalInstallments} · projetada',
                  ),
                  trailing: Text(
                    formatBrl(-projection.amountCents),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
        ],
        if (paymentSuggestions.isNotEmpty) ...[
          const SizedBox(height: 18),
          const ZimbaSectionTitle('Sugestões de pagamento'),
          const SizedBox(height: 8),
          for (final suggestion in paymentSuggestions) ...[
            ZimbaCard(
              borderColor: ZimbaColors.accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.compare_arrows_outlined),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          suggestion.transaction.displayDescription ??
                              suggestion.transaction.descriptionRaw,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatBrl(suggestion.amountCents),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    suggestion.explanation,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ZimbaColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () =>
                          confirmPaymentSuggestion(invoice, suggestion),
                      icon: const Icon(Icons.check_outlined),
                      label: const Text('Revisar e confirmar'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
        const SizedBox(height: 18),
        const ZimbaSectionTitle('Pagamentos'),
        const SizedBox(height: 8),
        if (summary.payments.isEmpty)
          const ZimbaCard(
            child: Text(
              'Nenhum pagamento confirmado para esta fatura. Pagamentos são transferências e não viram uma nova despesa.',
            ),
          )
        else
          ZimbaRows(
            children: [
              for (final payment in summary.payments)
                ListTile(
                  leading: const Icon(Icons.account_balance_outlined),
                  title: Text(formatBrl(payment.amountCents)),
                  subtitle: Text(
                    '${_shortDate(payment.paidAt)} · ${_paymentOrigin(payment.origin)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ZimbaBadge(
                        label: 'Confirmado',
                        tone: ZimbaTone.success,
                      ),
                      IconButton(
                        tooltip: 'Desfazer pagamento',
                        onPressed: () => cancelPayment(payment),
                        icon: const Icon(Icons.undo_outlined),
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _InvoiceOverview extends StatelessWidget {
  const _InvoiceOverview({
    required this.card,
    required this.summary,
    required this.limitSummary,
    required this.onRegisterPayment,
    required this.onExport,
  });

  final CreditCardWithOwner card;
  final CreditCardInvoiceSummary summary;
  final CreditLimitGroupSummary? limitSummary;
  final VoidCallback? onRegisterPayment;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final invoice = summary.invoice;
    final utilization = limitSummary?.utilization;
    final limitTone =
        limitSummary?.overLimit == true ||
            (utilization != null && utilization >= .8)
        ? ZimbaColors.warning
        : ZimbaColors.accent;
    return ZimbaCard(
      borderColor: _stateTone(summary.effectiveState) == ZimbaTone.danger
          ? ZimbaColors.destructive
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ZimbaColors.muted,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.credit_card_outlined, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.creditCard.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Fecha ${_shortDate(invoice.closingDate)} · vence ${_shortDate(invoice.dueDate)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ZimbaColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              ZimbaBadge(
                label: _stateLabel(summary.effectiveState),
                tone: _stateTone(summary.effectiveState),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            formatBrl(summary.totalCents),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -.6,
            ),
          ),
          const SizedBox(height: 3),
          Wrap(
            children: [
              Text(
                'Fatura de ${_monthLabel(invoice.competenceMonth)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ZimbaColors.secondaryText,
                ),
              ),
              Text(
                ' · ${summary.transactions.length} lançamentos',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ZimbaColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (limitSummary?.group.totalLimitCents != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (utilization ?? 0).clamp(0, 1),
                minHeight: 5,
                color: limitTone,
                backgroundColor: ZimbaColors.muted,
              ),
            ),
            const SizedBox(height: 7),
            Text.rich(
              TextSpan(
                text: 'Limite usado ${((utilization ?? 0) * 100).round()}% · ',
                children: [
                  TextSpan(
                    text: limitSummary!.overLimit
                        ? '${formatBrl(limitSummary!.availableCents!.abs())} acima do limite'
                        : '${formatBrl(limitSummary!.availableCents!)} disponível',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: limitSummary!.overLimit
                    ? ZimbaColors.destructive
                    : ZimbaColors.secondaryText,
              ),
            ),
            if (limitSummary!.cards.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  'Compartilhado por ${limitSummary!.cards.length} cartões · inclui ${formatBrl(limitSummary!.projectedInstallmentsCents)} em parcelas futuras',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ZimbaColors.secondaryText,
                  ),
                ),
              ),
          ] else
            Text(
              'Limite não informado · configure no cadastro do cartão',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: ZimbaColors.secondaryText,
              ),
            ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _InvoiceMetric(
                label: 'PAGO',
                value: formatBrl(summary.paidCents),
              ),
              _InvoiceMetric(
                label: 'EM ABERTO',
                value: formatBrl(summary.outstandingCents),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onRegisterPayment,
                  icon: const Icon(Icons.compare_arrows_outlined, size: 18),
                  label: Text(
                    summary.outstandingCents > 0
                        ? 'Registrar pagamento'
                        : 'Paga',
                    maxLines: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onExport,
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  label: const Text('Exportar'),
                ),
              ),
            ],
          ),
          if (summary.refundsCents > 0) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: ZimbaColors.successSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.undo_outlined,
                    size: 16,
                    color: ZimbaColors.success,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Estornos reduzem ${formatBrl(summary.refundsCents)} do total',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ZimbaColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InvoiceMetric extends StatelessWidget {
  const _InvoiceMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ZimbaColors.secondaryText,
              letterSpacing: .7,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _InvoiceFilters extends StatelessWidget {
  const _InvoiceFilters({
    required this.categories,
    required this.people,
    required this.categoryId,
    required this.personId,
    required this.onCategoryChanged,
    required this.onPersonChanged,
  });

  final List<CategoryRow> categories;
  final List<PersonRow> people;
  final String? categoryId;
  final String? personId;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onPersonChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (categories.isNotEmpty)
          DropdownButtonFormField<String?>(
            initialValue: categoryId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Categoria',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Todas')),
              for (final category in categories)
                DropdownMenuItem(
                  value: category.id,
                  child: Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: onCategoryChanged,
          ),
        if (categories.isNotEmpty && people.isNotEmpty)
          const SizedBox(height: 8),
        if (people.isNotEmpty)
          DropdownButtonFormField<String?>(
            initialValue: personId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Pessoa',
              prefixIcon: Icon(Icons.person_outline),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Todas')),
              for (final person in people)
                DropdownMenuItem(
                  value: person.id,
                  child: Text(
                    person.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: onPersonChanged,
          ),
      ],
    );
  }
}

class _InvoiceTransactionTile extends StatelessWidget {
  const _InvoiceTransactionTile({required this.details, required this.onTap});

  final ReviewTransactionDetails details;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final transaction = details.transaction;
    final refund = transaction.amountCents > 0;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: refund
            ? ZimbaColors.successSoft
            : ZimbaColors.destructiveSoft,
        foregroundColor: refund ? ZimbaColors.success : ZimbaColors.destructive,
        child: Icon(refund ? Icons.undo_outlined : Icons.credit_card_outlined),
      ),
      title: Text(
        transaction.displayDescription ?? transaction.descriptionRaw,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        [
          _shortDate(transaction.postedAt ?? transaction.occurredAt),
          details.category?.name,
          if (details.beneficiaries.isNotEmpty)
            details.beneficiaries
                .map((person) => person.displayName)
                .join(', '),
        ].whereType<String>().join(' · '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 105),
        child: Text(
          formatBrl(transaction.amountCents),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: refund ? ZimbaColors.success : ZimbaColors.foreground,
          ),
        ),
      ),
    );
  }
}

class _InvoicesViewData {
  const _InvoicesViewData({
    required this.cards,
    required this.invoices,
    required this.summaries,
    required this.paymentSuggestions,
    required this.limitSummaries,
    required this.paymentAccounts,
    required this.detailsById,
  });

  final List<CreditCardWithOwner> cards;
  final List<CreditCardInvoiceRow> invoices;
  final Map<String, CreditCardInvoiceSummary> summaries;
  final Map<String, List<InvoicePaymentSuggestion>> paymentSuggestions;
  final Map<String, CreditLimitGroupSummary> limitSummaries;
  final List<AccountWithOwner> paymentAccounts;
  final Map<String, ReviewTransactionDetails> detailsById;
}

class _ManualPaymentInput {
  const _ManualPaymentInput({
    required this.accountId,
    required this.amountCents,
    required this.paidAt,
  });

  final String accountId;
  final int amountCents;
  final DateTime paidAt;
}

String _shortDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

String _monthLabel(String month) {
  final parts = month.split('-');
  final index = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 1;
  const names = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];
  return '${names[index.clamp(1, 12) - 1]} ${parts.first}';
}

String _stateLabel(String state) => switch (state) {
  'paid' => 'Paga',
  'partially_paid' => 'Parcial',
  'overdue' => 'Vencida',
  'closed' => 'Fechada',
  'credit' => 'Com crédito',
  _ => 'Aberta',
};

ZimbaTone _stateTone(String state) => switch (state) {
  'paid' || 'credit' => ZimbaTone.success,
  'partially_paid' => ZimbaTone.warning,
  'overdue' => ZimbaTone.danger,
  'closed' => ZimbaTone.info,
  _ => ZimbaTone.accent,
};

String _paymentOrigin(String origin) => switch (origin) {
  'manual_confirmed' => 'confirmado manualmente',
  'ofx_reconciled' => 'conciliado por OFX',
  'suggestion_confirmed' => 'sugestão confirmada',
  _ => 'manual',
};
