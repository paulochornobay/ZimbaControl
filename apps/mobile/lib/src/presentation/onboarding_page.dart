import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'design/instrument_display.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    required this.database,
    required this.onCompleted,
    super.key,
  });

  final AppDatabase database;
  final VoidCallback onCompleted;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

enum _OnboardingStep {
  welcome,
  person,
  institution,
  instrument,
  identity,
  card,
  categories,
  review,
}

class _OnboardingPageState extends State<OnboardingPage> {
  final personController = TextEditingController();
  final nameController = TextEditingController();
  final last4Controller = TextEditingController();
  final billingDayController = TextEditingController();
  final dueDayController = TextEditingController();
  var stepIndex = 0;
  var showErrors = false;
  var saving = false;
  String? error;
  String? institutionId;
  String? instrumentType;
  String? cardBrand;
  final selectedCategories = <String>{
    'FOOD',
    'HOME_GOODS',
    'TRANSPORT',
    'SALARY',
  };

  List<_OnboardingStep> get steps => [
    _OnboardingStep.welcome,
    _OnboardingStep.person,
    _OnboardingStep.institution,
    _OnboardingStep.instrument,
    _OnboardingStep.identity,
    if (instrumentType == 'credit_card') _OnboardingStep.card,
    _OnboardingStep.categories,
    _OnboardingStep.review,
  ];

  _OnboardingStep get step => steps[stepIndex.clamp(0, steps.length - 1)];
  _Institution? get institution => _institutions
      .cast<_Institution?>()
      .firstWhere((item) => item?.id == institutionId, orElse: () => null);

  @override
  void dispose() {
    personController.dispose();
    nameController.dispose();
    last4Controller.dispose();
    billingDayController.dispose();
    dueDayController.dispose();
    super.dispose();
  }

  String? _validationError() {
    return switch (step) {
      _OnboardingStep.person when personController.text.trim().isEmpty =>
        'Informe como devemos chamar você.',
      _OnboardingStep.institution when institution == null =>
        'Escolha uma instituição ou Outra instituição.',
      _OnboardingStep.instrument when instrumentType == null =>
        'Escolha se é conta, carteira ou cartão.',
      _OnboardingStep.identity when nameController.text.trim().isEmpty =>
        'Dê um nome claro para este instrumento.',
      _OnboardingStep.identity
          when last4Controller.text.trim().isNotEmpty &&
              !RegExp(r'^\d{4}$').hasMatch(last4Controller.text.trim()) =>
        'Os últimos dígitos devem ter quatro números.',
      _OnboardingStep.card when cardBrand == null =>
        'Escolha a bandeira do cartão.',
      _OnboardingStep.card
          when !_validDay(billingDayController.text) ||
              !_validDay(dueDayController.text) =>
        'Informe dias de fechamento e vencimento entre 1 e 31.',
      _ => null,
    };
  }

  bool _validDay(String value) {
    final day = int.tryParse(value.trim());
    return day != null && day >= 1 && day <= 31;
  }

  void _next() {
    final validation = _validationError();
    if (validation != null) {
      setState(() {
        showErrors = true;
        error = validation;
      });
      return;
    }
    setState(() {
      showErrors = false;
      error = null;
      if (stepIndex < steps.length - 1) stepIndex += 1;
    });
  }

  Future<void> _back() async {
    if (stepIndex > 0) {
      setState(() {
        stepIndex -= 1;
        showErrors = false;
        error = null;
      });
      return;
    }
    await _confirmInterruption();
  }

  Future<void> _confirmInterruption() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da configuração?'),
        content: const Text(
          'Nada foi criado no aparelho. Você pode continuar esta configuração enquanto esta tela estiver aberta.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continuar configurando'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair sem concluir'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      Navigator.maybeOf(context)?.pop();
    }
  }

  void _selectInstitution(_Institution item) {
    setState(() {
      institutionId = item.id;
      if (instrumentType != null && !item.types.contains(instrumentType)) {
        instrumentType = null;
      }
      _suggestName();
    });
  }

  void _selectInstrument(String value) {
    setState(() {
      instrumentType = value;
      _suggestName();
    });
  }

  void _suggestName() {
    if (nameController.text.trim().isNotEmpty) return;
    final selected = institution;
    if (selected == null || instrumentType == null) return;
    nameController.text =
        '${selected.label} ${instrumentTypeLabel(instrumentType!)}';
  }

  Future<void> _finish() async {
    final validation = _validationError();
    if (validation != null) {
      setState(() {
        error = validation;
        showErrors = true;
      });
      return;
    }
    final selected = institution;
    final type = instrumentType;
    if (selected == null || type == null) return;
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.database.saveInitialSetup(
        SetupInput(
          personName: personController.text,
          accountName: nameController.text,
          accountProvider: selected.id == 'other' ? 'manual' : selected.id,
          accountType: type,
          last4: last4Controller.text,
          cardBrand: cardBrand,
          billingDay: int.tryParse(billingDayController.text),
          dueDay: int.tryParse(dueDayController.text),
          starterCategoryKeys: selectedCategories,
        ),
      );
      if (mounted) widget.onCompleted();
    } catch (exception) {
      if (mounted) {
        setState(() {
          saving = false;
          error = exception is ArgumentError
              ? exception.message.toString()
              : 'Não foi possível concluir a configuração. Suas respostas continuam aqui.';
        });
      }
    }
  }

  Future<void> _loadDemo() async {
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.database.completeDemoOnboarding();
      if (mounted) widget.onCompleted();
    } catch (_) {
      if (mounted) {
        setState(() {
          saving = false;
          error = 'Não foi possível carregar a demonstração.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = step;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _ProgressHeader(
              current: stepIndex + 1,
              total: steps.length,
              onBack: saving ? null : _back,
              onClose: saving ? null : _confirmInterruption,
            ),
            Expanded(
              child: ListView(
                key: ValueKey('onboarding-${currentStep.name}'),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                children: [
                  _stepBody(context, currentStep),
                  if (showErrors && error != null) ...[
                    const SizedBox(height: 16),
                    ZimbaFeedbackBanner(
                      icon: Icons.error_outline,
                      title: 'Confira esta etapa',
                      body: error!,
                      tone: ZimbaTone.danger,
                    ),
                  ],
                ],
              ),
            ),
            _Footer(
              step: currentStep,
              saving: saving,
              onNext: _next,
              onFinish: _finish,
              onDemo: _loadDemo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBody(BuildContext context, _OnboardingStep current) {
    return switch (current) {
      _OnboardingStep.welcome => const _WelcomeStep(),
      _OnboardingStep.person => _PersonStep(controller: personController),
      _OnboardingStep.institution => _InstitutionStep(
        selectedId: institutionId,
        onSelect: _selectInstitution,
      ),
      _OnboardingStep.instrument => _InstrumentStep(
        institution: institution,
        selectedType: instrumentType,
        onSelect: _selectInstrument,
      ),
      _OnboardingStep.identity => _IdentityStep(
        institution: institution,
        instrumentType: instrumentType,
        nameController: nameController,
        last4Controller: last4Controller,
        personName: personController.text,
      ),
      _OnboardingStep.card => _CardStep(
        selectedBrand: cardBrand,
        billingDayController: billingDayController,
        dueDayController: dueDayController,
        onBrandSelected: (value) => setState(() => cardBrand = value),
      ),
      _OnboardingStep.categories => _CategoriesStep(
        selected: selectedCategories,
        onChanged: (key) => setState(() {
          if (!selectedCategories.add(key)) selectedCategories.remove(key);
        }),
      ),
      _OnboardingStep.review => _ReviewStep(
        personName: personController.text,
        institution: institution,
        instrumentType: instrumentType,
        name: nameController.text,
        last4: last4Controller.text,
        cardBrand: cardBrand,
        billingDay: billingDayController.text,
        dueDay: dueDayController.text,
        categories: selectedCategories,
      ),
    };
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.current,
    required this.total,
    required this.onBack,
    required this.onClose,
  });

  final int current;
  final int total;
  final VoidCallback? onBack;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ZimbaColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: current == 1 ? 'Sair da configuração' : 'Voltar',
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuração inicial',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Etapa $current de $total',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ZimbaColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Fechar configuração',
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: current / total, minHeight: 5),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.step,
    required this.saving,
    required this.onNext,
    required this.onFinish,
    required this.onDemo,
  });

  final _OnboardingStep step;
  final bool saving;
  final VoidCallback onNext;
  final VoidCallback onFinish;
  final VoidCallback onDemo;

  @override
  Widget build(BuildContext context) {
    final welcome = step == _OnboardingStep.welcome;
    final review = step == _OnboardingStep.review;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: ZimbaColors.surface,
        border: Border(top: BorderSide(color: ZimbaColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: saving
                    ? null
                    : review
                    ? onFinish
                    : onNext,
                icon: Icon(review ? Icons.check : Icons.arrow_forward),
                label: Text(
                  saving
                      ? 'Salvando no aparelho…'
                      : review
                      ? 'Concluir configuração'
                      : welcome
                      ? 'Começar configuração'
                      : 'Continuar',
                ),
              ),
            ),
            if (welcome) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: saving ? null : onDemo,
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('Explorar demonstração'),
                ),
              ),
            ],
            if (saving) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Organize as finanças da família\nsem depender da internet',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Vamos criar somente a pessoa, o primeiro instrumento e as categorias que você escolher.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: ZimbaColors.secondaryText),
        ),
        const SizedBox(height: 20),
        const ZimbaRows(
          children: [
            _FeatureRow(
              Icons.fact_check_outlined,
              'Você revisa antes de consolidar',
              'Nenhum lançamento fictício é criado.',
            ),
            _FeatureRow(
              Icons.lock_outline,
              'Dados locais primeiro',
              'Nada é conectado a banco ou nuvem agora.',
            ),
            _FeatureRow(
              Icons.credit_card_outlined,
              'Contas e cartões sem confusão',
              'Cartão tem fatura, fechamento e vencimento próprios.',
            ),
          ],
        ),
        const SizedBox(height: 16),
        const ZimbaFeedbackBanner(
          icon: Icons.info_outline,
          title: 'Demonstração é opcional',
          body:
              'Use-a somente se quiser dados de exemplo. A configuração normal começa vazia.',
          tone: ZimbaTone.neutral,
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      leading: CircleAvatar(
        backgroundColor: ZimbaColors.accentSoft,
        foregroundColor: ZimbaColors.accent,
        child: Icon(icon, size: 19),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
    );
  }
}

class _PersonStep extends StatelessWidget {
  const _PersonStep({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(
          'Quem vai usar o Zimba?',
          'Você poderá adicionar outras pessoas depois.',
        ),
        const SizedBox(height: 20),
        TextField(
          key: const ValueKey('onboarding-person'),
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Seu nome',
            hintText: 'Ex.: Marina',
          ),
        ),
      ],
    );
  }
}

class _InstitutionStep extends StatefulWidget {
  const _InstitutionStep({required this.selectedId, required this.onSelect});

  final String? selectedId;
  final ValueChanged<_Institution> onSelect;

  @override
  State<_InstitutionStep> createState() => _InstitutionStepState();
}

class _InstitutionStepState extends State<_InstitutionStep> {
  var query = '';

  @override
  Widget build(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final visible = _institutions.where((item) {
      if (normalized.isEmpty) return true;
      return item.label.toLowerCase().contains(normalized) ||
          item.aliases.any((alias) => alias.toLowerCase().contains(normalized));
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(
          'Onde está este instrumento?',
          'Escolha uma instituição ou use o fallback neutro para outra.',
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey('onboarding-institution-search'),
          onChanged: (value) => setState(() => query = value),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Buscar instituição',
          ),
        ),
        const SizedBox(height: 16),
        ZimbaRows(
          children: [
            for (final item in visible)
              _SelectionRow(
                selected: item.id == widget.selectedId,
                onTap: () => widget.onSelect(item),
                leading: _BrandMark(institution: item),
                title: item.label,
                subtitle: item.typeSummary,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Identidade visual por monogramas vetoriais; não usamos logos de terceiros.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
        ),
      ],
    );
  }
}

class _InstrumentStep extends StatelessWidget {
  const _InstrumentStep({
    required this.institution,
    required this.selectedType,
    required this.onSelect,
  });

  final _Institution? institution;
  final String? selectedType;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final types = institution?.types ?? const <String>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(
          'O que você quer cadastrar?',
          'Conta guarda saldo. Cartão cria uma fatura com fechamento e vencimento.',
        ),
        const SizedBox(height: 16),
        ZimbaRows(
          children: [
            for (final type in types)
              _SelectionRow(
                selected: type == selectedType,
                onTap: () => onSelect(type),
                leading: CircleAvatar(
                  backgroundColor: type == 'credit_card'
                      ? const Color(0xFFF3E8FF)
                      : ZimbaColors.accentSoft,
                  foregroundColor: type == 'credit_card'
                      ? const Color(0xFF7E22CE)
                      : ZimbaColors.accent,
                  child: Icon(instrumentTypeIcon(type)),
                ),
                title: instrumentTypeLabel(type),
                subtitle: _instrumentHint(type),
              ),
          ],
        ),
      ],
    );
  }
}

class _IdentityStep extends StatelessWidget {
  const _IdentityStep({
    required this.institution,
    required this.instrumentType,
    required this.nameController,
    required this.last4Controller,
    required this.personName,
  });

  final _Institution? institution;
  final String? instrumentType;
  final TextEditingController nameController;
  final TextEditingController last4Controller;
  final String personName;

  @override
  Widget build(BuildContext context) {
    final provider = institution?.id == 'other'
        ? 'manual'
        : institution?.id ?? 'manual';
    final type = instrumentType ?? 'account';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(
          'Como você chama isso no dia a dia?',
          'Um nome claro evita confundir conta e cartão do mesmo banco.',
        ),
        const SizedBox(height: 18),
        TextField(
          key: const ValueKey('onboarding-name'),
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nome amigável',
            hintText: 'Ex.: Conta da casa',
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          key: const ValueKey('onboarding-last4'),
          controller: last4Controller,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(
            labelText: 'Últimos quatro dígitos (opcional)',
            hintText: '1234',
            counterText: '',
          ),
        ),
        const SizedBox(height: 20),
        const ZimbaSectionTitle('PRÉVIA NA LISTA'),
        const SizedBox(height: 8),
        ZimbaCard(
          child: InstrumentDisplay(
            name: nameController.text.trim().isEmpty
                ? 'Sem nome ainda'
                : nameController.text.trim(),
            provider: provider,
            type: type,
            ownerName: personName.trim().isEmpty ? null : personName.trim(),
            last4: last4Controller.text,
          ),
        ),
      ],
    );
  }
}

class _CardStep extends StatelessWidget {
  const _CardStep({
    required this.selectedBrand,
    required this.billingDayController,
    required this.dueDayController,
    required this.onBrandSelected,
  });

  final String? selectedBrand;
  final TextEditingController billingDayController;
  final TextEditingController dueDayController;
  final ValueChanged<String> onBrandSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(
          'Dados do cartão',
          'Fechamento define a fatura; vencimento é o dia de pagamento.',
        ),
        const SizedBox(height: 18),
        const ZimbaSectionTitle('BANDEIRA'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final brand in _cardBrands)
              ChoiceChip(
                label: Text(brand),
                selected: brand == selectedBrand,
                onSelected: (_) => onBrandSelected(brand),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const ValueKey('onboarding-billing-day'),
                controller: billingDayController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: const InputDecoration(
                  labelText: 'Dia de fechamento',
                  hintText: '28',
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                key: const ValueKey('onboarding-due-day'),
                controller: dueDayController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: const InputDecoration(
                  labelText: 'Dia de vencimento',
                  hintText: '5',
                  counterText: '',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const ZimbaFeedbackBanner(
          icon: Icons.info_outline,
          title: 'Você confirma o ciclo',
          body:
              'Não preenchemos essas datas sozinhos; elas serão usadas nas faturas futuras.',
          tone: ZimbaTone.neutral,
        ),
      ],
    );
  }
}

class _CategoriesStep extends StatelessWidget {
  const _CategoriesStep({required this.selected, required this.onChanged});

  final Set<String> selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(
          'Categorias para começar',
          'Escolha o que faz sentido agora. Você pode ajustar tudo depois.',
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final category in _onboardingCategories)
              FilterChip(
                avatar: Icon(category.icon, size: 16, color: category.color),
                label: Text(category.label),
                selected: selected.contains(category.key),
                onSelected: (_) => onChanged(category.key),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ZimbaFeedbackBanner(
          icon: selected.isEmpty
              ? Icons.info_outline
              : Icons.check_circle_outline,
          title: selected.isEmpty
              ? 'Nenhuma categoria selecionada'
              : '${selected.length} categoria(s) inicial(is)',
          body: selected.isEmpty
              ? 'Tudo bem: você classifica cada lançamento na revisão quando quiser.'
              : 'Somente as categorias escolhidas serão criadas; não haverá lançamentos de exemplo.',
          tone: selected.isEmpty ? ZimbaTone.neutral : ZimbaTone.success,
        ),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.personName,
    required this.institution,
    required this.instrumentType,
    required this.name,
    required this.last4,
    required this.cardBrand,
    required this.billingDay,
    required this.dueDay,
    required this.categories,
  });

  final String personName;
  final _Institution? institution;
  final String? instrumentType;
  final String name;
  final String last4;
  final String? cardBrand;
  final String billingDay;
  final String dueDay;
  final Set<String> categories;

  @override
  Widget build(BuildContext context) {
    final categoryNames = _onboardingCategories
        .where((item) => categories.contains(item.key))
        .map((item) => item.label)
        .join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(
          'Confira antes de concluir',
          'Nada é criado até você confirmar.',
        ),
        const SizedBox(height: 18),
        _ReviewCard(title: 'Pessoa principal', value: personName),
        const SizedBox(height: 10),
        _ReviewCard(
          title: 'Conta ou cartão',
          value:
              '${institution?.label ?? 'Instituição'} · ${instrumentTypeLabel(instrumentType ?? 'account')}',
          detail: [
            name,
            if (last4.trim().isNotEmpty) '•••• ${last4.trim()}',
            if (instrumentType == 'credit_card')
              '${cardBrand ?? 'Bandeira'} · fecha dia $billingDay · vence dia $dueDay',
          ].join('\n'),
        ),
        const SizedBox(height: 10),
        _ReviewCard(
          title: 'Categorias iniciais',
          value: categoryNames.isEmpty
              ? 'Nenhuma categoria inicial'
              : categoryNames,
        ),
        const SizedBox(height: 16),
        const ZimbaFeedbackBanner(
          icon: Icons.lock_outline,
          title: 'Criação local e transacional',
          body:
              'Criamos apenas o que foi confirmado. A demonstração continua sendo uma escolha separada.',
          tone: ZimbaTone.success,
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.title, required this.value, this.detail});

  final String title;
  final String value;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ZimbaColors.secondaryText,
              letterSpacing: .7,
            ),
          ),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          if (detail != null) ...[
            const SizedBox(height: 3),
            Text(detail!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _StepTitle extends StatelessWidget {
  const _StepTitle(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -.4,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ZimbaColors.secondaryText,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({
    required this.selected,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      tileColor: selected ? ZimbaColors.accentSoft : null,
      leading: leading,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: selected
          ? const Icon(Icons.check_circle, color: ZimbaColors.accent)
          : null,
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.institution});

  final _Institution institution;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Monograma vetorial de ${institution.label}',
      child: CircleAvatar(
        backgroundColor: institution.color.withValues(alpha: .16),
        foregroundColor: institution.color,
        child: Text(
          institution.monogram,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

String _instrumentHint(String type) => switch (type) {
  'checking' => 'Saldo para entradas e saídas do dia a dia.',
  'savings' => 'Reserva guardada, com menos movimentação.',
  'wallet' => 'Conta de pagamento ou carteira digital.',
  'credit_card' => 'Compras entram em uma fatura mensal.',
  _ => 'Instrumento financeiro local.',
};

class _Institution {
  const _Institution(
    this.id,
    this.label,
    this.monogram,
    this.color,
    this.types,
    this.aliases,
  );

  final String id;
  final String label;
  final String monogram;
  final Color color;
  final List<String> types;
  final List<String> aliases;

  String get typeSummary => types.map(instrumentTypeLabel).join(' · ');
}

class _OnboardingCategory {
  const _OnboardingCategory(this.key, this.label, this.icon, this.color);

  final String key;
  final String label;
  final IconData icon;
  final Color color;
}

const _institutions = <_Institution>[
  _Institution(
    'nubank',
    'Nubank',
    'NU',
    Color(0xFF820AD1),
    ['wallet', 'credit_card'],
    ['nu'],
  ),
  _Institution(
    'mercado_pago',
    'Mercado Pago',
    'MP',
    Color(0xFF009EE3),
    ['wallet', 'credit_card'],
    ['mercadopago'],
  ),
  _Institution(
    'itau',
    'Itaú',
    'IT',
    Color(0xFFEC7000),
    ['checking', 'savings', 'credit_card'],
    ['itau'],
  ),
  _Institution(
    'caixa',
    'Caixa',
    'CX',
    Color(0xFF0070AF),
    ['checking', 'savings', 'credit_card'],
    ['cef'],
  ),
  _Institution(
    'inter',
    'Inter',
    'IN',
    Color(0xFFFF7A00),
    ['checking', 'credit_card'],
    ['banco inter'],
  ),
  _Institution(
    'santander',
    'Santander',
    'SA',
    Color(0xFFEC0000),
    ['checking', 'savings', 'credit_card'],
    ['sx'],
  ),
  _Institution(
    'picpay',
    'PicPay',
    'PP',
    Color(0xFF11C76F),
    ['wallet', 'credit_card'],
    ['pic pay'],
  ),
  _Institution(
    'other',
    'Outra instituição',
    '+',
    Color(0xFF475569),
    ['checking', 'savings', 'wallet', 'credit_card'],
    ['outro banco', 'manual'],
  ),
];

const _cardBrands = [
  'Visa',
  'Mastercard',
  'Elo',
  'American Express',
  'Hipercard',
  'Outra',
];

const _onboardingCategories = <_OnboardingCategory>[
  _OnboardingCategory(
    'FOOD',
    'Mercado',
    Icons.shopping_cart_outlined,
    ZimbaColors.success,
  ),
  _OnboardingCategory(
    'HOME_GOODS',
    'Casa',
    Icons.home_outlined,
    ZimbaColors.accent,
  ),
  _OnboardingCategory(
    'HEALTH',
    'Saúde',
    Icons.health_and_safety_outlined,
    ZimbaColors.destructive,
  ),
  _OnboardingCategory(
    'TRANSPORT',
    'Transporte',
    Icons.directions_car_outlined,
    Color(0xFF0891B2),
  ),
  _OnboardingCategory(
    'EDUCATION',
    'Educação',
    Icons.school_outlined,
    Color(0xFFD97706),
  ),
  _OnboardingCategory(
    'LEISURE',
    'Lazer',
    Icons.celebration_outlined,
    Color(0xFF7E22CE),
  ),
  _OnboardingCategory(
    'SALARY',
    'Renda',
    Icons.payments_outlined,
    ZimbaColors.success,
  ),
];
