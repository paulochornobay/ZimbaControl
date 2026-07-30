import 'package:flutter/material.dart';

import '../data/local/app_database.dart';

class RegistriesPage extends StatefulWidget {
  const RegistriesPage({required this.database, super.key});

  final AppDatabase database;

  @override
  State<RegistriesPage> createState() => _RegistriesPageState();
}

class _RegistriesPageState extends State<RegistriesPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late Future<RegistrySnapshot> snapshotFuture;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    snapshotFuture = widget.database.getRegistrySnapshot();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      snapshotFuture = widget.database.getRegistrySnapshot();
    });
  }

  Future<void> openCurrentForm() async {
    final snapshot = await snapshotFuture;
    if (!mounted) {
      return;
    }
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => switch (tabController.index) {
          0 => AccountFormPage(
            database: widget.database,
            people: snapshot.people,
          ),
          1 => CreditCardFormPage(
            database: widget.database,
            people: snapshot.people,
          ),
          2 => CategoryFormPage(database: widget.database),
          _ => CostCenterFormPage(database: widget.database),
        },
      ),
    );
    if (result == true && mounted) {
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
            Text('Cadastros'),
            Text(
              'Contas, cartoes e categorias',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Contas'),
            Tab(text: 'Cartoes'),
            Tab(text: 'Categorias'),
            Tab(text: 'Centros'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openCurrentForm,
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
      body: FutureBuilder<RegistrySnapshot>(
        future: snapshotFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return _EmptyRegistryState(
              icon: Icons.error_outline,
              title: 'Nao foi possivel carregar',
              body: 'Tente abrir os cadastros novamente.',
              onRetry: refresh,
            );
          }
          final data = snapshot.data!;
          return TabBarView(
            controller: tabController,
            children: [
              _AccountList(
                database: widget.database,
                people: data.people,
                accounts: data.accounts,
                onChanged: refresh,
              ),
              _CardList(
                database: widget.database,
                people: data.people,
                cards: data.creditCards,
                onChanged: refresh,
              ),
              _CategoryList(
                database: widget.database,
                categories: data.categories,
                onChanged: refresh,
              ),
              _CostCenterList(
                database: widget.database,
                costCenters: data.costCenters,
                onChanged: refresh,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AccountList extends StatelessWidget {
  const _AccountList({
    required this.database,
    required this.people,
    required this.accounts,
    required this.onChanged,
  });

  final AppDatabase database;
  final List<PersonRow> people;
  final List<AccountWithOwner> accounts;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return const _EmptyRegistryState(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Nenhuma conta',
        body: 'Cadastre contas correntes, carteiras e instrumentos locais.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: accounts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = accounts[index];
        return _RegistryTile(
          icon: item.account.type == 'credit_card'
              ? Icons.credit_card_outlined
              : Icons.account_balance_wallet_outlined,
          title: item.account.name,
          subtitle:
              '${_providerLabel(item.account.provider)} · ${item.ownerLabel}',
          inactive: !item.account.active,
          onTap: () async {
            final result = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => AccountFormPage(
                  database: database,
                  people: people,
                  account: item.account,
                ),
              ),
            );
            if (result == true) {
              onChanged();
            }
          },
          onArchive: () async {
            await database.archiveAccount(
              item.account.id,
              active: !item.account.active,
            );
            onChanged();
          },
        );
      },
    );
  }
}

class _CardList extends StatelessWidget {
  const _CardList({
    required this.database,
    required this.people,
    required this.cards,
    required this.onChanged,
  });

  final AppDatabase database;
  final List<PersonRow> people;
  final List<CreditCardWithOwner> cards;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const _EmptyRegistryState(
        icon: Icons.credit_card_outlined,
        title: 'Nenhum cartao',
        body: 'Cadastre cartoes para classificar faturas e parcelas.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: cards.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = cards[index];
        final card = item.creditCard;
        return _RegistryTile(
          icon: Icons.credit_card_outlined,
          title: card.name,
          subtitle:
              '${card.brand ?? 'Cartao'} · ${item.ownerLabel} · fecha ${card.billingDay ?? '-'} · vence ${card.dueDay ?? '-'}',
          inactive: !card.active,
          onTap: () async {
            final result = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => CreditCardFormPage(
                  database: database,
                  people: people,
                  creditCard: card,
                ),
              ),
            );
            if (result == true) {
              onChanged();
            }
          },
          onArchive: () async {
            await database.archiveCreditCard(card.id, active: !card.active);
            onChanged();
          },
        );
      },
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.database,
    required this.categories,
    required this.onChanged,
  });

  final AppDatabase database;
  final List<CategoryRow> categories;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const _EmptyRegistryState(
        icon: Icons.category_outlined,
        title: 'Nenhuma categoria',
        body: 'Crie categorias para organizar receitas e despesas.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: categories.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _RegistryTile(
          icon: Icons.category_outlined,
          title: category.name,
          subtitle:
              '${_kindLabel(category.kind)} · ordem ${category.sortOrder}',
          inactive: !category.active,
          onTap: () async {
            final result = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) =>
                    CategoryFormPage(database: database, category: category),
              ),
            );
            if (result == true) {
              onChanged();
            }
          },
          onArchive: () async {
            await database.archiveCategory(
              category.id,
              active: !category.active,
            );
            onChanged();
          },
        );
      },
    );
  }
}

class _CostCenterList extends StatelessWidget {
  const _CostCenterList({
    required this.database,
    required this.costCenters,
    required this.onChanged,
  });

  final AppDatabase database;
  final List<CostCenterRow> costCenters;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (costCenters.isEmpty) {
      return const _EmptyRegistryState(
        icon: Icons.account_tree_outlined,
        title: 'Nenhum centro',
        body: 'Cadastre centros de custo para separar casa, filhos e trabalho.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: costCenters.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final center = costCenters[index];
        return _RegistryTile(
          icon: Icons.account_tree_outlined,
          title: center.name,
          subtitle: center.active ? 'Ativo' : 'Arquivado',
          inactive: !center.active,
          onTap: () async {
            final result = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) =>
                    CostCenterFormPage(database: database, costCenter: center),
              ),
            );
            if (result == true) {
              onChanged();
            }
          },
          onArchive: () async {
            await database.archiveCostCenter(center.id, active: !center.active);
            onChanged();
          },
        );
      },
    );
  }
}

class AccountFormPage extends StatefulWidget {
  const AccountFormPage({
    required this.database,
    required this.people,
    this.account,
    super.key,
  });

  final AppDatabase database;
  final List<PersonRow> people;
  final AccountRow? account;

  @override
  State<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  late final TextEditingController nameController;
  late final TextEditingController providerController;
  late final TextEditingController last4Controller;
  late String type;
  String? ownerPersonId;
  late bool active;

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    nameController = TextEditingController(text: account?.name ?? '');
    providerController = TextEditingController(
      text: account?.provider ?? 'manual',
    );
    last4Controller = TextEditingController(text: account?.last4 ?? '');
    type = account?.type ?? 'account';
    ownerPersonId = account?.ownerPersonId;
    active = account?.active ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    providerController.dispose();
    last4Controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }
    await widget.database.upsertAccount(
      id: widget.account?.id,
      provider: providerController.text,
      name: nameController.text,
      type: type,
      ownerPersonId: ownerPersonId,
      last4: last4Controller.text,
      active: active,
    );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _RegistryFormScaffold(
      title: widget.account == null ? 'Nova conta' : 'Editar conta',
      onSave: save,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: providerController,
          decoration: const InputDecoration(
            labelText: 'Provedor',
            helperText: 'Ex.: nubank, mercado_pago ou manual',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: type,
          decoration: const InputDecoration(
            labelText: 'Tipo',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'account', child: Text('Conta corrente')),
            DropdownMenuItem(value: 'wallet', child: Text('Carteira')),
            DropdownMenuItem(value: 'credit_card', child: Text('Cartao')),
          ],
          onChanged: (value) => setState(() => type = value ?? 'account'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          initialValue: ownerPersonId,
          decoration: const InputDecoration(
            labelText: 'Proprietario',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Sem proprietario'),
            ),
            for (final person in widget.people)
              DropdownMenuItem(
                value: person.id,
                child: Text(person.displayName),
              ),
          ],
          onChanged: (value) => setState(() => ownerPersonId = value),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: last4Controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Final',
            helperText: 'Opcional',
            border: OutlineInputBorder(),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativo'),
          value: active,
          onChanged: (value) => setState(() => active = value),
        ),
      ],
    );
  }
}

class CreditCardFormPage extends StatefulWidget {
  const CreditCardFormPage({
    required this.database,
    required this.people,
    this.creditCard,
    super.key,
  });

  final AppDatabase database;
  final List<PersonRow> people;
  final CreditCardRow? creditCard;

  @override
  State<CreditCardFormPage> createState() => _CreditCardFormPageState();
}

class _CreditCardFormPageState extends State<CreditCardFormPage> {
  late final TextEditingController nameController;
  late final TextEditingController providerController;
  late final TextEditingController brandController;
  late final TextEditingController last4Controller;
  late final TextEditingController billingDayController;
  late final TextEditingController dueDayController;
  String? ownerPersonId;
  late bool active;

  @override
  void initState() {
    super.initState();
    final card = widget.creditCard;
    nameController = TextEditingController(text: card?.name ?? '');
    providerController = TextEditingController(
      text: card?.provider ?? 'manual',
    );
    brandController = TextEditingController(text: card?.brand ?? '');
    last4Controller = TextEditingController(text: card?.last4 ?? '');
    billingDayController = TextEditingController(
      text: card?.billingDay?.toString() ?? '',
    );
    dueDayController = TextEditingController(
      text: card?.dueDay?.toString() ?? '',
    );
    ownerPersonId = card?.ownerPersonId;
    active = card?.active ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    providerController.dispose();
    brandController.dispose();
    last4Controller.dispose();
    billingDayController.dispose();
    dueDayController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }
    final billingDay = int.tryParse(billingDayController.text);
    final dueDay = int.tryParse(dueDayController.text);
    if (!_isValidDay(billingDay) || !_isValidDay(dueDay)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe fechamento e vencimento entre 1 e 31.'),
        ),
      );
      return;
    }
    await widget.database.upsertCreditCard(
      id: widget.creditCard?.id,
      accountId: widget.creditCard?.accountId,
      provider: providerController.text,
      name: nameController.text,
      ownerPersonId: ownerPersonId,
      brand: brandController.text,
      last4: last4Controller.text,
      billingDay: billingDay,
      dueDay: dueDay,
      active: active,
    );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _RegistryFormScaffold(
      title: widget.creditCard == null ? 'Novo cartao' : 'Editar cartao',
      onSave: save,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: providerController,
          decoration: const InputDecoration(
            labelText: 'Provedor',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          initialValue: ownerPersonId,
          decoration: const InputDecoration(
            labelText: 'Proprietario',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Sem proprietario'),
            ),
            for (final person in widget.people)
              DropdownMenuItem(
                value: person.id,
                child: Text(person.displayName),
              ),
          ],
          onChanged: (value) => setState(() => ownerPersonId = value),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: brandController,
                decoration: const InputDecoration(
                  labelText: 'Bandeira',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: last4Controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Final',
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
                controller: billingDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fechamento',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
          ],
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativo'),
          value: active,
          onChanged: (value) => setState(() => active = value),
        ),
      ],
    );
  }
}

bool _isValidDay(int? value) {
  return value != null && value >= 1 && value <= 31;
}

class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({required this.database, this.category, super.key});

  final AppDatabase database;
  final CategoryRow? category;

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  late final TextEditingController nameController;
  late final TextEditingController sortOrderController;
  late String kind;
  late bool active;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    nameController = TextEditingController(text: category?.name ?? '');
    sortOrderController = TextEditingController(
      text: (category?.sortOrder ?? 100).toString(),
    );
    kind = category?.kind ?? 'expense';
    active = category?.active ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    sortOrderController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }
    await widget.database.upsertCategory(
      id: widget.category?.id,
      parentId: widget.category?.parentId,
      name: nameController.text,
      kind: kind,
      sortOrder: int.tryParse(sortOrderController.text) ?? 100,
      active: active,
    );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _RegistryFormScaffold(
      title: widget.category == null ? 'Nova categoria' : 'Editar categoria',
      onSave: save,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: kind,
          decoration: const InputDecoration(
            labelText: 'Tipo',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'expense', child: Text('Despesa')),
            DropdownMenuItem(value: 'income', child: Text('Receita')),
          ],
          onChanged: (value) => setState(() => kind = value ?? 'expense'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: sortOrderController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Ordem',
            border: OutlineInputBorder(),
          ),
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

class CostCenterFormPage extends StatefulWidget {
  const CostCenterFormPage({
    required this.database,
    this.costCenter,
    super.key,
  });

  final AppDatabase database;
  final CostCenterRow? costCenter;

  @override
  State<CostCenterFormPage> createState() => _CostCenterFormPageState();
}

class _CostCenterFormPageState extends State<CostCenterFormPage> {
  late final TextEditingController nameController;
  late bool active;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.costCenter?.name ?? '');
    active = widget.costCenter?.active ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }
    await widget.database.upsertCostCenter(
      id: widget.costCenter?.id,
      name: nameController.text,
      active: active,
    );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _RegistryFormScaffold(
      title: widget.costCenter == null ? 'Novo centro' : 'Editar centro',
      onSave: save,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome',
            border: OutlineInputBorder(),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativo'),
          value: active,
          onChanged: (value) => setState(() => active = value),
        ),
      ],
    );
  }
}

class _RegistryFormScaffold extends StatelessWidget {
  const _RegistryFormScaffold({
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(children: children),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Salvar localmente'),
          ),
        ],
      ),
    );
  }
}

class _RegistryTile extends StatelessWidget {
  const _RegistryTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.inactive,
    required this.onTap,
    required this.onArchive,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool inactive;
  final VoidCallback onTap;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: inactive
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, size: 20),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          inactive ? '$subtitle · arquivado' : subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          tooltip: inactive ? 'Reativar' : 'Arquivar',
          onPressed: onArchive,
          icon: Icon(
            inactive ? Icons.unarchive_outlined : Icons.archive_outlined,
          ),
        ),
      ),
    );
  }
}

class _EmptyRegistryState extends StatelessWidget {
  const _EmptyRegistryState({
    required this.icon,
    required this.title,
    required this.body,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 46),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _providerLabel(String provider) {
  return switch (provider) {
    'mercado_pago' => 'Mercado Pago',
    'nubank' => 'Nubank',
    'manual' => 'Manual',
    _ => provider,
  };
}

String _kindLabel(String kind) {
  return switch (kind) {
    'income' => 'Receita',
    'expense' => 'Despesa',
    _ => kind,
  };
}
