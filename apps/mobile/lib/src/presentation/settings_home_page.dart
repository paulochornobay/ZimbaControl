import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../infrastructure/notification_capture_service.dart';
import 'commitments_page.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'duplicates_page.dart';
import 'family_structure_page.dart';
import 'feature_availability_page.dart';
import 'import_page.dart';
import 'invoices_page.dart';
import 'registries_page.dart';

class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({
    required this.database,
    required this.onEnvironmentChanged,
    super.key,
  });

  final AppDatabase database;
  final VoidCallback onEnvironmentChanged;

  @override
  State<SettingsHomePage> createState() => _SettingsHomePageState();
}

class _SettingsHomePageState extends State<SettingsHomePage> {
  static const notificationService = NotificationCaptureService();
  late Future<_SettingsHubState> stateFuture;

  @override
  void initState() {
    super.initState();
    stateFuture = _load();
  }

  Future<_SettingsHubState> _load() async {
    final results = await Future.wait<Object>([
      notificationService.loadStatus(),
      widget.database.getLocalDataStatus(),
      widget.database.listPendingSyncOutbox(),
      widget.database.getNotificationCaptureDiagnostics(),
    ]);
    return _SettingsHubState(
      notification: results[0] as NotificationCaptureStatus,
      localData: results[1] as LocalDataStatus,
      pendingSync: results[2] as List<SyncOutboxRow>,
      notificationDiagnostics: results[3] as NotificationCaptureDiagnostics,
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => page)).then((_) {
      if (mounted) {
        setState(() => stateFuture = _load());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_SettingsHubState>(
      future: stateFuture,
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          title: const Text('Ajustes'),
          actions: [
            IconButton(
              tooltip: 'Atualizar estados locais',
              onPressed: () => setState(() => stateFuture = _load()),
              icon: const Icon(Icons.refresh_outlined),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            if (snapshot.hasError) ...[
              const ZimbaFeedbackBanner(
                icon: Icons.error_outline,
                title: 'Alguns estados locais não puderam ser lidos',
                body:
                    'As jornadas continuam disponíveis; atualize para tentar novamente.',
                tone: ZimbaTone.warning,
              ),
              const SizedBox(height: 14),
            ],
            _SettingsOverview(
              localData: snapshot.data?.localData,
              loading: snapshot.connectionState == ConnectionState.waiting,
            ),
            const SizedBox(height: 14),
            const ZimbaSectionTitle('Captura de notificação'),
            ZimbaCard(
              padding: EdgeInsets.zero,
              child: InkWell(
                borderRadius: BorderRadius.circular(ZimbaLayout.cardRadius),
                onTap: () => _open(
                  context,
                  NotificationSettingsPage(database: widget.database),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _SettingsFeature(
                    icon: Icons.notifications_none_outlined,
                    title: 'Captura Android',
                    subtitle: _notificationSubtitle(
                      snapshot.data?.notification,
                    ),
                    status: _notificationStatus(snapshot.data?.notification),
                    tone: _notificationTone(snapshot.data?.notification),
                    accent: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const ZimbaSectionTitle('Dados'),
            ZimbaRows(
              children: [
                _SettingsRow(
                  icon: Icons.file_upload_outlined,
                  title: 'Importar CSV/OFX',
                  subtitle: 'Nubank, Mercado Pago e CSV genérico',
                  onTap: () =>
                      _open(context, ImportPage(database: widget.database)),
                ),
                _SettingsRow(
                  icon: Icons.content_copy_outlined,
                  title: 'Resolver duplicidades',
                  subtitle: 'Compare e mescle fontes',
                  onTap: () =>
                      _open(context, DuplicatesPage(database: widget.database)),
                ),
                _SettingsRow(
                  icon: Icons.auto_awesome_outlined,
                  title: 'Regras',
                  subtitle: 'Estado da classificação e próximos recursos',
                  onTap: () => _open(
                    context,
                    RulesPreviewPage(database: widget.database),
                  ),
                ),
                _SettingsRow(
                  icon: Icons.people_alt_outlined,
                  title: 'Estrutura familiar',
                  subtitle: 'Pessoas, contas e responsáveis',
                  onTap: () => _open(
                    context,
                    FamilyStructurePage(database: widget.database),
                  ),
                ),
                _SettingsRow(
                  icon: Icons.tune_outlined,
                  title: 'Cadastros',
                  subtitle: 'Contas, cartões, categorias e centros',
                  onTap: () =>
                      _open(context, RegistriesPage(database: widget.database)),
                ),
                _SettingsRow(
                  icon: Icons.receipt_long_outlined,
                  title: 'Faturas de cartões',
                  subtitle: 'Ciclos, compras, estornos e pagamentos',
                  onTap: () =>
                      _open(context, InvoicesPage(database: widget.database)),
                ),
                _SettingsRow(
                  icon: Icons.event_repeat_outlined,
                  title: 'Compromissos',
                  subtitle: 'Recorrências e parcelamentos',
                  onTap: () => _open(
                    context,
                    CommitmentsPage(database: widget.database),
                  ),
                ),
                _SettingsRow(
                  icon: Icons.archive_outlined,
                  title: 'Backup e recuperação',
                  subtitle: _backupSubtitle(snapshot.data?.localData),
                  status: _backupStatus(snapshot.data?.localData),
                  tone: _backupTone(snapshot.data?.localData),
                  onTap: () => _open(
                    context,
                    BackupSettingsPage(database: widget.database),
                  ),
                ),
                _SettingsRow(
                  icon: Icons.sync_outlined,
                  title: 'Sync e privacidade',
                  subtitle: _syncSubtitle(snapshot.data?.pendingSync),
                  status: _syncStatus(snapshot.data?.pendingSync),
                  tone: _syncTone(snapshot.data?.pendingSync),
                  onTap: () => _open(
                    context,
                    SyncPrivacyPreviewPage(database: widget.database),
                  ),
                ),
                _SettingsRow(
                  icon: Icons.storage_outlined,
                  title: 'Dados locais',
                  subtitle: 'Demonstração ou limpeza do aparelho',
                  onTap: () => _open(
                    context,
                    DataEnvironmentPage(
                      database: widget.database,
                      onChanged: widget.onEnvironmentChanged,
                    ),
                  ),
                  last: true,
                ),
              ],
            ),
            const SizedBox(height: 22),
            const ZimbaSectionTitle('Privacidade'),
            ZimbaCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _SettingsFeature(
                  icon: Icons.shield_outlined,
                  title: 'Dados locais primeiro',
                  subtitle:
                      'Seus dados ficam no aparelho. Backup e sync são escolhas explícitas.',
                  status: _privacyStatus(snapshot.data?.pendingSync),
                  tone: _privacyTone(snapshot.data?.pendingSync),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.last = false,
    this.status,
    this.tone = ZimbaTone.neutral,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool last;
  final String? status;
  final ZimbaTone tone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 3,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ZimbaColors.surfaceMuted,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, size: 20),
          ),
          title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status != null) ...[
                ZimbaBadge(label: status!, tone: tone),
                const SizedBox(width: 4),
              ],
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
        if (!last)
          const Divider(height: 1, indent: 68, color: ZimbaColors.border),
      ],
    );
  }
}

class _SettingsFeature extends StatelessWidget {
  const _SettingsFeature({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.accent = false,
    this.status,
    this.tone = ZimbaTone.neutral,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool accent;
  final String? status;
  final ZimbaTone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: accent ? ZimbaColors.accentSoft : ZimbaColors.surfaceMuted,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: accent ? ZimbaColors.accent : ZimbaColors.foreground,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ZimbaColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        if (status != null) ...[
          ZimbaBadge(label: status!, tone: tone),
          const SizedBox(width: 6),
        ],
        const Icon(Icons.chevron_right, size: 20),
      ],
    );
  }
}

class _SettingsOverview extends StatelessWidget {
  const _SettingsOverview({required this.localData, required this.loading});

  final LocalDataStatus? localData;
  final bool loading;

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
              color: ZimbaColors.successSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.phone_android_outlined,
              color: ZimbaColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Este aparelho',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 3),
                Text(
                  loading
                      ? 'Lendo o estado local…'
                      : localData == null
                      ? 'Não foi possível resumir os dados locais agora.'
                      : '${localData!.transactions} lançamento(s), ${localData!.accounts} conta(s) e ${localData!.people} pessoa(s).',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ZimbaColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          ZimbaBadge(
            label: loading
                ? 'Lendo'
                : localData == null
                ? 'Erro'
                : 'Local',
            tone: loading
                ? ZimbaTone.neutral
                : localData == null
                ? ZimbaTone.danger
                : ZimbaTone.success,
          ),
        ],
      ),
    );
  }
}

class _SettingsHubState {
  const _SettingsHubState({
    required this.notification,
    required this.localData,
    required this.pendingSync,
    required this.notificationDiagnostics,
  });

  final NotificationCaptureStatus notification;
  final LocalDataStatus localData;
  final List<SyncOutboxRow> pendingSync;
  final NotificationCaptureDiagnostics notificationDiagnostics;
}

String _notificationSubtitle(NotificationCaptureStatus? status) {
  if (status == null) return 'Lendo permissão, apps autorizados e fila local.';
  if (!status.available) return 'Recurso disponível apenas no Android.';
  if (!status.permissionGranted) {
    return 'Permissão ausente. Abra a jornada para conceder acesso.';
  }
  if (status.allowedPackages.isEmpty) {
    return 'Permissão concedida, mas nenhum app está autorizado.';
  }
  return '${status.allowedPackages.length} app(s) autorizado(s) · ${status.queue.pending} aguardando entrega.';
}

String _notificationStatus(NotificationCaptureStatus? status) {
  if (status == null) return 'Lendo';
  if (!status.available) return 'Indisponível';
  if (!status.permissionGranted) return 'Permissão';
  if (status.allowedPackages.isEmpty) return 'Sem apps';
  if (status.queue.pending > 0) return 'Pendente';
  return 'Ativa';
}

ZimbaTone _notificationTone(NotificationCaptureStatus? status) {
  if (status == null || !status.available) return ZimbaTone.neutral;
  if (!status.permissionGranted || status.allowedPackages.isEmpty) {
    return ZimbaTone.warning;
  }
  return status.queue.pending > 0 ? ZimbaTone.info : ZimbaTone.success;
}

String _syncSubtitle(List<SyncOutboxRow>? pendingSync) {
  if (pendingSync == null) return 'Consultando a fila local de operações.';
  if (pendingSync.isEmpty) {
    return 'Nenhuma operação aguardando envio. Sync segue opcional.';
  }
  return '${pendingSync.length} operação(ões) aguardando envio no aparelho.';
}

String _syncStatus(List<SyncOutboxRow>? pendingSync) {
  if (pendingSync == null) return 'Lendo';
  return pendingSync.isEmpty ? 'Local' : 'Pendente';
}

ZimbaTone _syncTone(List<SyncOutboxRow>? pendingSync) {
  if (pendingSync == null) return ZimbaTone.neutral;
  return pendingSync.isEmpty ? ZimbaTone.success : ZimbaTone.warning;
}

String _backupSubtitle(LocalDataStatus? localData) {
  if (localData == null) {
    return 'Consultando os dados que poderão ser exportados.';
  }
  if (localData.isEmpty) {
    return 'Ainda não há dados locais para incluir em um backup.';
  }
  return '${localData.transactions} lançamento(s), ${localData.accounts} conta(s) e ${localData.people} pessoa(s) serão incluídos.';
}

String _backupStatus(LocalDataStatus? localData) {
  if (localData == null) return 'Lendo';
  return localData.isEmpty ? 'Vazio' : 'Pronto';
}

ZimbaTone _backupTone(LocalDataStatus? localData) {
  if (localData == null) return ZimbaTone.neutral;
  return localData.isEmpty ? ZimbaTone.warning : ZimbaTone.success;
}

String _privacyStatus(List<SyncOutboxRow>? pendingSync) {
  if (pendingSync == null) return 'Lendo';
  return pendingSync.isEmpty ? 'Local' : 'Fila local';
}

ZimbaTone _privacyTone(List<SyncOutboxRow>? pendingSync) {
  if (pendingSync == null) return ZimbaTone.neutral;
  return ZimbaTone.success;
}
