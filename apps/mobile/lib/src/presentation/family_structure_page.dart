import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../application/app_reset_coordinator.dart';
import '../data/local/app_database.dart';
import '../infrastructure/api_sync_client.dart';
import '../infrastructure/google_session_client.dart';
import '../infrastructure/notification_capture_service.dart';
import 'commitments_page.dart';
import 'dashboard_page.dart';
import 'duplicates_page.dart';
import 'registries_page.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

class FamilyStructurePage extends StatefulWidget {
  const FamilyStructurePage({required this.database, super.key});

  final AppDatabase database;

  @override
  State<FamilyStructurePage> createState() => _FamilyStructurePageState();
}

class _FamilyStructurePageState extends State<FamilyStructurePage> {
  late Future<FamilyStructureSnapshot> snapshotFuture;

  @override
  void initState() {
    super.initState();
    snapshotFuture = widget.database.getFamilyStructureSnapshot();
  }

  void refresh() {
    setState(
      () => snapshotFuture = widget.database.getFamilyStructureSnapshot(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FamilyStructureSnapshot>(
      future: snapshotFuture,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Família'),
                Text(
                  'Pessoas, contas e compromissos',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Atualizar',
                onPressed: refresh,
                icon: const Icon(Icons.refresh_outlined),
              ),
            ],
          ),
          body: switch (snapshot.connectionState) {
            ConnectionState.waiting => const Center(
              child: CircularProgressIndicator(),
            ),
            _ when snapshot.hasError => ZimbaStateMessage(
              icon: Icons.error_outline,
              title: 'Não foi possível carregar a família',
              body: 'Tente atualizar. Nenhum cadastro foi alterado.',
              action: OutlinedButton.icon(
                onPressed: refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar'),
              ),
            ),
            _ => FamilyStructureContent(
              database: widget.database,
              snapshot: snapshot.data!,
              onChanged: refresh,
            ),
          },
        );
      },
    );
  }
}

class FamilyStructureContent extends StatelessWidget {
  const FamilyStructureContent({
    required this.database,
    required this.snapshot,
    required this.onChanged,
    super.key,
  });

  final AppDatabase database;
  final FamilyStructureSnapshot snapshot;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        _FamilyOverview(snapshot: snapshot),
        const SizedBox(height: 14),
        _Section(
          title: 'Cadastros',
          children: [
            _InfoRow(
              icon: Icons.tune_outlined,
              title: 'Contas, cartoes e categorias',
              subtitle:
                  'Cadastre instrumentos, categorias e centros usados nas movimentacoes.',
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => Navigator.of(context)
                  .push(
                    MaterialPageRoute<void>(
                      builder: (_) => RegistriesPage(database: database),
                    ),
                  )
                  .then((_) => onChanged()),
              icon: const Icon(Icons.edit_note_outlined),
              label: const Text('Abrir cadastros'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _Section(
          title: 'Fluxos financeiros',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context)
                      .push(
                        MaterialPageRoute<void>(
                          builder: (_) => DuplicatesPage(database: database),
                        ),
                      )
                      .then((_) => onChanged()),
                  icon: const Icon(Icons.content_copy_outlined),
                  label: const Text('Duplicidades'),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context)
                      .push(
                        MaterialPageRoute<void>(
                          builder: (_) => CommitmentsPage(database: database),
                        ),
                      )
                      .then((_) => onChanged()),
                  icon: const Icon(Icons.event_repeat_outlined),
                  label: const Text('Compromissos'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        _Section(
          title: 'Pessoas',
          children: [
            for (final person in snapshot.people)
              _InfoRow(
                icon: person.kind == 'child'
                    ? Icons.child_care_outlined
                    : Icons.person_outline,
                title: person.displayName,
                subtitle: person.kind == 'child' ? 'Dependente' : 'Adulto',
              ),
          ],
        ),
        _Section(
          title: 'Contas',
          children: [
            for (final item in snapshot.accounts)
              _InfoRow(
                icon: Icons.account_balance_wallet_outlined,
                title: item.account.name,
                subtitle: '${item.account.provider} · ${item.ownerLabel}',
              ),
          ],
        ),
        _Section(
          title: 'Cartoes',
          children: [
            for (final item in snapshot.creditCards)
              _InfoRow(
                icon: Icons.credit_card_outlined,
                title: item.creditCard.name,
                subtitle:
                    '${item.creditCard.brand ?? 'Cartao'} · ${item.ownerLabel}',
              ),
          ],
        ),
        _Section(
          title: 'Recorrencias',
          children: [
            for (final schedule in snapshot.recurringSchedules)
              _InfoRow(
                icon: _scheduleIcon(schedule.kind),
                title: schedule.label,
                subtitle:
                    '${_kindLabel(schedule.kind)} · dia ${schedule.dayOfMonth} · ${formatBrl(schedule.amountCents)}',
              ),
          ],
        ),
        _Section(
          title: 'Compromissos',
          children: [
            for (final plan in snapshot.installmentPlans)
              _InfoRow(
                icon: Icons.directions_car_outlined,
                title: plan.label,
                subtitle:
                    '${plan.currentInstallment}/${plan.totalInstallments} · ${formatBrl(plan.installmentAmountCents)}',
              ),
          ],
        ),
      ],
    );
  }

  IconData _scheduleIcon(String kind) {
    return switch (kind) {
      'income' => Icons.trending_up,
      'transfer' => Icons.compare_arrows_outlined,
      _ => Icons.event_repeat_outlined,
    };
  }

  String _kindLabel(String kind) {
    return switch (kind) {
      'income' => 'Receita',
      'transfer' => 'Transferencia interna',
      _ => 'Despesa',
    };
  }
}

class _FamilyOverview extends StatelessWidget {
  const _FamilyOverview({required this.snapshot});

  final FamilyStructureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: ZimbaColors.accentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.groups_2_outlined,
              color: ZimbaColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estrutura da família',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 3),
                Text(
                  '${snapshot.people.length} pessoa(s), ${snapshot.accounts.length} conta(s) e ${snapshot.creditCards.length} cartão(ões).',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

class DataEnvironmentPage extends StatelessWidget {
  const DataEnvironmentPage({
    required this.database,
    required this.onChanged,
    super.key,
  });

  final AppDatabase database;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados locais')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Section(
            title: 'Ambiente',
            children: [
              EnvironmentPanel(
                database: database,
                onChanged: () {
                  Navigator.of(context).pop();
                  onChanged();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ZimbaSectionTitle('Área de perigo'),
          ZimbaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: ZimbaColors.destructive,
                  size: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  'Começar do zero',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Faça um backup antes se quiser recuperar os lançamentos e cadastros depois.',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BackupSettingsPage(database: database),
                      ),
                    ),
                    icon: const Icon(Icons.archive_outlined),
                    label: const Text('Fazer backup antes'),
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

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captura Android')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Section(
            title: 'Notificações financeiras',
            children: [NotificationCapturePanel(database: database)],
          ),
        ],
      ),
    );
  }
}

class BackupSettingsPage extends StatelessWidget {
  const BackupSettingsPage({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup e recuperação')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Section(
            title: 'Arquivo local',
            children: [BackupPanel(database: database)],
          ),
        ],
      ),
    );
  }
}

class EnvironmentPanel extends StatefulWidget {
  const EnvironmentPanel({
    required this.database,
    required this.onChanged,
    super.key,
  });

  final AppDatabase database;
  final VoidCallback onChanged;

  @override
  State<EnvironmentPanel> createState() => _EnvironmentPanelState();
}

class _EnvironmentPanelState extends State<EnvironmentPanel> {
  late Future<LocalDataStatus> statusFuture;
  bool loading = false;
  String? message;

  @override
  void initState() {
    super.initState();
    statusFuture = widget.database.getLocalDataStatus();
  }

  void refresh() {
    setState(() {
      statusFuture = widget.database.getLocalDataStatus();
    });
    widget.onChanged();
  }

  Future<void> loadDemo() async {
    setState(() {
      loading = true;
      message = null;
    });
    await widget.database.loadDemoData();
    if (!mounted) {
      return;
    }
    setState(() {
      loading = false;
      message = 'Dados demo carregados.';
    });
    refresh();
  }

  Future<void> clearLocalData() async {
    final status = await statusFuture;
    if (!mounted) return;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ResetConfirmationSheet(status: status),
    );
    if (confirmed != true) {
      return;
    }
    setState(() {
      loading = true;
      message = null;
    });
    try {
      await AppResetCoordinator(database: widget.database).resetEverything();
      if (!mounted) return;
      setState(() {
        loading = false;
        message = 'Aplicativo zerado com segurança.';
      });
      refresh();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        loading = false;
        message =
            'Não foi possível zerar tudo. Seus dados financeiros foram preservados.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalDataStatus>(
      future: statusFuture,
      builder: (context, snapshot) {
        final status = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(
              icon: status?.isEmpty == true
                  ? Icons.radio_button_unchecked
                  : Icons.storage_outlined,
              title: status?.isEmpty == true
                  ? 'Banco local zerado'
                  : 'Banco local com dados',
              subtitle: status == null
                  ? 'Carregando status local.'
                  : '${status.transactions} lancamentos · ${status.accounts} contas · ${status.categories} categorias',
            ),
            if (loading) const LinearProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message!, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: loading || status?.isEmpty != true
                      ? null
                      : loadDemo,
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('Carregar demo'),
                ),
                OutlinedButton.icon(
                  onPressed: loading ? null : clearLocalData,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ZimbaColors.destructive,
                  ),
                  icon: const Icon(Icons.delete_forever_outlined),
                  label: const Text('Zerar aplicativo'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ResetConfirmationSheet extends StatefulWidget {
  const _ResetConfirmationSheet({required this.status});

  final LocalDataStatus status;

  @override
  State<_ResetConfirmationSheet> createState() =>
      _ResetConfirmationSheetState();
}

class _ResetConfirmationSheetState extends State<_ResetConfirmationSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = controller.text.trim().toUpperCase() == 'ZERAR';
    final status = widget.status;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          18,
          20,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        decoration: const BoxDecoration(
          color: ZimbaColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Zerar aplicativo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Fechar',
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Text(
                'Esta ação remove dados financeiros, importações, regras, sync, fila de notificações e sessão deste aparelho.',
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ZimbaColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${status.transactions} lançamentos · ${status.accounts + status.creditCards} instrumentos\n'
                  '${status.categories + status.costCenters} classificações · ${status.importBatches} importações\n'
                  '${status.classificationRules} regras · ${status.syncRecords} registros de sync',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'As permissões concedidas pelo Android, como acesso às notificações, permanecem ativas.',
                style: TextStyle(color: ZimbaColors.secondaryText),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Digite ZERAR para confirmar',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: enabled
                      ? () => Navigator.of(context).pop(true)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: ZimbaColors.destructive,
                  ),
                  icon: const Icon(Icons.delete_forever_outlined),
                  label: const Text('Apagar tudo e voltar ao início'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCapturePanel extends StatefulWidget {
  const NotificationCapturePanel({required this.database, super.key});

  final AppDatabase database;

  @override
  State<NotificationCapturePanel> createState() =>
      _NotificationCapturePanelState();
}

class _NotificationCapturePanelState extends State<NotificationCapturePanel> {
  static const service = NotificationCaptureService();
  late Future<_NotificationPanelState> stateFuture;

  @override
  void initState() {
    super.initState();
    stateFuture = _load();
  }

  Future<_NotificationPanelState> _load() async {
    final status = await service.loadStatus();
    final sync = await widget.database.syncNotificationCaptureEvents(service);
    final rawEvents = await widget.database.listRawNotificationEvents(limit: 3);
    final diagnostics = await widget.database
        .getNotificationCaptureDiagnostics();
    return _NotificationPanelState(
      status: status,
      sync: sync,
      rawEvents: rawEvents,
      diagnostics: diagnostics,
    );
  }

  void _refresh() {
    setState(() {
      stateFuture = _load();
    });
  }

  Future<void> _pruneDeliveredEvents(int retentionDays) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Expurgar eventos entregues?'),
        content: Text(
          'Somente notificacoes ja entregues ao banco local ha mais de '
          '$retentionDays dias serao removidas. Eventos pendentes nao serao apagados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Expurgar'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await widget.database.setNotificationCaptureRetentionDays(retentionDays);
    final removed = await service.pruneRawEvents(olderThanDays: retentionDays);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$removed eventos entregues foram expurgados.')),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_NotificationPanelState>(
      future: stateFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: LinearProgressIndicator(),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _InfoRow(
            icon: Icons.notifications_off_outlined,
            title: 'Status indisponivel',
            subtitle: 'Nao foi possivel ler a captura Android.',
          );
        }

        final data = snapshot.data!;
        final status = data.status;
        final diagnostics = data.diagnostics;
        final allowedApps = status.allowedPackages.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(
              icon: status.permissionGranted
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_none_outlined,
              title: status.permissionGranted
                  ? 'Permissao concedida'
                  : 'Permissao ausente',
              subtitle: status.available
                  ? allowedApps == 0
                        ? 'Nenhum app permitido. Ative Nubank ou Mercado Pago abaixo.'
                        : '$allowedApps app(s) permitido(s). Os dados ficam locais.'
                  : 'Captura real disponivel apenas no Android.',
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: status.queue.pending > 0
                  ? Icons.pending_actions_outlined
                  : Icons.cloud_done_outlined,
              title: '${status.queue.pending} aguardando entrega Android',
              subtitle:
                  '${status.queue.delivered} entregues ao banco local · '
                  'ultima drenagem ${_notificationDate(diagnostics.lastDrain)}',
            ),
            const SizedBox(height: 8),
            Text(
              'No banco local: ${diagnostics.count('draft_created')} em revisao · '
              '${diagnostics.count('merged')} conciliadas · '
              '${diagnostics.count('duplicate')} duplicadas · '
              '${diagnostics.count('ignored_no_amount')} sem valor.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if ((data.sync.bridgeError ?? diagnostics.lastError ?? '')
                .isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                data.sync.bridgeError ?? diagnostics.lastError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 8),
            for (final app in _KnownNotificationApp.values)
              SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(app.label),
                subtitle: Text(app.packageName),
                value: status.allowedPackages.contains(app.packageName),
                onChanged: !status.available
                    ? null
                    : (enabled) async {
                        final packages = status.allowedPackages.toSet();
                        if (enabled) {
                          packages.add(app.packageName);
                        } else {
                          packages.remove(app.packageName);
                        }
                        await service.setAllowedPackages(packages.toList());
                        _refresh();
                      },
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: status.available
                      ? () => service.openNotificationSettings()
                      : null,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Abrir permissao'),
                ),
                OutlinedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.sync),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Ultima tentativa: ${data.sync.fetched} recebidos, '
              '${data.sync.recorded} novos no banco e ${data.sync.drafts} rascunhos.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: diagnostics.retentionDays,
              decoration: const InputDecoration(
                labelText: 'Reter eventos brutos entregues por',
              ),
              items: const [
                DropdownMenuItem(value: 7, child: Text('7 dias')),
                DropdownMenuItem(value: 30, child: Text('30 dias')),
                DropdownMenuItem(value: 90, child: Text('90 dias')),
              ],
              onChanged: status.available
                  ? (days) async {
                      if (days == null) {
                        return;
                      }
                      await widget.database.setNotificationCaptureRetentionDays(
                        days,
                      );
                      _refresh();
                    }
                  : null,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: status.available
                  ? () => _pruneDeliveredEvents(diagnostics.retentionDays)
                  : null,
              icon: const Icon(Icons.delete_sweep_outlined),
              label: const Text('Expurgar eventos entregues'),
            ),
            const SizedBox(height: 8),
            if (data.rawEvents.isEmpty)
              Text(
                'Nenhuma notificacao financeira capturada ainda.',
                style: Theme.of(context).textTheme.bodySmall,
              )
            else
              for (final event in data.rawEvents)
                _InfoRow(
                  icon: Icons.history,
                  title: event.title ?? event.appLabel ?? event.packageName,
                  subtitle: '${event.status} · ${event.bodyText ?? ''}',
                ),
          ],
        );
      },
    );
  }

  String _notificationDate(DateTime? value) {
    if (value == null) {
      return 'ainda nao realizada';
    }
    final local = value.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

class _NotificationPanelState {
  const _NotificationPanelState({
    required this.status,
    required this.sync,
    required this.rawEvents,
    required this.diagnostics,
  });

  final NotificationCaptureStatus status;
  final NotificationCaptureSyncResult sync;
  final List<RawNotificationEventRow> rawEvents;
  final NotificationCaptureDiagnostics diagnostics;
}

enum _KnownNotificationApp {
  nubank('Nubank', 'com.nu.production'),
  mercadoPago('Mercado Pago', 'com.mercadopago.wallet');

  const _KnownNotificationApp(this.label, this.packageName);

  final String label;
  final String packageName;
}

class SyncPanel extends StatefulWidget {
  const SyncPanel({required this.database, super.key});

  final AppDatabase database;

  @override
  State<SyncPanel> createState() => _SyncPanelState();
}

class _SyncPanelState extends State<SyncPanel> {
  static const syncEnabled = bool.fromEnvironment('SYNC_ENABLED');
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );
  var loading = false;
  String? sessionToken;
  String? sessionEmail;
  String? message;

  bool get configured => syncEnabled && apiBaseUrl.isNotEmpty;

  bool get googleConfigured => googleWebClientId.isNotEmpty;

  GoogleSessionClient get sessionClient => GoogleSessionClient(
    apiBaseUrl: apiBaseUrl,
    googleWebClientId: googleWebClientId,
  );

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    if (!configured || !googleConfigured) {
      return;
    }
    final token = await sessionClient.readSessionToken();
    final email = await sessionClient.readSessionEmail();
    if (!mounted) {
      return;
    }
    setState(() {
      sessionToken = token;
      sessionEmail = email;
    });
  }

  Future<void> _connectGoogle() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final session = await sessionClient.signIn();
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
        sessionToken = session.token;
        sessionEmail = session.email;
        message = 'Conta conectada: ${session.email}.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
        message = 'Nao foi possivel conectar com Google.';
      });
    }
  }

  Future<void> _disconnectGoogle() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      await sessionClient.signOut();
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
        sessionToken = null;
        sessionEmail = null;
        message = 'Conta desconectada.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
        message = 'Nao foi possivel desconectar agora.';
      });
    }
  }

  Future<void> _syncNow() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final summary = await widget.database.runSyncOnce(
        HttpSyncApiClient(baseUrl: apiBaseUrl, sessionToken: sessionToken),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
        message =
            '${summary.pushed} enviados, ${summary.duplicates} duplicados, '
            '${summary.conflicts + summary.remoteConflicts} conflitos, '
            '${summary.applied}/${summary.pulled} recebidos aplicados. '
            'Seq ${summary.latestSeq}.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
        message = 'Nao foi possivel sincronizar agora.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          icon: configured
              ? Icons.cloud_sync_outlined
              : Icons.cloud_off_outlined,
          title: configured ? 'Sync local habilitado' : 'Sync desligado',
          subtitle: configured
              ? apiBaseUrl
              : 'Use --dart-define=SYNC_ENABLED=true e API_BASE_URL.',
        ),
        if (configured && googleConfigured) ...[
          const SizedBox(height: 8),
          _InfoRow(
            icon: sessionEmail == null
                ? Icons.account_circle_outlined
                : Icons.verified_user_outlined,
            title: sessionEmail == null
                ? 'Google nao conectado'
                : 'Google conectado',
            subtitle:
                sessionEmail ?? 'Use o email liberado na allowlist da API.',
          ),
        ],
        const SizedBox(height: 8),
        if (loading) const LinearProgressIndicator(),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(message!, style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: configured && !loading ? _syncNow : null,
          icon: const Icon(Icons.sync),
          label: const Text('Sincronizar agora'),
        ),
        if (configured && googleConfigured) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: loading
                ? null
                : sessionToken == null
                ? _connectGoogle
                : _disconnectGoogle,
            icon: Icon(sessionToken == null ? Icons.login : Icons.logout),
            label: Text(
              sessionToken == null ? 'Conectar Google' : 'Sair do Google',
            ),
          ),
        ],
      ],
    );
  }
}

class BackupPanel extends StatefulWidget {
  const BackupPanel({required this.database, super.key});

  final AppDatabase database;

  @override
  State<BackupPanel> createState() => _BackupPanelState();
}

class _BackupPanelState extends State<BackupPanel> {
  var loading = false;
  String? message;
  ZimbaTone messageTone = ZimbaTone.neutral;

  Future<void> _run(Future<_BackupActionResult> Function() action) async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final result = await action();
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
        message = result.message;
        messageTone = result.tone;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
        message = 'Nao foi possivel concluir a operacao de backup.';
        messageTone = ZimbaTone.danger;
      });
    }
  }

  Future<_BackupActionResult> _saveBackup() async {
    final backup = await widget.database.exportBackupFile();
    final path = await FilePicker.saveFile(
      dialogTitle: 'Salvar backup do ZimbaControl',
      fileName: backup.fileName,
      type: FileType.custom,
      allowedExtensions: const ['json'],
      bytes: Uint8List.fromList(backup.bytes),
    );
    if (path == null) {
      return const _BackupActionResult('Backup cancelado.', ZimbaTone.neutral);
    }
    return _BackupActionResult(
      'Backup salvo com ${backup.transactionCount} transacoes.',
      ZimbaTone.success,
    );
  }

  Future<_BackupActionResult> _shareBackup() async {
    final backup = await widget.database.exportBackupFile();
    await SharePlus.instance.share(
      ShareParams(
        subject: 'Backup ZimbaControl',
        text: 'Backup local do ZimbaControl.',
        files: [
          XFile.fromData(
            Uint8List.fromList(backup.bytes),
            name: backup.fileName,
            mimeType: 'application/json',
          ),
        ],
      ),
    );
    return const _BackupActionResult(
      'Backup enviado para compartilhamento.',
      ZimbaTone.success,
    );
  }

  Future<_BackupActionResult> _saveCsv() async {
    final bytes = await widget.database.exportTransactionsCsvBytes();
    final path = await FilePicker.saveFile(
      dialogTitle: 'Exportar movimentacoes CSV',
      fileName: 'zimbacontrol-movimentacoes.csv',
      type: FileType.custom,
      allowedExtensions: const ['csv'],
      bytes: Uint8List.fromList(bytes),
    );
    if (path == null) {
      return const _BackupActionResult(
        'Exportacao CSV cancelada.',
        ZimbaTone.neutral,
      );
    }
    return const _BackupActionResult(
      'CSV exportado para consulta externa.',
      ZimbaTone.success,
    );
  }

  Future<_BackupActionResult> _restoreBackup() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    final file = result?.files.single;
    final bytes = file?.bytes;
    if (file == null || bytes == null) {
      return const _BackupActionResult(
        'Restauracao cancelada.',
        ZimbaTone.neutral,
      );
    }

    final validation = await widget.database.validateBackupBytes(bytes);
    if (!validation.valid || !mounted) {
      return _BackupActionResult(validation.message, ZimbaTone.danger);
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar backup?'),
        content: Text(
          'Arquivo valido com ${validation.transactionCount} transacoes e '
          '${validation.totalRows} registros. A restauracao substitui os dados locais atuais.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return const _BackupActionResult(
        'Restauracao cancelada.',
        ZimbaTone.neutral,
      );
    }

    final restored = await widget.database.restoreBackupBytes(bytes);
    return _BackupActionResult(
      'Backup restaurado com ${restored.transactionCount} transacoes.',
      ZimbaTone.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _InfoRow(
          icon: Icons.security_outlined,
          title: 'Backup local versionado',
          subtitle: 'Sem MongoDB. Guarde o arquivo em local confiavel.',
        ),
        const SizedBox(height: 8),
        ZimbaCard(
          color: ZimbaColors.warningSoft,
          borderColor: ZimbaColors.warningSoft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_outlined,
                color: ZimbaColors.warning,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Restaurar substitui todos os dados deste aparelho somente após a confirmação do arquivo válido.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ZimbaColors.foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (loading) const LinearProgressIndicator(),
        if (message != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              ZimbaBadge(
                label: switch (messageTone) {
                  ZimbaTone.success => 'Concluído',
                  ZimbaTone.danger => 'Falha',
                  _ => 'Sem alteração',
                },
                tone: messageTone,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: loading ? null : () => _run(_saveBackup),
              icon: const Icon(Icons.download_outlined),
              label: const Text('Salvar backup'),
            ),
            OutlinedButton.icon(
              onPressed: loading ? null : () => _run(_shareBackup),
              icon: const Icon(Icons.ios_share_outlined),
              label: const Text('Compartilhar'),
            ),
            OutlinedButton.icon(
              onPressed: loading ? null : () => _run(_saveCsv),
              icon: const Icon(Icons.table_view_outlined),
              label: const Text('CSV'),
            ),
            OutlinedButton.icon(
              onPressed: loading ? null : () => _run(_restoreBackup),
              icon: const Icon(Icons.restore_outlined),
              label: const Text('Restaurar'),
            ),
          ],
        ),
      ],
    );
  }
}

class _BackupActionResult {
  const _BackupActionResult(this.message, this.tone);

  final String message;
  final ZimbaTone tone;
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: ZimbaColors.secondaryText,
              letterSpacing: .7,
            ),
          ),
          const SizedBox(height: 10),
          if (children.isEmpty)
            Text(
              'Nada cadastrado.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: ZimbaColors.accentSoft,
            foregroundColor: ZimbaColors.accent,
            child: Icon(icon, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
