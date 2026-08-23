import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'dashboard_page.dart';
import 'edit_transaction_page.dart';

enum ReviewFilter {
  all('all', 'Todos'),
  notification('notification', 'Notificacao'),
  csv('csv', 'CSV'),
  ofx('ofx', 'OFX'),
  manual('manual', 'Manual'),
  duplicates('duplicates', 'Duplicados'),
  lowConfidence('low_confidence', 'Baixa confianca'),
  transfers('transfers', 'Transferencias');

  const ReviewFilter(this.key, this.label);

  final String key;
  final String label;

  static ReviewFilter fromKey(String key) {
    return ReviewFilter.values.firstWhere(
      (filter) => filter.key == key,
      orElse: () => ReviewFilter.all,
    );
  }
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({required this.database, super.key, this.onNavigate});

  final AppDatabase database;
  final ValueChanged<int>? onNavigate;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.database.watchReviewFilter(),
      builder: (context, filterSnapshot) {
        final selectedFilter = ReviewFilter.fromKey(
          filterSnapshot.data ?? ReviewFilter.all.key,
        );

        return StreamBuilder<List<ReviewTransactionDetails>>(
          stream: widget.database.watchPendingReviewDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ReviewScaffold(
                count: 0,
                child: ReviewStateMessage(
                  icon: Icons.error_outline,
                  title: 'Nao foi possivel carregar',
                  body: 'A caixa de revisao encontrou um erro local.',
                  actionLabel: 'Tentar novamente',
                  onAction: () => setState(() {}),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const ReviewScaffold(
                count: 0,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final allItems =
                snapshot.data ?? const <ReviewTransactionDetails>[];
            final filteredItems = _applyFilter(allItems, selectedFilter);

            return ReviewScaffold(
              count: allItems.length,
              subtitle: allItems.isEmpty
                  ? 'Sem pendências'
                  : '${allItems.length} pendentes · ${filteredItems.length} nesta visão',
              child: allItems.isEmpty
                  ? const ReviewStateMessage(
                      icon: Icons.inbox_outlined,
                      title: 'Caixa zerada',
                      body:
                          'Novas notificacoes, importacoes e rascunhos manuais aparecem aqui.',
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
                      children: [
                        ReviewFilterBar(
                          selected: selectedFilter,
                          onSelected: (filter) =>
                              widget.database.setReviewFilter(filter.key),
                        ),
                        const SizedBox(height: 28),
                        if (filteredItems.isEmpty)
                          ReviewStateMessage(
                            icon: Icons.filter_alt_off_outlined,
                            title: 'Nada neste filtro',
                            body:
                                'Troque o filtro para continuar a revisao dos lancamentos pendentes.',
                            actionLabel: 'Ver todos',
                            onAction: () => widget.database.setReviewFilter(
                              ReviewFilter.all.key,
                            ),
                          )
                        else ...[
                          for (final item in filteredItems) ...[
                            ReviewTransactionCard(
                              item: item,
                              onConfirm: () => _runAction(
                                item,
                                'Lancamento confirmado',
                                () => widget.database.confirmTransaction(
                                  item.transaction.id,
                                ),
                              ),
                              onIgnore: () => _runAction(
                                item,
                                'Lancamento ignorado',
                                () => widget.database.ignoreTransaction(
                                  item.transaction.id,
                                ),
                              ),
                              onDuplicate: () => _runAction(
                                item,
                                'Marcado como duplicado',
                                () => widget.database.markDuplicateAndResolve(
                                  item.transaction.id,
                                ),
                              ),
                              onTransfer: () => _runAction(
                                item,
                                'Convertido em transferencia',
                                () => widget.database.convertToTransfer(
                                  item.transaction.id,
                                ),
                              ),
                              onEdit: () => _openEdit(item.transaction.id),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  List<ReviewTransactionDetails> _applyFilter(
    List<ReviewTransactionDetails> items,
    ReviewFilter filter,
  ) {
    return switch (filter) {
      ReviewFilter.all => items,
      ReviewFilter.notification =>
        items
            .where(
              (item) => item.sources.any((s) => s.sourceKind == 'notification'),
            )
            .toList(growable: false),
      ReviewFilter.csv =>
        items
            .where((item) => item.sources.any((s) => s.sourceKind == 'csv'))
            .toList(growable: false),
      ReviewFilter.ofx =>
        items
            .where((item) => item.sources.any((s) => s.sourceKind == 'ofx'))
            .toList(growable: false),
      ReviewFilter.manual =>
        items
            .where((item) => item.sources.any((s) => s.sourceKind == 'manual'))
            .toList(growable: false),
      ReviewFilter.duplicates =>
        items.where((item) => item.isProbableDuplicate).toList(growable: false),
      ReviewFilter.lowConfidence =>
        items.where((item) => item.hasLowConfidence).toList(growable: false),
      ReviewFilter.transfers =>
        items.where((item) => item.suggestsTransfer).toList(growable: false),
    };
  }

  Future<void> _openEdit(String transactionId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EditTransactionPage(
          database: widget.database,
          transactionId: transactionId,
          onNavigate: widget.onNavigate,
        ),
      ),
    );
  }

  Future<void> _runAction(
    ReviewTransactionDetails item,
    String message,
    Future<void> Function() action,
  ) async {
    final snapshot = await widget.database.captureReviewSnapshot(
      item.transaction.id,
    );
    if (snapshot == null) {
      return;
    }

    await action();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () => widget.database.restoreReviewSnapshot(snapshot),
        ),
      ),
    );
  }
}

class ReviewScaffold extends StatelessWidget {
  const ReviewScaffold({
    required this.count,
    required this.child,
    this.subtitle,
    super.key,
  });

  final int count;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 82,
        titleSpacing: 20,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: ZimbaColors.border),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Caixa de revisão',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                letterSpacing: -.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle ?? '$count pendentes nesta visão',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ZimbaColors.secondaryText,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

class ReviewFilterBar extends StatelessWidget {
  const ReviewFilterBar({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final ReviewFilter selected;
  final ValueChanged<ReviewFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return ZimbaChipScroller(
      padding: EdgeInsets.zero,
      children: [
        for (final filter in ReviewFilter.values)
          _ReviewFilterButton(
            filter: filter,
            selected: selected == filter,
            onTap: () => onSelected(filter),
          ),
      ],
    );
  }
}

class _ReviewFilterButton extends StatelessWidget {
  const _ReviewFilterButton({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final ReviewFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? ZimbaColors.foreground : ZimbaColors.surface,
            border: Border.all(
              color: selected ? ZimbaColors.foreground : ZimbaColors.border,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            filter.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected ? Colors.white : ZimbaColors.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class ReviewQueueHeader extends StatelessWidget {
  const ReviewQueueHeader({
    required this.current,
    required this.total,
    super.key,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ZimbaColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.playlist_add_check,
              size: 18,
              color: ZimbaColors.secondaryText,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Revisao sequencial: $current itens filtrados de $total pendentes',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewTransactionCard extends StatelessWidget {
  const ReviewTransactionCard({
    required this.item,
    required this.onConfirm,
    required this.onIgnore,
    required this.onDuplicate,
    required this.onTransfer,
    required this.onEdit,
    super.key,
  });

  final ReviewTransactionDetails item;
  final VoidCallback onConfirm;
  final VoidCallback onIgnore;
  final VoidCallback onDuplicate;
  final VoidCallback onTransfer;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final transaction = item.transaction;
    final isIncome = transaction.amountCents > 0;
    final scheme = Theme.of(context).colorScheme;

    return ZimbaCard(
      padding: EdgeInsets.zero,
      borderColor: _borderColor(scheme),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasAlert) ReviewAlertStrip(item: item),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.displayMerchant,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            transaction.descriptionRaw,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: ZimbaColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 104,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              formatBrl(transaction.amountCents),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: isIncome
                                        ? Colors.green.shade700
                                        : null,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          Text(
                            formatShortDate(transaction.occurredAt),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (item.syncConflictSummary case final summary?) ...[
                  const SizedBox(height: 8),
                  Text(
                    summary,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    ReviewMeta(
                      icon: Icons.notifications_none_outlined,
                      label: item.sourceLabel,
                    ),
                    ReviewMeta(
                      icon: Icons.credit_card_outlined,
                      label: item.accountLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ZimbaSuggestionTile(
                        label: 'Categoria',
                        value: item.categoryLabel,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ZimbaSuggestionTile(
                        label: 'Centro de custo',
                        value: item.costCenterLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ZimbaAvatarStack(
                        names: [
                          for (final person in item.beneficiaries)
                            person.displayName,
                        ],
                        showCount: false,
                      ),
                    ),
                    ZimbaBadge(
                      label:
                          '${transaction.sourceConfidence >= .8
                              ? 'Alta'
                              : transaction.sourceConfidence >= .55
                              ? 'Média'
                              : 'Baixa'} · ${(transaction.sourceConfidence * 100).round()}%',
                      tone: transaction.sourceConfidence >= .8
                          ? ZimbaTone.success
                          : transaction.sourceConfidence >= .55
                          ? ZimbaTone.warning
                          : ZimbaTone.danger,
                      icon: Icons.auto_awesome_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ZimbaActionGrid(
                  items: [
                    ZimbaActionItem(
                      label: 'Confirmar',
                      icon: Icons.check,
                      tone: ZimbaTone.success,
                      onPressed: onConfirm,
                    ),
                    ZimbaActionItem(
                      label: 'Editar',
                      icon: Icons.edit_outlined,
                      onPressed: onEdit,
                    ),
                    ZimbaActionItem(
                      label: item.suggestsTransfer
                          ? 'Transferência'
                          : 'Duplicado',
                      icon: item.suggestsTransfer
                          ? Icons.compare_arrows_outlined
                          : Icons.content_copy_outlined,
                      tone: item.suggestsTransfer
                          ? ZimbaTone.accent
                          : ZimbaTone.danger,
                      onPressed: item.suggestsTransfer
                          ? onTransfer
                          : onDuplicate,
                    ),
                    ZimbaActionItem(
                      label: 'Ignorar',
                      icon: Icons.visibility_off_outlined,
                      onPressed: onIgnore,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get _hasAlert =>
      item.syncConflict != null ||
      item.hasLowConfidence ||
      item.isProbableDuplicate ||
      item.suggestsTransfer ||
      item.hasInstallmentHint;

  Color _borderColor(ColorScheme scheme) {
    if (item.syncConflict != null) {
      return scheme.error.withValues(alpha: 0.7);
    }
    if (item.isProbableDuplicate) {
      return scheme.error.withValues(alpha: 0.45);
    }
    if (item.hasLowConfidence) {
      return Colors.orange.withValues(alpha: 0.55);
    }
    if (item.suggestsTransfer) {
      return scheme.primary.withValues(alpha: 0.4);
    }
    return scheme.outlineVariant;
  }
}

class ReviewAlertStrip extends StatelessWidget {
  const ReviewAlertStrip({required this.item, super.key});

  final ReviewTransactionDetails item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final alert = _alertData(scheme);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: alert.color.withValues(alpha: 0.12),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Icon(alert.icon, size: 16, color: alert.color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                alert.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: alert.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ReviewAlert _alertData(ColorScheme scheme) {
    if (item.syncConflict != null) {
      return _ReviewAlert(
        Icons.sync_problem_outlined,
        'Conflito entre aparelhos: escolha qual estado manter',
        scheme.error,
      );
    }
    if (item.isProbableDuplicate) {
      return _ReviewAlert(
        Icons.content_copy_outlined,
        'Possivel duplicidade',
        scheme.error,
      );
    }
    if (item.suggestsTransfer) {
      return _ReviewAlert(
        Icons.compare_arrows_outlined,
        'Parece transferencia',
        scheme.primary,
      );
    }
    if (item.hasLowConfidence) {
      return _ReviewAlert(
        Icons.warning_amber_outlined,
        '${item.reviewReason} · conferir antes de confirmar',
        Colors.orange.shade800,
      );
    }
    return _ReviewAlert(
      Icons.layers_outlined,
      'Possivel parcela ou compromisso',
      scheme.secondary,
    );
  }
}

class _ReviewAlert {
  const _ReviewAlert(this.icon, this.text, this.color);

  final IconData icon;
  final String text;
  final Color color;
}

class ReviewMeta extends StatelessWidget {
  const ReviewMeta({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 135),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: ZimbaColors.secondaryText),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewStateMessage extends StatelessWidget {
  const ReviewStateMessage({
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

String formatShortDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month';
}
