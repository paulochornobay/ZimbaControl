import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'design/instrument_display.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

class RegistriesPage extends StatefulWidget {
  const RegistriesPage({
    required this.database,
    this.initialTabIndex = 0,
    super.key,
  }) : assert(initialTabIndex >= 0 && initialTabIndex < 5);

  final AppDatabase database;
  final int initialTabIndex;

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
    tabController = TabController(
      length: 5,
      initialIndex: widget.initialTabIndex,
      vsync: this,
    );
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
    final result = await Navigator.of(context).push<Object?>(
      MaterialPageRoute(
        builder: (_) => switch (tabController.index) {
          0 => PersonFormPage(database: widget.database),
          1 => AccountFormPage(
            database: widget.database,
            people: snapshot.people,
          ),
          2 => CreditCardFormPage(
            database: widget.database,
            people: snapshot.people,
          ),
          3 => CategoryFormPage(database: widget.database),
          _ => CostCenterFormPage(database: widget.database),
        },
      ),
    );
    if (result != null && mounted) {
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
            Tab(text: 'Pessoas'),
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
              _PersonList(
                database: widget.database,
                people: data.people,
                onChanged: refresh,
              ),
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

class _PersonList extends StatelessWidget {
  const _PersonList({
    required this.database,
    required this.people,
    required this.onChanged,
  });

  final AppDatabase database;
  final List<PersonRow> people;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (people.isEmpty) {
      return const _EmptyRegistryState(
        icon: Icons.people_alt_outlined,
        title: 'Nenhuma pessoa',
        body: 'Cadastre quem participa das finanças da família.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
      itemCount: people.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final person = people[index];
        return _RegistryTile(
          icon: person.kind == 'child'
              ? Icons.child_care_outlined
              : Icons.person_outline,
          title: person.displayName,
          subtitle: person.kind == 'child' ? 'Dependente' : 'Adulto',
          inactive: !person.active,
          onTap: () async {
            final result = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) =>
                    PersonFormPage(database: database, person: person),
              ),
            );
            if (result == true) {
              onChanged();
            }
          },
          onArchive: () async {
            await database.archivePerson(person.id, active: !person.active);
            onChanged();
          },
        );
      },
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
      itemCount: accounts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = accounts[index];
        return _InstrumentRegistryTile(
          instrument: InstrumentDisplay.account(item),
          inactive: !item.account.active,
          onTap: () async {
            final result = await Navigator.of(context).push<String>(
              MaterialPageRoute(
                builder: (_) => AccountFormPage(
                  database: database,
                  people: people,
                  account: item.account,
                ),
              ),
            );
            if (result != null) {
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
      itemCount: cards.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = cards[index];
        final card = item.creditCard;
        return _InstrumentRegistryTile(
          instrument: InstrumentDisplay.card(item),
          footer:
              '${card.brand ?? 'Cartão'} · fecha ${card.billingDay ?? '-'} · vence ${card.dueDay ?? '-'}',
          inactive: !card.active,
          onTap: () async {
            final result = await Navigator.of(context).push<String>(
              MaterialPageRoute(
                builder: (_) => CreditCardFormPage(
                  database: database,
                  people: people,
                  creditCard: card,
                ),
              ),
            );
            if (result != null) {
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
      itemCount: categories.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _RegistryTile(
          leading: ClassificationBadge(
            iconKey: category.iconKey,
            colorKey: category.colorKey,
          ),
          title: category.name,
          subtitle:
              '${_kindLabel(category.kind)} · ordem ${category.sortOrder}',
          inactive: !category.active,
          onTap: () async {
            final result = await Navigator.of(context).push<String>(
              MaterialPageRoute(
                builder: (_) =>
                    CategoryFormPage(database: database, category: category),
              ),
            );
            if (result != null) {
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
      itemCount: costCenters.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final center = costCenters[index];
        return _RegistryTile(
          leading: ClassificationBadge(
            iconKey: center.iconKey,
            colorKey: center.colorKey,
          ),
          title: center.name,
          subtitle: center.active ? 'Ativo' : 'Arquivado',
          inactive: !center.active,
          onTap: () async {
            final result = await Navigator.of(context).push<String>(
              MaterialPageRoute(
                builder: (_) =>
                    CostCenterFormPage(database: database, costCenter: center),
              ),
            );
            if (result != null) {
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

class PersonFormPage extends StatefulWidget {
  const PersonFormPage({required this.database, this.person, super.key});

  final AppDatabase database;
  final PersonRow? person;

  @override
  State<PersonFormPage> createState() => _PersonFormPageState();
}

class _PersonFormPageState extends State<PersonFormPage> {
  late final TextEditingController nameController;
  late String kind;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.person?.displayName);
    kind = widget.person?.kind ?? 'adult';
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
    await widget.database.upsertPerson(
      id: widget.person?.id,
      displayName: nameController.text,
      kind: kind,
      active: widget.person?.active ?? true,
    );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _RegistryFormScaffold(
      title: widget.person == null ? 'Nova pessoa' : 'Editar pessoa',
      onSave: save,
      children: [
        TextField(
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nome',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: 'adult', label: Text('Adulto')),
            ButtonSegment(value: 'child', label: Text('Dependente')),
            ButtonSegment(value: 'other', label: Text('Outro')),
          ],
          selected: {kind},
          onSelectionChanged: (value) => setState(() => kind = value.first),
        ),
      ],
    );
  }
}

class AccountFormPage extends StatefulWidget {
  const AccountFormPage({
    required this.database,
    required this.people,
    this.account,
    this.initialProvider,
    this.initialLast4,
    this.initialType,
    super.key,
  });

  final AppDatabase database;
  final List<PersonRow> people;
  final AccountRow? account;
  final String? initialProvider;
  final String? initialLast4;
  final String? initialType;

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
      text: account?.provider ?? widget.initialProvider ?? 'manual',
    );
    last4Controller = TextEditingController(
      text: account?.last4 ?? widget.initialLast4 ?? '',
    );
    type = account?.type ?? widget.initialType ?? 'account';
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
    final id = await widget.database.upsertAccount(
      id: widget.account?.id,
      provider: providerController.text,
      name: nameController.text,
      type: type,
      ownerPersonId: ownerPersonId,
      last4: last4Controller.text,
      active: active,
    );
    if (mounted) {
      Navigator.of(context).pop(id);
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
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Tipo',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'account', child: Text('Conta')),
            DropdownMenuItem(value: 'checking', child: Text('Conta corrente')),
            DropdownMenuItem(value: 'savings', child: Text('Poupança')),
            DropdownMenuItem(value: 'wallet', child: Text('Carteira')),
            DropdownMenuItem(value: 'credit_card', child: Text('Cartao')),
          ],
          onChanged: (value) => setState(() => type = value ?? 'account'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          initialValue: ownerPersonId,
          isExpanded: true,
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
                child: Text(
                  person.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
    this.initialProvider,
    this.initialLast4,
    super.key,
  });

  final AppDatabase database;
  final List<PersonRow> people;
  final CreditCardRow? creditCard;
  final String? initialProvider;
  final String? initialLast4;

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
      text: card?.provider ?? widget.initialProvider ?? 'manual',
    );
    brandController = TextEditingController(text: card?.brand ?? '');
    last4Controller = TextEditingController(
      text: card?.last4 ?? widget.initialLast4 ?? '',
    );
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
    final cardId = await widget.database.upsertCreditCard(
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
      final card = await widget.database.getCreditCard(cardId);
      if (mounted) {
        Navigator.of(context).pop(card?.accountId);
      }
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
          isExpanded: true,
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
                child: Text(
                  person.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
  const CategoryFormPage({
    required this.database,
    this.category,
    this.initialKind = 'expense',
    super.key,
  });

  final AppDatabase database;
  final CategoryRow? category;
  final String initialKind;

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  late final TextEditingController nameController;
  late final TextEditingController sortOrderController;
  late String kind;
  late String iconKey;
  late String colorKey;
  late bool active;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    nameController = TextEditingController(text: category?.name ?? '');
    sortOrderController = TextEditingController(
      text: (category?.sortOrder ?? 100).toString(),
    );
    kind = category?.kind ?? widget.initialKind;
    final visual = suggestClassificationVisual(
      category?.name ?? '',
      kind: kind,
    );
    iconKey = category?.iconKey ?? visual.$1;
    colorKey = category?.colorKey ?? visual.$2;
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
    final id = await widget.database.upsertCategory(
      id: widget.category?.id,
      parentId: widget.category?.parentId,
      name: nameController.text,
      kind: kind,
      iconKey: iconKey,
      colorKey: colorKey,
      sortOrder: int.tryParse(sortOrderController.text) ?? 100,
      active: active,
    );
    if (mounted) {
      Navigator.of(context).pop(id);
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
          isExpanded: true,
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
        _ClassificationVisualEditor(
          iconKey: iconKey,
          colorKey: colorKey,
          onIconChanged: (value) => setState(() => iconKey = value),
          onColorChanged: (value) => setState(() => colorKey = value),
          onSuggest: () {
            final visual = suggestClassificationVisual(
              nameController.text,
              kind: kind,
            );
            setState(() {
              iconKey = visual.$1;
              colorKey = visual.$2;
            });
          },
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
  late String iconKey;
  late String colorKey;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.costCenter?.name ?? '');
    active = widget.costCenter?.active ?? true;
    final visual = suggestClassificationVisual(
      widget.costCenter?.name ?? '',
      costCenter: true,
    );
    iconKey = widget.costCenter?.iconKey ?? visual.$1;
    colorKey = widget.costCenter?.colorKey ?? visual.$2;
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
    final id = await widget.database.upsertCostCenter(
      id: widget.costCenter?.id,
      name: nameController.text,
      iconKey: iconKey,
      colorKey: colorKey,
      active: active,
    );
    if (mounted) {
      Navigator.of(context).pop(id);
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
        const SizedBox(height: 12),
        _ClassificationVisualEditor(
          iconKey: iconKey,
          colorKey: colorKey,
          onIconChanged: (value) => setState(() => iconKey = value),
          onColorChanged: (value) => setState(() => colorKey = value),
          onSuggest: () {
            final visual = suggestClassificationVisual(
              nameController.text,
              costCenter: true,
            );
            setState(() {
              iconKey = visual.$1;
              colorKey = visual.$2;
            });
          },
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

class _RegistryTile extends StatelessWidget {
  const _RegistryTile({
    this.icon,
    this.leading,
    required this.title,
    required this.subtitle,
    required this.inactive,
    required this.onTap,
    required this.onArchive,
  });

  final IconData? icon;
  final Widget? leading;
  final String title;
  final String subtitle;
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
              leading ??
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: inactive
                          ? ZimbaColors.surfaceMuted
                          : ZimbaColors.accentSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon ?? Icons.sell_outlined,
                      size: 20,
                      color: inactive
                          ? ZimbaColors.secondaryText
                          : ZimbaColors.accent,
                    ),
                  ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
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

class _InstrumentRegistryTile extends StatelessWidget {
  const _InstrumentRegistryTile({
    required this.instrument,
    required this.inactive,
    required this.onTap,
    required this.onArchive,
    this.footer,
  });

  final InstrumentDisplay instrument;
  final String? footer;
  final bool inactive;
  final VoidCallback onTap;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ZimbaLayout.cardRadius),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(opacity: inactive ? .55 : 1, child: instrument),
              if (footer != null) ...[
                const SizedBox(height: 8),
                Text(
                  footer!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ZimbaColors.secondaryText,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  ZimbaBadge(
                    label: inactive ? 'Arquivado' : 'Ativo',
                    tone: inactive ? ZimbaTone.neutral : ZimbaTone.success,
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
      ),
    );
  }
}

class _ClassificationVisualEditor extends StatelessWidget {
  const _ClassificationVisualEditor({
    required this.iconKey,
    required this.colorKey,
    required this.onIconChanged,
    required this.onColorChanged,
    required this.onSuggest,
  });

  final String iconKey;
  final String colorKey;
  final ValueChanged<String> onIconChanged;
  final ValueChanged<String> onColorChanged;
  final VoidCallback onSuggest;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Text('Ícone e cor')),
            TextButton.icon(
              onPressed: onSuggest,
              icon: const Icon(Icons.auto_awesome_outlined, size: 17),
              label: const Text('Sugerir'),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final key in classificationIconKeys)
              InkWell(
                onTap: () => onIconChanged(key),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconKey == key
                        ? classificationColor(colorKey).withValues(alpha: .15)
                        : ZimbaColors.surfaceMuted,
                    border: Border.all(
                      color: iconKey == key
                          ? classificationColor(colorKey)
                          : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    classificationIcon(key),
                    size: 20,
                    color: classificationColor(colorKey),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final key in classificationColorKeys)
              InkWell(
                onTap: () => onColorChanged(key),
                customBorder: const CircleBorder(),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: classificationColor(key),
                    border: Border.all(
                      color: colorKey == key
                          ? ZimbaColors.foreground
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: colorKey == key
                      ? const Icon(Icons.check, color: Colors.white, size: 17)
                      : null,
                ),
              ),
          ],
        ),
      ],
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
    return ZimbaStateMessage(
      icon: icon,
      title: title,
      body: body,
      action: onRetry == null
          ? null
          : OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
    );
  }
}

String _kindLabel(String kind) {
  return switch (kind) {
    'income' => 'Receita',
    'expense' => 'Despesa',
    _ => kind,
  };
}
