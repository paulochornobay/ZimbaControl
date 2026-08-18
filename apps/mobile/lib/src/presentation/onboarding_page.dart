import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'design/zimba_theme.dart';

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

class _OnboardingPageState extends State<OnboardingPage> {
  final personController = TextEditingController();
  final accountController = TextEditingController();
  final providerController = TextEditingController();
  var configuring = false;
  var saving = false;
  var starterCategories = true;
  String? error;

  @override
  void dispose() {
    personController.dispose();
    accountController.dispose();
    providerController.dispose();
    super.dispose();
  }

  Future<void> saveSetup() async {
    if (personController.text.trim().isEmpty ||
        accountController.text.trim().isEmpty) {
      setState(() => error = 'Informe seu nome e a primeira conta.');
      return;
    }
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.database.saveInitialSetup(
        SetupInput(
          personName: personController.text,
          accountName: accountController.text,
          accountProvider: providerController.text,
          createStarterCategories: starterCategories,
        ),
      );
      widget.onCompleted();
    } catch (_) {
      if (mounted) {
        setState(() {
          saving = false;
          error = 'Não foi possível concluir a configuração.';
        });
      }
    }
  }

  Future<void> loadDemo() async {
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.database.completeDemoOnboarding();
      widget.onCompleted();
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: configuring ? _setupForm(context) : _welcome(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _welcome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ZimbaColors.accentSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: ZimbaColors.accent,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Suas finanças,\nsem bagunça.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Configure sua família e a primeira conta. Seus dados ficam neste aparelho e o app funciona sem internet.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: ZimbaColors.secondaryText),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: saving ? null : () => setState(() => configuring = true),
          child: const Text('Configurar meus dados'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: saving ? null : loadDemo,
          icon: const Icon(Icons.science_outlined),
          label: const Text('Explorar demonstração'),
        ),
        const SizedBox(height: 12),
        Text(
          'A demonstração é opcional e pode ser apagada depois.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
        ),
        if (saving) ...[
          const SizedBox(height: 20),
          const LinearProgressIndicator(),
        ],
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(error!, style: const TextStyle(color: ZimbaColors.destructive)),
        ],
      ],
    );
  }

  Widget _setupForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: saving
                ? null
                : () => setState(() {
                    configuring = false;
                    error = null;
                  }),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Configuração inicial',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          'Você poderá alterar tudo depois em Ajustes.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: ZimbaColors.secondaryText),
        ),
        const SizedBox(height: 24),
        const ZimbaSectionTitle('Pessoa principal'),
        TextField(
          controller: personController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Seu nome',
            hintText: 'Ex.: Paulo',
          ),
        ),
        const SizedBox(height: 20),
        const ZimbaSectionTitle('Primeira conta'),
        TextField(
          controller: accountController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nome da conta',
            hintText: 'Ex.: Nubank',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: providerController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Banco ou instituição',
            hintText: 'Opcional',
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: SwitchListTile(
            value: starterCategories,
            onChanged: saving
                ? null
                : (value) => setState(() => starterCategories = value),
            title: const Text('Categorias iniciais'),
            subtitle: const Text(
              'Mercado, saúde, transporte, casa, lazer e renda.',
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(error!, style: const TextStyle(color: ZimbaColors.destructive)),
        ],
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: saving ? null : saveSetup,
          icon: const Icon(Icons.check),
          label: const Text('Concluir configuração'),
        ),
        if (saving) ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
        ],
      ],
    );
  }
}
