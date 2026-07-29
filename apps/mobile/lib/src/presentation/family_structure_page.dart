import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../infrastructure/notification_capture_service.dart';
import 'dashboard_page.dart';

class FamilyStructurePage extends StatelessWidget {
  const FamilyStructurePage({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FamilyStructureSnapshot>(
      future: database.getFamilyStructureSnapshot(),
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
              database: database,
              snapshot: snapshot.data!,
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
    super.key,
  });

  final AppDatabase database;
  final FamilyStructureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
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
