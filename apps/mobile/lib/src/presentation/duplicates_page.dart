import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

class DuplicatesPage extends StatefulWidget {
  const DuplicatesPage({required this.database, super.key});

  final AppDatabase database;

  @override
  State<DuplicatesPage> createState() => _DuplicatesPageState();
}

class _DuplicatesPageState extends State<DuplicatesPage> {
  late Future<List<DuplicateCandidateDetails>> future;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    future = widget.database.listOpenDuplicateCandidateDetails();
  }

  void refresh() {
    setState(() {
      future = widget.database.listOpenDuplicateCandidateDetails();
    });
  }

  Future<void> resolve(String id, String resolution, String message) async {
    setState(() => loading = true);
    await widget.database.resolveDuplicateCandidate(
      id: id,
      resolution: resolution,
    );
    if (!mounted) {
      return;
    }
    setState(() => loading = false);
    refresh();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 82,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Duplicidades',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(letterSpacing: -.5),
            ),
            const SizedBox(height: 3),
            Text(
              'Comparar e resolver',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ZimbaColors.secondaryText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<DuplicateCandidateDetails>>(
        future: future,
        builder: (context, snapshot) {
          final items = snapshot.data ?? const <DuplicateCandidateDetails>[];
          if (snapshot.connectionState == ConnectionState.waiting &&
              items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (items.isEmpty) {
            return const _EmptyDuplicatesState();
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            children: [
              if (loading) const LinearProgressIndicator(),
              for (final item in items) ...[
                _DuplicateCard(
                  details: item,
                  onMerge: () => resolve(
                    item.candidate.id,
                    'merge',
                    'Duplicidade mesclada.',
                  ),
                  onKeep: () => resolve(
                    item.candidate.id,
                    'kept_separate',
                    'Lancamentos mantidos separados.',
                  ),
                  onIgnore: () => resolve(
                    item.candidate.id,
                    'ignored',
                    'Sugestao ignorada.',
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _DuplicateCard extends StatelessWidget {
  const _DuplicateCard({
    required this.details,
    required this.onMerge,
    required this.onKeep,
    required this.onIgnore,
  });

  final DuplicateCandidateDetails details;
  final VoidCallback onMerge;
  final VoidCallback onKeep;
  final VoidCallback onIgnore;

  @override
  Widget build(BuildContext context) {
    final candidate = details.candidate;
    return ZimbaCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: ZimbaColors.warningSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(9),
                  child: Icon(
                    Icons.merge_type_outlined,
                    size: 18,
                    color: ZimbaColors.warning,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      candidate.reason,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    ZimbaBadge(
                      label: '${(candidate.score * 100).round()}% de confiança',
                      tone: candidate.score >= .8
                          ? ZimbaTone.warning
                          : ZimbaTone.neutral,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            candidate.explanation,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          _CompareTile(
            label: 'Lancamento principal',
            title:
                details.primaryTransaction?.descriptionRaw ?? 'Nao encontrado',
            amountCents: details.primaryTransaction?.amountCents,
          ),
          const SizedBox(height: 8),
          _CompareTile(
            label: 'Fonte candidata',
            title:
                details.candidateTransaction?.descriptionRaw ??
                details.stagedRecord?.descriptionRaw ??
                'Registro em staging',
            amountCents:
                details.candidateTransaction?.amountCents ??
                details.stagedRecord?.amountCents,
          ),
          const SizedBox(height: 12),
          _DuplicateActions(
            onMerge: onMerge,
            onKeep: onKeep,
            onIgnore: onIgnore,
          ),
        ],
      ),
    );
  }
}

class _CompareTile extends StatelessWidget {
  const _CompareTile({
    required this.label,
    required this.title,
    required this.amountCents,
  });

  final String label;
  final String title;
  final int? amountCents;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ZimbaColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: ZimbaColors.secondaryText,
                letterSpacing: .45,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (amountCents != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  formatBrl(amountCents!),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DuplicateActions extends StatelessWidget {
  const _DuplicateActions({
    required this.onMerge,
    required this.onKeep,
    required this.onIgnore,
  });

  final VoidCallback onMerge;
  final VoidCallback onKeep;
  final VoidCallback onIgnore;

  @override
  Widget build(BuildContext context) {
    final actions = [
      ZimbaActionItem(
        label: 'Mesclar',
        icon: Icons.merge_type_outlined,
        tone: ZimbaTone.success,
        onPressed: onMerge,
      ),
      ZimbaActionItem(
        label: 'Manter separados',
        icon: Icons.call_split_outlined,
        onPressed: onKeep,
      ),
      ZimbaActionItem(
        label: 'Ignorar',
        icon: Icons.visibility_off_outlined,
        onPressed: onIgnore,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 390) {
          return Column(
            children: [
              for (var index = 0; index < actions.length; index++) ...[
                SizedBox(
                  width: double.infinity,
                  child: ZimbaActionGrid(items: [actions[index]]),
                ),
                if (index < actions.length - 1) const SizedBox(height: 8),
              ],
            ],
          );
        }
        return ZimbaActionGrid(items: actions);
      },
    );
  }
}

class _EmptyDuplicatesState extends StatelessWidget {
  const _EmptyDuplicatesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 48),
            const SizedBox(height: 12),
            Text(
              'Sem duplicidades abertas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Importacoes e notificacoes suspeitas aparecem aqui para revisao.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
