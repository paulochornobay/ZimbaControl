import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'family_structure_page.dart' show SyncPanel;

/// Visual destinations for planned product journeys. They make scope visible
/// without simulating financial automation that the local domain cannot yet
/// execute safely.
class RulesPreviewPage extends StatelessWidget {
  const RulesPreviewPage({this.database, super.key});

  final AppDatabase? database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Regras'),
            Text(
              'Classificação explicável',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          ZimbaSection(
            title: 'Disponibilidade',
            child: _AvailabilityBanner(
              icon: Icons.auto_awesome_outlined,
              title: database == null
                  ? 'Regras indisponíveis neste preview'
                  : 'Regras locais e explicáveis',
              body: database == null
                  ? 'Abra Regras por Ajustes para gerenciar classificações persistentes neste aparelho.'
                  : 'Cada regra procura um texto na descrição, respeita prioridade e pode preencher categoria ou centro de custo.',
              tone: database == null ? ZimbaTone.warning : ZimbaTone.success,
            ),
          ),
          if (database != null) _RulesList(database: database!),
          ZimbaSection(
            title: 'Como funciona hoje',
            child: ZimbaRows(
              children: const [
                _AvailabilityRow(
                  icon: Icons.rate_review_outlined,
                  title: 'Revisão manual',
                  subtitle:
                      'Você confirma, edita ou ignora cada lançamento real.',
                  label: 'Disponível',
                  tone: ZimbaTone.success,
                ),
                _AvailabilityRow(
                  icon: Icons.tune_outlined,
                  title: 'Categorias e centros',
                  subtitle:
                      'A classificação é preservada nos cadastros locais.',
                  label: 'Disponível',
                  tone: ZimbaTone.success,
                ),
              ],
            ),
          ),
          ZimbaSection(
            title: 'Próximo marco',
            child: ZimbaRows(
              children: const [
                _AvailabilityRow(
                  icon: Icons.call_split_outlined,
                  title: 'Rateio de beneficiários',
                  subtitle: 'Divisão por valor ou percentual por pessoa.',
                ),
                _AvailabilityRow(
                  icon: Icons.lightbulb_outline,
                  title: 'Explicação e confiança',
                  subtitle: 'Cada sugestão poderá mostrar a regra responsável.',
                ),
                _AvailabilityRow(
                  icon: Icons.history_outlined,
                  title: 'Histórico de uso',
                  subtitle: 'Auditoria sem confirmar despesas silenciosamente.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RulesList extends StatefulWidget {
  const _RulesList({required this.database});

  final AppDatabase database;

  @override
  State<_RulesList> createState() => _RulesListState();
}

class _RulesListState extends State<_RulesList> {
  late Future<List<ClassificationRuleRow>> rulesFuture;

  @override
  void initState() {
    super.initState();
    rulesFuture = widget.database.listClassificationRules();
  }

  void refresh() {
    setState(() => rulesFuture = widget.database.listClassificationRules());
  }

  Future<void> openEditor([ClassificationRuleRow? rule]) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _RuleEditorPage(database: widget.database, rule: rule),
      ),
    );
    if (changed == true && mounted) {
      refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZimbaSection(
      title: 'Regras deste aparelho',
      action: TextButton.icon(
        onPressed: () => openEditor(),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Nova'),
      ),
      child: FutureBuilder<List<ClassificationRuleRow>>(
        future: rulesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ZimbaCard(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: LinearProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return ZimbaStateMessage(
              icon: Icons.error_outline,
              title: 'Não foi possível carregar regras',
              body: 'Tente atualizar esta tela.',
              action: OutlinedButton.icon(
                onPressed: refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar'),
              ),
            );
          }
          final rules = snapshot.data ?? const <ClassificationRuleRow>[];
          if (rules.isEmpty) {
            return ZimbaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nenhuma regra criada',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ex.: ao encontrar “mercado”, classificar como Alimentação.',
                    style: TextStyle(
                      fontSize: 12,
                      color: ZimbaColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => openEditor(),
                    icon: const Icon(Icons.add),
                    label: const Text('Criar primeira regra'),
                  ),
                ],
              ),
            );
          }
          return ZimbaRows(
            children: [
              for (final rule in rules)
                ListTile(
                  onTap: () => openEditor(rule),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 3,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: rule.active
                          ? ZimbaColors.accentSoft
                          : ZimbaColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.rule_outlined,
                      color: rule.active
                          ? ZimbaColors.accent
                          : ZimbaColors.secondaryText,
                    ),
                  ),
                  title: Text(
                    rule.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '“${rule.matchText}” · prioridade ${rule.priority} · ${rule.usageCount} uso(s)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: ZimbaBadge(
                    label: rule.active ? 'Ativa' : 'Pausada',
                    tone: rule.active ? ZimbaTone.success : ZimbaTone.neutral,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RuleEditorPage extends StatefulWidget {
  const _RuleEditorPage({required this.database, this.rule});

  final AppDatabase database;
  final ClassificationRuleRow? rule;

  @override
  State<_RuleEditorPage> createState() => _RuleEditorPageState();
}

class _RuleEditorPageState extends State<_RuleEditorPage> {
  final nameController = TextEditingController();
  final matchController = TextEditingController();
  final priorityController = TextEditingController();
  late Future<RegistrySnapshot> registryFuture;
  String? kind;
  String? categoryId;
  String? costCenterId;
  bool active = true;
  bool saving = false;
  String? error;

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    nameController.text = rule?.name ?? '';
    matchController.text = rule?.matchText ?? '';
    priorityController.text = (rule?.priority ?? 100).toString();
    kind = rule?.kind;
    categoryId = rule?.categoryId;
    costCenterId = rule?.costCenterId;
    active = rule?.active ?? true;
    registryFuture = widget.database.getRegistrySnapshot();
  }

  @override
  void dispose() {
    nameController.dispose();
    matchController.dispose();
    priorityController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.database.upsertClassificationRule(
        id: widget.rule?.id,
        name: nameController.text,
        matchText: matchController.text,
        kind: kind,
        categoryId: categoryId,
        costCenterId: costCenterId,
        priority: int.tryParse(priorityController.text) ?? 0,
        active: active,
      );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on ArgumentError catch (exception) {
      if (mounted) setState(() => error = exception.message.toString());
    } catch (_) {
      if (mounted) setState(() => error = 'Não foi possível salvar a regra.');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rule == null ? 'Nova regra' : 'Editar regra'),
        actions: [
          IconButton(
            tooltip: 'Salvar',
            onPressed: saving ? null : save,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: FutureBuilder<RegistrySnapshot>(
        future: registryFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final registry = snapshot.data!;
          final categories = registry.categories
              .where((category) => kind == null || category.kind == kind)
              .toList(growable: false);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            children: [
              ZimbaCard(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Nome da regra',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: matchController,
                      decoration: const InputDecoration(
                        labelText: 'Texto para encontrar',
                        helperText: 'Ex.: mercado, uber ou escola',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue: kind,
                      decoration: const InputDecoration(
                        labelText: 'Tipo (opcional)',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: null,
                          child: Text('Qualquer tipo'),
                        ),
                        DropdownMenuItem(
                          value: 'expense',
                          child: Text('Despesa'),
                        ),
                        DropdownMenuItem(
                          value: 'income',
                          child: Text('Receita'),
                        ),
                      ],
                      onChanged: (value) => setState(() {
                        kind = value;
                        if (categoryId != null &&
                            !categories.any((item) => item.id == categoryId)) {
                          categoryId = null;
                        }
                      }),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue: categoryId,
                      decoration: const InputDecoration(
                        labelText: 'Categoria (opcional)',
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Não alterar categoria'),
                        ),
                        for (final category in categories)
                          DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          ),
                      ],
                      onChanged: (value) => setState(() => categoryId = value),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue: costCenterId,
                      decoration: const InputDecoration(
                        labelText: 'Centro de custo (opcional)',
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Não alterar centro'),
                        ),
                        for (final center in registry.costCenters)
                          DropdownMenuItem(
                            value: center.id,
                            child: Text(center.name),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => costCenterId = value),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priorityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Prioridade',
                        helperText: 'O maior número é aplicado primeiro.',
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Regra ativa'),
                      value: active,
                      onChanged: (value) => setState(() => active = value),
                    ),
                  ],
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(
                  error!,
                  style: const TextStyle(color: ZimbaColors.destructive),
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: saving ? null : save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Salvar regra'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SyncPrivacyPreviewPage extends StatelessWidget {
  const SyncPrivacyPreviewPage({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return _SyncPrivacyContent(database: database);
  }
}

class _SyncPrivacyContent extends StatefulWidget {
  const _SyncPrivacyContent({required this.database});

  final AppDatabase database;

  @override
  State<_SyncPrivacyContent> createState() => _SyncPrivacyContentState();
}

class _SyncPrivacyContentState extends State<_SyncPrivacyContent> {
  static const syncEnabled = bool.fromEnvironment('SYNC_ENABLED');
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  late Future<List<SyncOutboxRow>> outboxFuture;

  bool get configured => syncEnabled && apiBaseUrl.isNotEmpty;

  @override
  void initState() {
    super.initState();
    outboxFuture = widget.database.listPendingSyncOutbox();
  }

  void refresh() {
    setState(() => outboxFuture = widget.database.listPendingSyncOutbox());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sync e privacidade'),
            Text(
              'Opcional e offline-first',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Atualizar estado local',
            onPressed: refresh,
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: FutureBuilder<List<SyncOutboxRow>>(
        future: outboxFuture,
        builder: (context, snapshot) => ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            ZimbaSection(
              title: 'Estado local',
              child: _AvailabilityBanner(
                icon: configured
                    ? Icons.cloud_sync_outlined
                    : Icons.phone_android_outlined,
                title: configured
                    ? 'Sync configurado neste ambiente'
                    : 'Uso local disponível',
                body: configured
                    ? '${snapshot.data?.length ?? 0} operação(ões) pendente(s) na fila local.'
                    : 'O banco do aparelho continua sendo a fonte de verdade, mesmo sem internet.',
                tone: configured ? ZimbaTone.accent : ZimbaTone.success,
              ),
            ),
            ZimbaSection(
              title: 'Fila e privacidade',
              child: ZimbaRows(
                children: [
                  _AvailabilityRow(
                    icon: Icons.outbox_outlined,
                    title: 'Fila local',
                    subtitle:
                        snapshot.connectionState == ConnectionState.waiting
                        ? 'Consultando operações locais.'
                        : '${snapshot.data?.length ?? 0} operação(ões) aguardando envio.',
                    label: snapshot.hasError ? 'Indisponível' : 'Local',
                    tone: snapshot.hasError
                        ? ZimbaTone.danger
                        : ZimbaTone.success,
                  ),
                  const _AvailabilityRow(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Dados financeiros',
                    subtitle:
                        'A base local continua disponível mesmo sem sync.',
                    label: 'Local',
                    tone: ZimbaTone.success,
                  ),
                  const _AvailabilityRow(
                    icon: Icons.notifications_paused_outlined,
                    title: 'Notificações brutas',
                    subtitle:
                        'A captura Android não entra no envio automaticamente.',
                    label: 'Protegido',
                    tone: ZimbaTone.success,
                  ),
                ],
              ),
            ),
            ZimbaSection(
              title: configured ? 'Ação disponível' : 'Disponibilidade',
              child: configured
                  ? ZimbaCard(child: SyncPanel(database: widget.database))
                  : const _AvailabilityBanner(
                      icon: Icons.cloud_off_outlined,
                      title: 'Sync não configurado',
                      body:
                          'Nenhuma informação será enviada. A ação de sync só aparece com SYNC_ENABLED e API_BASE_URL válidos.',
                      tone: ZimbaTone.neutral,
                    ),
            ),
            ZimbaSection(
              title: 'Próximo marco',
              child: const ZimbaRows(
                children: [
                  _AvailabilityRow(
                    icon: Icons.sync_outlined,
                    title: 'Aplicar dados remotos',
                    subtitle:
                        'Pull incremental para o banco local com deviceId.',
                  ),
                  _AvailabilityRow(
                    icon: Icons.warning_amber_outlined,
                    title: 'Conflitos financeiros',
                    subtitle:
                        'Casos concorrentes voltarão para a Caixa de Revisão.',
                  ),
                  _AvailabilityRow(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Payload de notificações',
                    subtitle: 'Dados brutos não serão enviados por padrão.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityBanner extends StatelessWidget {
  const _AvailabilityBanner({
    required this.icon,
    required this.title,
    required this.body,
    required this.tone,
  });

  final IconData icon;
  final String title;
  final String body;
  final ZimbaTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      ZimbaTone.success => (ZimbaColors.successSoft, ZimbaColors.success),
      ZimbaTone.warning => (ZimbaColors.warningSoft, ZimbaColors.warning),
      ZimbaTone.accent => (ZimbaColors.accentSoft, ZimbaColors.accent),
      ZimbaTone.danger => (
        ZimbaColors.destructiveSoft,
        ZimbaColors.destructive,
      ),
      _ => (ZimbaColors.surfaceMuted, ZimbaColors.secondaryText),
    };
    return ZimbaCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.$1,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: colors.$2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: ZimbaColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityRow extends StatelessWidget {
  const _AvailabilityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.label = 'Planejado',
    this.tone = ZimbaTone.warning,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String label;
  final ZimbaTone tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ZimbaColors.secondaryText),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ZimbaColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          ZimbaBadge(label: label, tone: tone),
        ],
      ),
    );
  }
}
