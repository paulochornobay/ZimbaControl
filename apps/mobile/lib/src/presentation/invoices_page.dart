import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart' show formatBrl;
import 'design/instrument_display.dart';
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
    final details = await widget.database.watchAllTransactionDetails().first;
    return _InvoicesViewData(
      cards: cards,
      invoices: invoices,
      summaries: summaries,
      paymentSuggestions: paymentSuggestions,
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
            RegistriesPage(database: widget.database, initialTabIndex: 2),
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
          const ZimbaSectionTitle('Cartão'),
          const SizedBox(height: 8),
          for (final item in data.cards) ...[
            InstrumentChoice(
              instrument: InstrumentDisplay.card(item, compact: true),
              selected: item.creditCard.id == cardId,
              onTap: () => setState(() {
                selectedCardId = item.creditCard.id;
                selectedInvoiceId = null;
                categoryFilter = null;
                personFilter = null;
              }),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
        ] else ...[
          ZimbaCard(child: InstrumentDisplay.card(card)),
          const SizedBox(height: 14),
        ],
        const ZimbaSectionTitle('Mês da fatura'),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cardInvoices.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = cardInvoices[index];
              return ChoiceChip(
                label: Text(_monthLabel(item.competenceMonth)),
                selected: item.id == invoice.id,
                onSelected: (_) => setState(() {
                  selectedInvoiceId = item.id;
                  categoryFilter = null;
                  personFilter = null;
                }),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        _InvoiceOverview(summary: summary),
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
                  trailing: const ZimbaBadge(
                    label: 'Confirmado',
                    tone: ZimbaTone.success,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _InvoiceOverview extends StatelessWidget {
  const _InvoiceOverview({required this.summary});

  final CreditCardInvoiceSummary summary;

  @override
  Widget build(BuildContext context) {
    final invoice = summary.invoice;
    return ZimbaCard(
      borderColor: _stateTone(summary.effectiveState) == ZimbaTone.danger
          ? ZimbaColors.destructive
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Fatura de ${_monthLabel(invoice.competenceMonth)}',
                  style: Theme.of(context).textTheme.titleMedium,
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -.6,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Total derivado de compras menos estornos',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 18,
            runSpacing: 12,
            children: [
              _InvoiceMetric(
                label: 'FECHAMENTO',
                value: _shortDate(invoice.closingDate),
              ),
              _InvoiceMetric(
                label: 'VENCIMENTO',
                value: _shortDate(invoice.dueDate),
              ),
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
    required this.detailsById,
  });

  final List<CreditCardWithOwner> cards;
  final List<CreditCardInvoiceRow> invoices;
  final Map<String, CreditCardInvoiceSummary> summaries;
  final Map<String, List<InvoicePaymentSuggestion>> paymentSuggestions;
  final Map<String, ReviewTransactionDetails> detailsById;
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
