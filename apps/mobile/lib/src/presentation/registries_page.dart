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
  }) : assert(initialTabIndex >= 0 && initialTabIndex < 3);

  final AppDatabase database;
  final int initialTabIndex;

  @override
  State<RegistriesPage> createState() => _RegistriesPageState();
}

class _RegistriesPageState extends State<RegistriesPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late Future<RegistrySnapshot> snapshotFuture;
  late int selectedTabIndex;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      initialIndex: widget.initialTabIndex,
      vsync: this,
    );
    selectedTabIndex = tabController.index;
    tabController.addListener(_handleTabChanged);
    snapshotFuture = widget.database.getRegistrySnapshot();
  }

  void _handleTabChanged() {
    if (tabController.indexIsChanging ||
        selectedTabIndex == tabController.index) {
      return;
    }
    setState(() => selectedTabIndex = tabController.index);
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabChanged);
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
    final kind = switch (tabController.index) {
      0 => 'person',
      1 => await _chooseNewRegistryKind(
        title: 'Novo instrumento',
        options: const [
          ('account', Icons.account_balance_wallet_outlined, 'Nova conta'),
          ('card', Icons.credit_card_outlined, 'Novo cartão'),
        ],
      ),
      _ => await _chooseNewRegistryKind(
        title: 'Nova classificação',
        options: const [
          ('category', Icons.category_outlined, 'Nova categoria'),
          ('cost-center', Icons.account_tree_outlined, 'Novo centro de custo'),
        ],
      ),
    };
    if (kind == null || !mounted) return;
    final result = await Navigator.of(context).push<Object?>(
      MaterialPageRoute(
        builder: (_) => switch (kind) {
          'person' => PersonFormPage(database: widget.database),
          'account' => AccountFormPage(
            database: widget.database,
            people: snapshot.people,
          ),
          'card' => CreditCardFormPage(
            database: widget.database,
            people: snapshot.people,
          ),
          'category' => CategoryFormPage(database: widget.database),
          _ => CostCenterFormPage(database: widget.database),
        },
      ),
    );
    if (result != null && mounted) {
      refresh();
    }
  }

  Future<String?> _chooseNewRegistryKind({
    required String title,
    required List<(String, IconData, String)> options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              for (final option in options)
                ListTile(
                  leading: Icon(option.$2),
                  title: Text(option.$3),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pop(option.$1),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 78,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cadastros'),
            Text(
              'Estruture a organização financeira da família',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: ZimbaColors.foreground,
          unselectedLabelColor: ZimbaColors.secondaryText,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          indicatorColor: ZimbaColors.accent,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Pessoas'),
            Tab(text: 'Contas'),
            Tab(text: 'Taxonomia'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openCurrentForm,
        backgroundColor: ZimbaColors.foreground,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ZimbaRadii.xl),
        ),
        icon: const Icon(Icons.add, size: 20),
        label: Text(_registryTabMeta[selectedTabIndex].newLabel),
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
          final counts = [
            data.people.length,
            data.accounts.length + data.creditCards.length,
            data.categories.length + data.costCenters.length,
          ];
          return Column(
            children: [
              _RegistryTabOverview(
                meta: _registryTabMeta[selectedTabIndex],
                count: counts[selectedTabIndex],
              ),
              Expanded(
                child: TabBarView(
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
                      cards: data.creditCards,
                      onChanged: refresh,
                    ),
                    _CategoryList(
                      database: widget.database,
                      categories: data.categories,
                      costCenters: data.costCenters,
                      onChanged: refresh,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

const _registryTabMeta = [
  _RegistryTabMeta(
    title: 'Pessoas',
    description: 'Quem participa das finanças e dos rateios.',
    newLabel: 'Nova pessoa',
    icon: Icons.people_alt_outlined,
  ),
  _RegistryTabMeta(
    title: 'Contas',
    description: 'Contas, cartões, limites e ciclos de fatura.',
    newLabel: 'Novo',
    icon: Icons.account_balance_wallet_outlined,
  ),
  _RegistryTabMeta(
    title: 'Taxonomia',
    description: 'Categorias e centros de custo da família.',
    newLabel: 'Novo',
    icon: Icons.category_outlined,
  ),
];

class _RegistryTabMeta {
  const _RegistryTabMeta({
    required this.title,
    required this.description,
    required this.newLabel,
    required this.icon,
  });

  final String title;
  final String description;
  final String newLabel;
  final IconData icon;
}

class _RegistryTabOverview extends StatelessWidget {
  const _RegistryTabOverview({required this.meta, required this.count});

  final _RegistryTabMeta meta;
  final int count;

  @override
  Widget build(BuildContext context) {
    final countLabel = '$count ${count == 1 ? 'cadastro' : 'cadastros'}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ZimbaColors.accentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(meta.icon, size: 21, color: ZimbaColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  meta.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ZimbaColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ZimbaBadge(label: countLabel, tone: ZimbaTone.info),
        ],
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
    required this.cards,
    required this.onChanged,
  });

  final AppDatabase database;
  final List<PersonRow> people;
  final List<AccountWithOwner> accounts;
  final List<CreditCardWithOwner> cards;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty && cards.isEmpty) {
      return const _EmptyRegistryState(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Nenhum instrumento',
        body: 'Cadastre contas ou cartões para organizar as movimentações.',
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
      children: [
        const ZimbaSectionTitle('Contas'),
        if (accounts.isEmpty)
          const _InlineEmptyRegistry('Nenhuma conta cadastrada.')
        else
          for (final item in accounts) ...[
            _InstrumentRegistryTile(
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
                if (result != null) onChanged();
              },
              onArchive: () async {
                await database.archiveAccount(
                  item.account.id,
                  active: !item.account.active,
                );
                onChanged();
              },
            ),
            const SizedBox(height: 8),
          ],
        const SizedBox(height: 8),
        const ZimbaSectionTitle('Cartões'),
        if (cards.isEmpty)
          const _InlineEmptyRegistry('Nenhum cartão cadastrado.')
        else
          for (final item in cards) ...[
            _InstrumentRegistryTile(
              instrument: InstrumentDisplay.card(item),
              footer:
                  '${item.creditCard.limitRole == 'additional' ? 'Adicional' : 'Principal'} · ${item.creditCard.brand ?? 'Cartão'} · fecha ${item.creditCard.billingDay ?? '-'} · vence ${item.creditCard.dueDay ?? '-'}',
              inactive: !item.creditCard.active,
              onTap: () async {
                final result = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (_) => CreditCardFormPage(
                      database: database,
                      people: people,
                      creditCard: item.creditCard,
                    ),
                  ),
                );
                if (result != null) onChanged();
              },
              onArchive: () async {
                await database.archiveCreditCard(
                  item.creditCard.id,
                  active: !item.creditCard.active,
                );
                onChanged();
              },
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }
}

class _InlineEmptyRegistry extends StatelessWidget {
  const _InlineEmptyRegistry(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ZimbaColors.surface,
      border: Border.all(color: ZimbaColors.border),
      borderRadius: BorderRadius.circular(ZimbaRadii.lg),
    ),
    child: Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
    ),
  );
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.database,
    required this.categories,
    required this.costCenters,
    required this.onChanged,
  });

  final AppDatabase database;
  final List<CategoryRow> categories;
  final List<CostCenterRow> costCenters;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty && costCenters.isEmpty) {
      return const _EmptyRegistryState(
        icon: Icons.category_outlined,
        title: 'Nenhuma categoria',
        body: 'Crie categorias para organizar receitas e despesas.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
      itemCount: categories.length + costCenters.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == categories.length) {
          return const ZimbaSectionTitle('Centros de custo');
        }
        if (index > categories.length) {
          final center = costCenters[index - categories.length - 1];
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
                  builder: (_) => CostCenterFormPage(
                    database: database,
                    costCenter: center,
                  ),
                ),
              );
              if (result != null) onChanged();
            },
            onArchive: () async {
              await database.archiveCostCenter(
                center.id,
                active: !center.active,
              );
              onChanged();
            },
          );
        }
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

// Kept for direct reuse by a future dedicated cost-center route.
// ignore: unused_element
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
  late final TextEditingController limitController;
  late final TextEditingController limitGroupNameController;
  late Future<List<CreditCardLimitGroupRow>> limitGroupsFuture;
  String? ownerPersonId;
  String? limitGroupId;
  String limitRole = 'primary';
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
    limitController = TextEditingController();
    limitGroupNameController = TextEditingController(text: card?.name ?? '');
    limitGroupId = card?.limitGroupId;
    limitRole = card?.limitRole ?? 'primary';
    limitGroupsFuture = widget.database.listCreditCardLimitGroups();
    ownerPersonId = card?.ownerPersonId;
    active = card?.active ?? true;
    _loadLimitGroup(limitGroupId);
  }

  Future<void> _loadLimitGroup(String? groupId) async {
    if (groupId == null) {
      limitController.clear();
      return;
    }
    final group = await widget.database.getCreditCardLimitGroup(groupId);
    if (!mounted || group == null) return;
    setState(() {
      limitGroupNameController.text = group.name;
      limitController.text = _moneyInput(group.totalLimitCents);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    providerController.dispose();
    brandController.dispose();
    last4Controller.dispose();
    billingDayController.dispose();
    dueDayController.dispose();
    limitController.dispose();
    limitGroupNameController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }
    final billingDay = int.tryParse(billingDayController.text);
    final dueDay = int.tryParse(dueDayController.text);
    final totalLimitCents = _parseMoneyInput(limitController.text);
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
      limitGroupId: limitGroupId,
      limitRole: limitGroupId == null ? 'primary' : limitRole,
      totalLimitCents: totalLimitCents == 0 ? null : totalLimitCents,
      limitGroupName: limitGroupNameController.text,
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
        const SizedBox(height: 20),
        Text('Limite do cartão', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        Text(
          'Cartões adicionais podem compartilhar o mesmo limite. O uso é calculado pelas faturas e parcelas futuras.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<CreditCardLimitGroupRow>>(
          future: limitGroupsFuture,
          builder: (context, snapshot) {
            final groups = snapshot.data ?? const <CreditCardLimitGroupRow>[];
            return DropdownButtonFormField<String?>(
              initialValue: groups.any((group) => group.id == limitGroupId)
                  ? limitGroupId
                  : null,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Grupo de limite',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Criar limite próprio'),
                ),
                for (final group in groups)
                  DropdownMenuItem(
                    value: group.id,
                    child: Text(
                      group.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  limitGroupId = value;
                  if (value == null) limitRole = 'primary';
                });
                _loadLimitGroup(value);
              },
            );
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: limitGroupNameController,
          decoration: const InputDecoration(
            labelText: 'Nome do limite compartilhado',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: limitController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Limite total',
            prefixText: 'R\$ ',
            hintText: 'Não informado',
            border: OutlineInputBorder(),
          ),
        ),
        if (limitGroupId != null) ...[
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'primary', label: Text('Principal')),
              ButtonSegment(value: 'additional', label: Text('Adicional')),
            ],
            selected: {limitRole},
            onSelectionChanged: (value) =>
                setState(() => limitRole = value.first),
          ),
        ],
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

String _moneyInput(int? cents) {
  if (cents == null) return '';
  final value = cents / 100;
  return value.toStringAsFixed(2).replaceAll('.', ',');
}

int _parseMoneyInput(String value) {
  final normalized = value
      .replaceAll(RegExp(r'[^0-9,.-]'), '')
      .replaceAll('.', '')
      .replaceAll(',', '.');
  return ((double.tryParse(normalized) ?? 0) * 100).round().abs();
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
        toolbarHeight: 72,
        leading: IconButton(
          tooltip: 'Voltar',
          onPressed: () => Navigator.of(context).pop(),
          color: ZimbaColors.accent,
          icon: const Icon(Icons.arrow_back),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(
              'Cadastro salvo somente neste aparelho',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
            ),
          ],
        ),
        actions: [
          Tooltip(
            message: 'Salvar',
            child: TextButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Salvar'),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const ZimbaSectionTitle('Informações'),
          ZimbaCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: ZimbaColors.surface,
          border: Border(top: BorderSide(color: ZimbaColors.border)),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: FilledButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Salvar cadastro'),
          ),
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
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    const SizedBox(height: 8),
                    ZimbaBadge(
                      label: inactive ? 'Arquivado' : 'Ativo',
                      tone: inactive ? ZimbaTone.neutral : ZimbaTone.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: inactive ? 'Reativar' : 'Arquivar',
                onPressed: onArchive,
                icon: Icon(
                  inactive ? Icons.unarchive_outlined : Icons.archive_outlined,
                  size: 19,
                ),
              ),
              const Icon(Icons.chevron_right, color: ZimbaColors.secondaryText),
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
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
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
                    onPressed: onArchive,
                    icon: Icon(
                      inactive
                          ? Icons.unarchive_outlined
                          : Icons.archive_outlined,
                      size: 19,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: ZimbaColors.secondaryText,
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
