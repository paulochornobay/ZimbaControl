import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../data/local/app_database.dart';
import '../infrastructure/api_sync_client.dart';
import '../infrastructure/google_session_client.dart';
import '../infrastructure/notification_capture_service.dart';
import 'commitments_page.dart';
import 'dashboard_page.dart';
import 'duplicates_page.dart';
import 'registries_page.dart';

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
    setState(() {
      snapshotFuture = widget.database.getFamilyStructureSnapshot();
    });
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
                Text('Ajustes'),
                Text(
                  'Estrutura familiar',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          body: switch (snapshot.connectionState) {
            ConnectionState.waiting => const Center(
              child: CircularProgressIndicator(),
            ),
            _ when snapshot.hasError => const Center(
              child: Text('Nao foi possivel carregar a estrutura familiar.'),
            ),
            _ => FamilyStructureContent(
              database: widget.database,
              snapshot: snapshot.data!,
              onEnvironmentChanged: refresh,
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
    required this.onEnvironmentChanged,
    super.key,
  });

  final AppDatabase database;
  final FamilyStructureSnapshot snapshot;
  final VoidCallback onEnvironmentChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        _Section(
          title: 'Ambiente',
          children: [
            EnvironmentPanel(
              database: database,
              onChanged: onEnvironmentChanged,
            ),
          ],
        ),
        const SizedBox(height: 12),
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
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => RegistriesPage(database: database),
                ),
              ),
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
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => DuplicatesPage(database: database),
                    ),
                  ),
                  icon: const Icon(Icons.content_copy_outlined),
                  label: const Text('Duplicidades'),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CommitmentsPage(database: database),
                    ),
                  ),
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final person in snapshot.people)
                  Chip(
                    label: Text(person.displayName),
                    avatar: CircleAvatar(
                      child: Text(person.displayName.characters.first),
                    ),
                  ),
              ],
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
        _Section(
          title: 'Captura Android',
          children: [NotificationCapturePanel(database: database)],
        ),
        _Section(
          title: 'Sync opcional',
          children: [SyncPanel(database: database)],
        ),
        _Section(
          title: 'Backup e recuperacao',
          children: [BackupPanel(database: database)],
        ),
        _Section(
          title: 'Acesso futuro',
          children: [
            for (final user in snapshot.authUsers)
              _InfoRow(
                icon: Icons.verified_user_outlined,
                title: user.email,
                subtitle: '${user.provider} · allowlist local',
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar dados locais?'),
        content: const Text(
          'Isto remove lancamentos, cadastros, importacoes, backup em staging, preferencias e outbox local deste aparelho.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    setState(() {
      loading = true;
      message = null;
    });
    await widget.database.clearLocalData();
    if (!mounted) {
      return;
    }
    setState(() {
      loading = false;
      message = 'Ambiente local zerado.';
    });
    refresh();
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
                  onPressed: loading ? null : loadDemo,
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('Carregar demo'),
                ),
                OutlinedButton.icon(
                  onPressed: loading ? null : clearLocalData,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Apagar dados locais'),
                ),
              ],
            ),
          ],
        );
      },
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
    return _NotificationPanelState(
      status: status,
      sync: sync,
      rawEvents: rawEvents,
    );
  }

  void _refresh() {
    setState(() {
      stateFuture = _load();
    });
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
                  ? 'Os dados ficam locais. Autorize apenas apps confiaveis.'
                  : 'Captura real disponivel apenas no Android.',
            ),
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
                  label: const Text('Sincronizar'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Ultima sincronizacao: ${data.sync.recorded} eventos, '
              '${data.sync.drafts} rascunhos.',
              style: Theme.of(context).textTheme.bodySmall,
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
}

class _NotificationPanelState {
  const _NotificationPanelState({
    required this.status,
    required this.sync,
    required this.rawEvents,
  });

  final NotificationCaptureStatus status;
  final NotificationCaptureSyncResult sync;
  final List<RawNotificationEventRow> rawEvents;
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
            '${summary.conflicts} conflitos, ${summary.pulled} recebidos. '
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

  Future<void> _run(Future<String?> Function() action) async {
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
        message = result;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
        message = 'Nao foi possivel concluir a operacao de backup.';
      });
    }
  }

  Future<String?> _saveBackup() async {
    final backup = await widget.database.exportBackupFile();
    final path = await FilePicker.saveFile(
      dialogTitle: 'Salvar backup do ZimbaControl',
      fileName: backup.fileName,
      type: FileType.custom,
      allowedExtensions: const ['json'],
      bytes: Uint8List.fromList(backup.bytes),
    );
    if (path == null) {
      return 'Backup cancelado.';
    }
    return 'Backup salvo com ${backup.transactionCount} transacoes.';
  }

  Future<String?> _shareBackup() async {
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
    return 'Backup enviado para compartilhamento.';
  }

  Future<String?> _saveCsv() async {
    final bytes = await widget.database.exportTransactionsCsvBytes();
    final path = await FilePicker.saveFile(
      dialogTitle: 'Exportar movimentacoes CSV',
      fileName: 'zimbacontrol-movimentacoes.csv',
      type: FileType.custom,
      allowedExtensions: const ['csv'],
      bytes: Uint8List.fromList(bytes),
    );
    if (path == null) {
      return 'Exportacao CSV cancelada.';
    }
    return 'CSV exportado para consulta externa.';
  }

  Future<String?> _restoreBackup() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    final file = result?.files.single;
    final bytes = file?.bytes;
    if (file == null || bytes == null) {
      return 'Restauracao cancelada.';
    }

    final validation = await widget.database.validateBackupBytes(bytes);
    if (!validation.valid || !mounted) {
      return validation.message;
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
      return 'Restauracao cancelada.';
    }

    final restored = await widget.database.restoreBackupBytes(bytes);
    return 'Backup restaurado com ${restored.transactionCount} transacoes.';
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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
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
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.09),
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
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
