import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'commitments_page.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'duplicates_page.dart';
import 'family_structure_page.dart';
import 'feature_availability_page.dart';
import 'import_page.dart';
import 'registries_page.dart';

class SettingsHomePage extends StatelessWidget {
  const SettingsHomePage({
    required this.database,
    required this.onEnvironmentChanged,
    super.key,
  });

  final AppDatabase database;
  final VoidCallback onEnvironmentChanged;

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          const ZimbaSectionTitle('Captura de notificação'),
          ZimbaCard(
            padding: EdgeInsets.zero,
            child: InkWell(
              borderRadius: BorderRadius.circular(ZimbaLayout.cardRadius),
              onTap: () =>
                  _open(context, NotificationSettingsPage(database: database)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: _SettingsFeature(
                  icon: Icons.notifications_none_outlined,
                  title: 'Captura Android',
                  subtitle:
                      'Permissão, Nubank, Mercado Pago e eventos recentes.',
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
                onTap: () => _open(context, ImportPage(database: database)),
              ),
              _SettingsRow(
                icon: Icons.content_copy_outlined,
                title: 'Resolver duplicidades',
                subtitle: 'Compare e mescle fontes',
                onTap: () => _open(context, DuplicatesPage(database: database)),
              ),
              _SettingsRow(
                icon: Icons.auto_awesome_outlined,
                title: 'Regras',
                subtitle: 'Estado da classificação e próximos recursos',
                onTap: () =>
                    _open(context, RulesPreviewPage(database: database)),
              ),
              _SettingsRow(
                icon: Icons.people_alt_outlined,
                title: 'Estrutura familiar',
                subtitle: 'Pessoas, contas e responsáveis',
                onTap: () =>
                    _open(context, FamilyStructurePage(database: database)),
              ),
              _SettingsRow(
                icon: Icons.tune_outlined,
                title: 'Cadastros',
                subtitle: 'Contas, cartões, categorias e centros',
                onTap: () => _open(context, RegistriesPage(database: database)),
              ),
              _SettingsRow(
                icon: Icons.event_repeat_outlined,
                title: 'Compromissos',
                subtitle: 'Recorrências e parcelamentos',
                onTap: () =>
                    _open(context, CommitmentsPage(database: database)),
              ),
              _SettingsRow(
                icon: Icons.archive_outlined,
                title: 'Backup e recuperação',
                subtitle: 'Exportar, validar e restaurar',
                onTap: () =>
                    _open(context, BackupSettingsPage(database: database)),
              ),
              _SettingsRow(
                icon: Icons.sync_outlined,
                title: 'Sync e privacidade',
                subtitle: 'Fila local, sync opcional e dados protegidos',
                onTap: () =>
                    _open(context, SyncPrivacyPreviewPage(database: database)),
              ),
              _SettingsRow(
                icon: Icons.storage_outlined,
                title: 'Dados locais',
                subtitle: 'Demonstração ou limpeza do aparelho',
                onTap: () => _open(
                  context,
                  DataEnvironmentPage(
                    database: database,
                    onChanged: onEnvironmentChanged,
                  ),
                ),
                last: true,
              ),
            ],
          ),
          const SizedBox(height: 22),
          const ZimbaSectionTitle('Sobre'),
          const ZimbaCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _SettingsFeature(
                icon: Icons.shield_outlined,
                title: 'ZimbaControl 1.0',
                subtitle:
                    'Offline-first. Seus dados financeiros ficam no aparelho.',
              ),
            ),
          ),
        ],
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool last;

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
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right, size: 20),
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool accent;

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
        const Icon(Icons.chevron_right, size: 20),
      ],
    );
  }
}
