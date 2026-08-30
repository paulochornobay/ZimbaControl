import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    if (!configuring) return _welcome(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: _setupForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _welcome(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _OnboardingHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                children: [
                  const Text(
                    'Organize as finanças da família\nsem depender da internet',
                    style: TextStyle(
                      fontSize: 23,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Uma configuração curta agora deixa o app pronto para o dia a dia.',
                    style: TextStyle(
                      color: ZimbaColors.secondaryText,
                      fontSize: 16,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _OnboardingFeatureCard(),
                  const SizedBox(height: 12),
                  const _LocalDataNotice(),
                  const SizedBox(height: 12),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Icon(
                          LucideIcons.shieldCheck,
                          color: ZimbaColors.success,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Protótipo visual com dados fictícios: nenhuma conta real é conectada.',
                          style: TextStyle(
                            color: ZimbaColors.secondaryText,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error!,
                      style: const TextStyle(color: ZimbaColors.destructive),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              decoration: const BoxDecoration(
                color: ZimbaColors.surface,
                border: Border(top: BorderSide(color: ZimbaColors.border)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton(
                    onPressed: saving
                        ? null
                        : () => setState(() => configuring = true),
                    child: const Text('Começar configuração'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: saving ? null : loadDemo,
                    icon: const Icon(LucideIcons.flaskConical, size: 18),
                    label: const Text('Explorar demonstração'),
                  ),
                  if (saving) ...[
                    const SizedBox(height: 8),
                    const LinearProgressIndicator(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ZimbaColors.border)),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 70,
            child: Row(
              children: [
                SizedBox(width: 16),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    LucideIcons.arrowLeft,
                    color: ZimbaColors.accent,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuração inicial',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 19,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Etapa 1 de 8',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ZimbaColors.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    LucideIcons.x,
                    color: ZimbaColors.secondaryText,
                    size: 20,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.fromLTRB(16, 10, 0, 12),
              decoration: BoxDecoration(
                color: ZimbaColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingFeatureCard extends StatelessWidget {
  const _OnboardingFeatureCard();

  static const rows = [
    (
      LucideIcons.check,
      'Revisar antes de consolidar',
      'Cada lançamento passa por você antes de virar histórico.',
    ),
    (
      LucideIcons.fileSpreadsheet,
      'Importar OFX e CSV',
      'Traga extratos e faturas dos seus arquivos, no seu tempo.',
    ),
    (
      LucideIcons.creditCard,
      'Contas, cartões e faturas',
      'Saiba em qual fatura a compra entrou e quando ela vence.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ZimbaColors.surface,
        border: Border.all(color: ZimbaColors.border),
        borderRadius: BorderRadius.circular(ZimbaRadii.lg),
        boxShadow: ZimbaShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++) ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: ZimbaColors.accentSoft,
                      borderRadius: BorderRadius.circular(ZimbaRadii.lg),
                    ),
                    child: Icon(rows[index].$1, color: ZimbaColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rows[index].$2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rows[index].$3,
                          style: const TextStyle(
                            color: ZimbaColors.secondaryText,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (index < rows.length - 1)
              const Divider(height: 1, color: ZimbaColors.border),
          ],
        ],
      ),
    );
  }
}

class _LocalDataNotice extends StatelessWidget {
  const _LocalDataNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ZimbaColors.successSoft,
        borderRadius: BorderRadius.circular(ZimbaRadii.lg),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seus dados ficam neste aparelho',
            style: TextStyle(
              color: ZimbaColors.success,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Por padrão nada é enviado para a internet. Você decide se e quando fazer backup.',
            style: TextStyle(fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }
}
