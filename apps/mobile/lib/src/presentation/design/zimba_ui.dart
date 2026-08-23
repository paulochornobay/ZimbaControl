import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'zimba_theme.dart';

/// Shared visual primitives translated from the approved Lovable reference.
/// They deliberately contain no domain behaviour: screens keep their Drift
/// actions and only opt into the common layout language.
abstract final class ZimbaLayout {
  static const maxContentWidth = 440.0;
  static const pagePadding = EdgeInsets.symmetric(horizontal: 16);
  static const cardRadius = 16.0;
  static const controlRadius = 12.0;
}

class ZimbaViewport extends StatelessWidget {
  const ZimbaViewport({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }

    return ColoredBox(
      color: ZimbaColors.background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= ZimbaLayout.maxContentWidth) {
            return child;
          }
          return Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: ZimbaLayout.maxContentWidth,
              ),
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: ZimbaColors.background,
                border: Border.all(color: ZimbaColors.border),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F0F172A),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class ZimbaSection extends StatelessWidget {
  const ZimbaSection({
    required this.child,
    super.key,
    this.title,
    this.action,
    this.padding = const EdgeInsets.fromLTRB(16, 20, 16, 0),
  });

  final Widget child;
  final String? title;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || action != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title?.toUpperCase() ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: ZimbaColors.secondaryText,
                      letterSpacing: .9,
                    ),
                  ),
                ),
                ?action,
              ],
            ),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}

class ZimbaCard extends StatelessWidget {
  const ZimbaCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? ZimbaColors.surface,
        borderRadius: BorderRadius.circular(
          borderRadius ?? ZimbaLayout.cardRadius,
        ),
        border: Border.all(color: borderColor ?? ZimbaColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class ZimbaRows extends StatelessWidget {
  const ZimbaRows({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ZimbaLayout.cardRadius),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ZimbaColors.surface,
          border: Border.all(color: ZimbaColors.border),
        ),
        child: Column(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              children[index],
              if (index < children.length - 1)
                const Divider(height: 1, color: ZimbaColors.border),
            ],
          ],
        ),
      ),
    );
  }
}

enum ZimbaTone { neutral, accent, success, warning, danger, info }

class ZimbaBadge extends StatelessWidget {
  const ZimbaBadge({
    required this.label,
    super.key,
    this.tone = ZimbaTone.neutral,
    this.icon,
  });

  final String label;
  final ZimbaTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      ZimbaTone.neutral => (
        ZimbaColors.surfaceMuted,
        ZimbaColors.secondaryText,
      ),
      ZimbaTone.accent => (ZimbaColors.accentSoft, ZimbaColors.accent),
      ZimbaTone.success => (ZimbaColors.successSoft, ZimbaColors.success),
      ZimbaTone.warning => (ZimbaColors.warningSoft, ZimbaColors.warning),
      ZimbaTone.danger => (
        ZimbaColors.destructiveSoft,
        ZimbaColors.destructive,
      ),
      ZimbaTone.info => (ZimbaColors.infoSoft, ZimbaColors.foreground),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: colors.$2),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.$2,
                letterSpacing: .35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZimbaChipScroller extends StatelessWidget {
  const ZimbaChipScroller({
    required this.children,
    super.key,
    this.padding = ZimbaLayout.pagePadding,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) => children[index],
      ),
    );
  }
}

class ZimbaStateMessage extends StatelessWidget {
  const ZimbaStateMessage({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: ZimbaColors.accentSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(icon, size: 28, color: ZimbaColors.accent),
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

/// Reusable inline feedback for recoverable loading, import and local-action
/// failures. Screens provide the real operation and optional retry; this
/// component only keeps the visual treatment consistent.
class ZimbaFeedbackBanner extends StatelessWidget {
  const ZimbaFeedbackBanner({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
    this.tone = ZimbaTone.neutral,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final ZimbaTone tone;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      ZimbaTone.success => (ZimbaColors.successSoft, ZimbaColors.success),
      ZimbaTone.warning => (ZimbaColors.warningSoft, ZimbaColors.warning),
      ZimbaTone.danger => (
        ZimbaColors.destructiveSoft,
        ZimbaColors.destructive,
      ),
      ZimbaTone.accent => (ZimbaColors.accentSoft, ZimbaColors.accent),
      ZimbaTone.info => (ZimbaColors.infoSoft, ZimbaColors.foreground),
      ZimbaTone.neutral => (
        ZimbaColors.surfaceMuted,
        ZimbaColors.secondaryText,
      ),
    };
    return ZimbaCard(
      color: colors.$1,
      borderColor: colors.$1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.$2),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 3),
                Text(body, style: Theme.of(context).textTheme.bodySmall),
                if (action != null) ...[const SizedBox(height: 10), action!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact, semantic representation of people in list cards.  Names belong in
/// the detail flow; the queue keeps the same avatar-stack language as the
/// Lovable reference without risking a pale/truncated chip label.
class ZimbaAvatarStack extends StatelessWidget {
  const ZimbaAvatarStack({
    required this.names,
    super.key,
    this.maxVisible = 4,
    this.showCount = true,
  });

  final List<String> names;
  final int maxVisible;
  final bool showCount;

  static const _colors = <Color>[
    Color(0xFFE0F2FE),
    Color(0xFFEDE9FE),
    Color(0xFFFFEDD5),
    Color(0xFFDCFCE7),
  ];

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) {
      return Text(
        'Sem beneficiário',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
      );
    }

    final visible = names.take(maxVisible).toList(growable: false);
    final avatarWidth = 28.0 + (visible.length - 1) * 20.0;
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: avatarWidth,
          height: 28,
          child: Stack(
            children: [
              for (var index = 0; index < visible.length; index++)
                Positioned(
                  left: index * 20.0,
                  child: Tooltip(
                    message: visible[index],
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _colors[index % _colors.length],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ZimbaColors.surface,
                          width: 2,
                        ),
                      ),
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: Center(
                          child: Text(
                            visible[index].characters.first.toUpperCase(),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: ZimbaColors.foreground,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (names.length > maxVisible)
          Text(
            '+${names.length - maxVisible}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: ZimbaColors.secondaryText),
          ),
        if (showCount)
          Text(
            '${names.length} ${names.length == 1 ? 'beneficiário' : 'beneficiários'}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: ZimbaColors.secondaryText),
          ),
      ],
    );
  }
}

class ZimbaSuggestionTile extends StatelessWidget {
  const ZimbaSuggestionTile({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ZimbaColors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: ZimbaColors.secondaryText,
                letterSpacing: .45,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class ZimbaActionItem {
  const ZimbaActionItem({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.tone = ZimbaTone.neutral,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final ZimbaTone tone;
}

/// Four quick actions are horizontal on roomy phones and become a two-column
/// grid on narrow phones.  This deliberately favours readable labels over the
/// clipped icon-only fallback that caused the reported regression.
class ZimbaActionGrid extends StatelessWidget {
  const ZimbaActionGrid({required this.items, super.key});

  final List<ZimbaActionItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.length == 1) {
      return _ZimbaActionButton(item: items.single);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 390;
        if (narrow) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in items)
                SizedBox(
                  width: (constraints.maxWidth - 8) / 2,
                  child: _ZimbaActionButton(item: item),
                ),
            ],
          );
        }
        return Row(
          children: [
            for (var index = 0; index < items.length; index++) ...[
              Expanded(child: _ZimbaActionButton(item: items[index])),
              if (index < items.length - 1) const SizedBox(width: 6),
            ],
          ],
        );
      },
    );
  }
}

class _ZimbaActionButton extends StatelessWidget {
  const _ZimbaActionButton({required this.item});

  final ZimbaActionItem item;

  @override
  Widget build(BuildContext context) {
    final foreground = switch (item.tone) {
      ZimbaTone.success => Colors.white,
      ZimbaTone.danger => ZimbaColors.destructive,
      ZimbaTone.accent => ZimbaColors.accent,
      _ => ZimbaColors.foreground,
    };
    final background = switch (item.tone) {
      ZimbaTone.success => ZimbaColors.success,
      ZimbaTone.danger => ZimbaColors.surface,
      ZimbaTone.accent => ZimbaColors.surface,
      _ => ZimbaColors.surface,
    };
    final border = switch (item.tone) {
      ZimbaTone.success => ZimbaColors.success,
      _ => ZimbaColors.border,
    };

    return Semantics(
      button: true,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            height: 36,
            decoration: BoxDecoration(
              color: background,
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, size: 17, color: foreground),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: foreground,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ZimbaBottomNavigation extends StatelessWidget {
  const ZimbaBottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = <_ZimbaNavItem>[
    _ZimbaNavItem('Início', Icons.home_outlined, Icons.home_rounded),
    _ZimbaNavItem('Revisão', Icons.inbox_outlined, Icons.inbox_rounded),
    _ZimbaNavItem('Novo', Icons.add_circle_outline, Icons.add_circle),
    _ZimbaNavItem('Filtros', Icons.tune_outlined, Icons.tune_rounded),
    _ZimbaNavItem('Ajustes', Icons.settings_outlined, Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: ZimbaColors.surface,
        border: Border(top: BorderSide(color: ZimbaColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: [
              for (var index = 0; index < _items.length; index++)
                Expanded(
                  child: _ZimbaNavButton(
                    item: _items[index],
                    selected: selectedIndex == index,
                    onTap: () => onSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZimbaNavItem {
  const _ZimbaNavItem(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _ZimbaNavButton extends StatelessWidget {
  const _ZimbaNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _ZimbaNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = selected ? item.selectedIcon : item.icon;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: item.label == 'Novo' ? 28 : 21,
              color: selected
                  ? ZimbaColors.accent
                  : item.label == 'Novo'
                  ? ZimbaColors.foreground
                  : ZimbaColors.secondaryText,
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected
                    ? ZimbaColors.accent
                    : ZimbaColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
