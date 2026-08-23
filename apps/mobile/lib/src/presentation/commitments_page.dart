import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

class CommitmentsPage extends StatefulWidget {
  const CommitmentsPage({
    required this.database,
    this.initialTabIndex = 0,
    super.key,
  }) : assert(initialTabIndex >= 0 && initialTabIndex < 2);

  final AppDatabase database;
  final int initialTabIndex;

  @override
  State<CommitmentsPage> createState() => _CommitmentsPageState();
}

class _CommitmentsPageState extends State<CommitmentsPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late Future<FamilyStructureSnapshot> future;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      initialIndex: widget.initialTabIndex,
      vsync: this,
    );
    future = widget.database.getFamilyStructureSnapshot();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      future = widget.database.getFamilyStructureSnapshot();
    });
  }

  Future<void> openCreateForm() async {
    final snapshot = await future;
    if (!mounted) {
      return;
    }
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => tabController.index == 0
            ? RecurringScheduleFormPage(
                database: widget.database,
                snapshot: snapshot,
              )
            : InstallmentPlanFormPage(
                database: widget.database,
                snapshot: snapshot,
              ),
      ),
    );
    if (created == true) {
      refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Compromissos'),
            Text(
              'Projecoes, recorrencias e parcelas',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Recorrencias'),
            Tab(text: 'Parcelas'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openCreateForm,
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
      body: FutureBuilder<FamilyStructureSnapshot>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          if (data == null) {
            return ZimbaStateMessage(
              icon: Icons.error_outline,
              title: 'Não foi possível carregar compromissos',
              body:
                  'Tente atualizar. Nenhum plano ou recorrência foi alterado.',
              action: OutlinedButton.icon(
                onPressed: refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar'),
              ),
            );
          }
          return TabBarView(
            controller: tabController,
            children: [
              _RecurringList(
                database: widget.database,
                snapshot: data,
                onChanged: refresh,
                onCreate: openCreateForm,
              ),
              _InstallmentList(
                database: widget.database,
                snapshot: data,
                onChanged: refresh,
                onCreate: openCreateForm,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RecurringList extends StatelessWidget {
  const _RecurringList({
    required this.database,
    required this.snapshot,
    required this.onChanged,
    required this.onCreate,
  });

  final AppDatabase database;
  final FamilyStructureSnapshot snapshot;
  final VoidCallback onChanged;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final items = snapshot.recurringSchedules;
    if (items.isEmpty) {
      return _EmptyCommitmentState(
        icon: Icons.event_repeat_outlined,
        title: 'Nenhuma recorrencia',
        body: 'Cadastre escola, pensao, ajuda familiar ou despesas fixas.',
        actionLabel: 'Criar recorrencia',
        onCreate: onCreate,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
      itemCount: items.length + 2,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _CommitmentProjection(
            eyebrow: 'Projecao mensal',
            title: 'Recorrencias ativas',
            amountCents: items
                .where((item) => item.active)
                .fold(0, (total, item) => total + item.amountCents),
            detail:
                '${items.where((item) => item.active).length} compromisso(s) entram nesta leitura.',
            icon: Icons.event_repeat_outlined,
          );
        }
        if (index == 1) {
          return const ZimbaSectionTitle('Recorrencias cadastradas');
        }
        final item = items[index - 2];
        return _CommitmentTile(
          icon: Icons.event_repeat_outlined,
          title: item.label,
          subtitle: '${_kindLabel(item.kind)} · dia ${item.dayOfMonth}',
          amountCents: item.amountCents,
          inactive: !item.active,
          onTap: () async {
            final changed = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => RecurringScheduleFormPage(
                  database: database,
                  snapshot: snapshot,
                  schedule: item,
                ),
              ),
            );
            if (changed == true) {
              onChanged();
            }
          },
          onArchive: () async {
            await database.archiveRecurringSchedule(
              item.id,
              active: !item.active,
            );
            onChanged();
          },
        );
      },
    );
  }
}

class _InstallmentList extends StatelessWidget {
  const _InstallmentList({
    required this.database,
    required this.snapshot,
    required this.onChanged,
    required this.onCreate,
  });

  final AppDatabase database;
  final FamilyStructureSnapshot snapshot;
  final VoidCallback onChanged;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final items = snapshot.installmentPlans;
    if (items.isEmpty) {
      return _EmptyCommitmentState(
        icon: Icons.layers_outlined,
        title: 'Nenhuma parcela',
        body: 'Cadastre compras parceladas ou compromissos como consorcio.',
        actionLabel: 'Criar parcela',
        onCreate: onCreate,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
      itemCount: items.length + 2,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _CommitmentProjection(
            eyebrow: 'Projecao mensal',
            title: 'Parcelas em aberto',
            amountCents: -items
                .where((item) => item.active)
                .fold(0, (total, item) => total + item.installmentAmountCents),
            detail:
                '${items.where((item) => item.active).length} plano(s) ativos no proximo ciclo.',
            icon: Icons.layers_outlined,
          );
        }
        if (index == 1) {
          return const ZimbaSectionTitle('Parcelas e planos');
        }
        final item = items[index - 2];
        return _CommitmentTile(
          icon: Icons.layers_outlined,
          title: item.label,
          subtitle:
              '${item.currentInstallment}/${item.totalInstallments} · vence dia ${item.dueDay ?? '-'}',
          amountCents: -item.installmentAmountCents,
          inactive: !item.active,
          onTap: () async {
            final changed = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => InstallmentPlanFormPage(
                  database: database,
                  snapshot: snapshot,
                  plan: item,
                ),
              ),
            );
            if (changed == true) {
              onChanged();
            }
          },
          onArchive: () async {
            await database.archiveInstallmentPlan(
              item.id,
              active: !item.active,
            );
            onChanged();
          },
        );
      },
    );
  }
}

class RecurringScheduleFormPage extends StatefulWidget {
  const RecurringScheduleFormPage({
    required this.database,
    required this.snapshot,
    this.schedule,
    super.key,
  });

  final AppDatabase database;
  final FamilyStructureSnapshot snapshot;
  final RecurringScheduleRow? schedule;

  @override
  State<RecurringScheduleFormPage> createState() =>
      _RecurringScheduleFormPageState();
}

class _RecurringScheduleFormPageState extends State<RecurringScheduleFormPage> {
  late final TextEditingController labelController;
  late final TextEditingController amountController;
  late final TextEditingController dayController;
  late final TextEditingController startMonthController;
  late String kind;
  String? payerPersonId;
  String? beneficiaryPersonId;
  String? fromAccountId;
  String? toAccountId;
  String? categoryId;
  String? costCenterId;
  late bool active;

  @override
  void initState() {
    super.initState();
    final schedule = widget.schedule;
    final now = DateTime.now();
    labelController = TextEditingController(text: schedule?.label ?? '');
    amountController = TextEditingController(
      text: centsToInput(schedule?.amountCents ?? -10000),
    );
    dayController = TextEditingController(
      text: (schedule?.dayOfMonth ?? now.day).toString(),
    );
    startMonthController = TextEditingController(
      text: schedule?.startMonth ?? _monthKey(now),
    );
    kind = schedule?.kind ?? 'expense';
    payerPersonId = schedule?.payerPersonId;
    beneficiaryPersonId = schedule?.beneficiaryPersonId;
    fromAccountId = schedule?.fromAccountId;
    toAccountId = schedule?.toAccountId;
    categoryId = schedule?.categoryId;
    costCenterId = schedule?.costCenterId;
    active = schedule?.active ?? true;
  }

  @override
  void dispose() {
    labelController.dispose();
    amountController.dispose();
    dayController.dispose();
    startMonthController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (labelController.text.trim().isEmpty) {
      return;
    }
    await widget.database.upsertRecurringSchedule(
      id: widget.schedule?.id,
      label: labelController.text,
      kind: kind,
      amountCents: _signedAmount(parseBrlInput(amountController.text), kind),
      dayOfMonth: int.tryParse(dayController.text) ?? 1,
      startMonth: startMonthController.text.trim(),
      payerPersonId: payerPersonId,
      beneficiaryPersonId: beneficiaryPersonId,
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      categoryId: categoryId,
      costCenterId: costCenterId,
      active: active,
    );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _CommitmentFormScaffold(
      title: widget.schedule == null
          ? 'Nova recorrencia'
          : 'Editar recorrencia',
      onSave: save,
      children: [
        TextField(
          controller: labelController,
          decoration: const InputDecoration(
            labelText: 'Nome',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Valor',
            prefixText: 'R\$ ',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'expense', label: Text('Despesa')),
            ButtonSegment(value: 'income', label: Text('Receita')),
            ButtonSegment(value: 'transfer', label: Text('Transfer.')),
          ],
          selected: {kind},
          onSelectionChanged: (value) => setState(() => kind = value.first),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: dayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Dia',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: startMonthController,
                decoration: const InputDecoration(
                  labelText: 'Inicio',
                  helperText: 'AAAA-MM',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _PersonDropdown(
          label: 'Pagador',
          people: widget.snapshot.people,
          value: payerPersonId,
          onChanged: (value) => setState(() => payerPersonId = value),
        ),
        const SizedBox(height: 12),
        _PersonDropdown(
          label: 'Beneficiario',
          people: widget.snapshot.people,
          value: beneficiaryPersonId,
          onChanged: (value) => setState(() => beneficiaryPersonId = value),
        ),
        const SizedBox(height: 12),
        _AccountDropdown(
          label: 'Conta origem',
          accounts: widget.snapshot.accounts,
          value: fromAccountId,
          onChanged: (value) => setState(() => fromAccountId = value),
        ),
        const SizedBox(height: 12),
        _AccountDropdown(
          label: 'Conta destino',
          accounts: widget.snapshot.accounts,
          value: toAccountId,
          onChanged: (value) => setState(() => toAccountId = value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativa'),
          value: active,
          onChanged: (value) => setState(() => active = value),
        ),
      ],
    );
  }
}

class InstallmentPlanFormPage extends StatefulWidget {
  const InstallmentPlanFormPage({
    required this.database,
    required this.snapshot,
    this.plan,
    super.key,
  });

  final AppDatabase database;
  final FamilyStructureSnapshot snapshot;
  final InstallmentPlanRow? plan;

  @override
  State<InstallmentPlanFormPage> createState() =>
      _InstallmentPlanFormPageState();
}

class _InstallmentPlanFormPageState extends State<InstallmentPlanFormPage> {
  late final TextEditingController labelController;
  late final TextEditingController amountController;
  late final TextEditingController currentController;
  late final TextEditingController totalController;
  late final TextEditingController dueDayController;
  late final TextEditingController startMonthController;
  String? ownerPersonId;
  late bool active;

  @override
  void initState() {
    super.initState();
    final plan = widget.plan;
    final now = DateTime.now();
    labelController = TextEditingController(text: plan?.label ?? '');
    amountController = TextEditingController(
      text: centsToInput(plan?.installmentAmountCents ?? 10000),
    );
    currentController = TextEditingController(
      text: (plan?.currentInstallment ?? 1).toString(),
    );
    totalController = TextEditingController(
      text: (plan?.totalInstallments ?? 2).toString(),
    );
    dueDayController = TextEditingController(
      text: plan?.dueDay?.toString() ?? '',
    );
    startMonthController = TextEditingController(
      text: plan?.startMonth ?? _monthKey(now),
    );
    ownerPersonId = plan?.ownerPersonId;
    active = plan?.active ?? true;
  }

  @override
  void dispose() {
    labelController.dispose();
    amountController.dispose();
    currentController.dispose();
    totalController.dispose();
    dueDayController.dispose();
    startMonthController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (labelController.text.trim().isEmpty) {
      return;
    }
    final installmentAmount = parseBrlInput(amountController.text).abs();
    final total = int.tryParse(totalController.text) ?? 1;
    await widget.database.upsertInstallmentPlan(
      id: widget.plan?.id,
      label: labelController.text,
      planKind: widget.plan?.planKind ?? 'credit_card_purchase',
      ownerPersonId: ownerPersonId,
      totalAmountCents: installmentAmount * total,
      installmentAmountCents: installmentAmount,
      currentInstallment: int.tryParse(currentController.text) ?? 1,
      totalInstallments: total,
      dueDay: int.tryParse(dueDayController.text),
      startMonth: startMonthController.text.trim(),
      active: active,
    );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _CommitmentFormScaffold(
      title: widget.plan == null ? 'Nova parcela' : 'Editar parcela',
      onSave: save,
      children: [
        TextField(
          controller: labelController,
          decoration: const InputDecoration(
            labelText: 'Nome',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Valor da parcela',
            prefixText: 'R\$ ',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: currentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Atual',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: totalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: dueDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Vencimento',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: startMonthController,
                decoration: const InputDecoration(
                  labelText: 'Inicio',
                  helperText: 'AAAA-MM',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _PersonDropdown(
          label: 'Responsavel',
          people: widget.snapshot.people,
          value: ownerPersonId,
          onChanged: (value) => setState(() => ownerPersonId = value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativa'),
          value: active,
          onChanged: (value) => setState(() => active = value),
        ),
      ],
    );
  }
}

class _CommitmentTile extends StatelessWidget {
  const _CommitmentTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amountCents,
    required this.inactive,
    required this.onTap,
    required this.onArchive,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final int amountCents;
  final bool inactive;
  final VoidCallback onTap;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(ZimbaLayout.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ZimbaColors.accentSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: ZimbaColors.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 116),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.topRight,
                            child: Text(
                              formatBrl(amountCents),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ZimbaColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        ZimbaBadge(
                          label: inactive ? 'Arquivado' : 'Ativo',
                          tone: inactive
                              ? ZimbaTone.neutral
                              : ZimbaTone.success,
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: inactive ? 'Reativar' : 'Arquivar',
                          visualDensity: VisualDensity.compact,
                          onPressed: onArchive,
                          icon: Icon(
                            inactive
                                ? Icons.unarchive_outlined
                                : Icons.archive_outlined,
                            size: 19,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommitmentFormScaffold extends StatelessWidget {
  const _CommitmentFormScaffold({
    required this.title,
    required this.children,
    required this.onSave,
  });

  final String title;
  final List<Widget> children;
  final Future<void> Function() onSave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Salvar',
            onPressed: onSave,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          ZimbaCard(
            padding: const EdgeInsets.all(14),
            child: Column(children: children),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Salvar localmente'),
        ),
      ),
    );
  }
}

class _PersonDropdown extends StatelessWidget {
  const _PersonDropdown({
    required this.label,
    required this.people,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final List<PersonRow> people;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text('Sem $label')),
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
      onChanged: onChanged,
    );
  }
}

class _AccountDropdown extends StatelessWidget {
  const _AccountDropdown({
    required this.label,
    required this.accounts,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final List<AccountWithOwner> accounts;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text('Sem $label')),
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
      onChanged: onChanged,
    );
  }
}

class _EmptyCommitmentState extends StatelessWidget {
  const _EmptyCommitmentState({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onCreate,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return ZimbaStateMessage(
      icon: icon,
      title: title,
      body: body,
      action: FilledButton.icon(
        onPressed: onCreate,
        icon: const Icon(Icons.add),
        label: Text(actionLabel),
      ),
    );
  }
}

class _CommitmentProjection extends StatelessWidget {
  const _CommitmentProjection({
    required this.eyebrow,
    required this.title,
    required this.amountCents,
    required this.detail,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final int amountCents;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ZimbaColors.accentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: ZimbaColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ZimbaColors.secondaryText,
                    letterSpacing: .7,
                  ),
                ),
                const SizedBox(height: 2),
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ZimbaColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 88,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topRight,
              child: Text(
                formatBrl(amountCents),
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _kindLabel(String kind) {
  return switch (kind) {
    'income' => 'Receita',
    'transfer' => 'Transferencia',
    _ => 'Despesa',
  };
}

String _monthKey(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}';
}

int _signedAmount(int amountCents, String kind) {
  if (kind == 'income') {
    return amountCents.abs();
  }
  return -amountCents.abs();
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
