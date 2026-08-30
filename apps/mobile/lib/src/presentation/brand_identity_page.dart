import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'design/zimba_brand.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

class BrandIdentityPage extends StatefulWidget {
  const BrandIdentityPage({super.key, this.onNavigate});

  final ValueChanged<int>? onNavigate;

  @override
  State<BrandIdentityPage> createState() => _BrandIdentityPageState();
}

class _BrandIdentityPageState extends State<BrandIdentityPage> {
  var darkPreview = false;
  var touchTarget = true;
  String? copiedHex;

  Future<void> copyColor(String hex) async {
    await Clipboard.setData(ClipboardData(text: hex));
    if (!mounted) return;
    setState(() => copiedHex = hex);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (mounted && copiedHex == hex) setState(() => copiedHex = null);
  }

  void navigate(int index) {
    if (index == 4) {
      Navigator.maybePop(context);
      return;
    }
    Navigator.maybePop(context);
    widget.onNavigate?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 48,
        leading: IconButton(
          tooltip: 'Voltar',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(LucideIcons.chevronLeft, color: ZimbaColors.accent),
        ),
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Identidade Visual'),
            SizedBox(height: 2),
            Text(
              'Marca, cores, tipografia e tokens',
              style: TextStyle(
                color: ZimbaColors.secondaryText,
                fontSize: 12,
                height: 1.2,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        shape: const Border(bottom: BorderSide(color: ZimbaColors.border)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: _Hero(
              dark: darkPreview,
              onChanged: (value) => setState(() => darkPreview = value),
            ),
          ),
          const _SectionTitle(label: 'Variações da marca', top: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _LogoVariations(),
          ),
          const _SectionTitle(
            label: 'Paleta de cores',
            trailing: Text(
              'toque para copiar',
              style: TextStyle(color: ZimbaColors.secondaryText, fontSize: 10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                for (var index = 0; index < _swatchGroups.length; index++) ...[
                  _SwatchGroup(
                    group: _swatchGroups[index],
                    copiedHex: copiedHex,
                    onCopy: copyColor,
                  ),
                  if (index < _swatchGroups.length - 1)
                    const SizedBox(height: 20),
                ],
              ],
            ),
          ),
          const _IconSectionTitle(icon: LucideIcons.type, label: 'Tipografia'),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _TypographyCard(),
          ),
          const _IconSectionTitle(
            icon: LucideIcons.ruler,
            label: 'Espaçamento · grade 4 px',
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _SpacingCard(),
          ),
          const _IconSectionTitle(
            icon: LucideIcons.boxes,
            label: 'Raios de canto',
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _RadiusGrid(),
          ),
          const _IconSectionTitle(icon: LucideIcons.layers, label: 'Sombras'),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _ShadowGrid(),
          ),
          const _IconSectionTitle(
            icon: LucideIcons.palette,
            label: 'Componentes',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _ComponentCatalog(
              touchTarget: touchTarget,
              onTouchTargetChanged: (value) =>
                  setState(() => touchTarget = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: OutlinedButton(
              onPressed: () => Navigator.maybePop(context),
              child: const Text('← Voltar para Ajustes'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ZimbaBottomNavigation(
        selectedIndex: 4,
        onSelected: navigate,
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.dark, required this.onChanged});

  final bool dark;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: dark ? ZimbaColors.foreground : ZimbaColors.surface,
        border: Border.all(color: ZimbaColors.border),
        borderRadius: BorderRadius.circular(ZimbaRadii.lg),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 4,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ZimbaColors.logoGradientStart,
                    ZimbaColors.logoGradientEnd,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              children: [
                ZimbaLogo(
                  size: ZimbaLogoSize.xl,
                  tone: dark ? ZimbaLogoTone.monoLight : ZimbaLogoTone.color,
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Text(
                    'Finanças pessoais e familiares com classificação profunda de lançamentos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dark
                          ? ZimbaColors.surface.withValues(alpha: .7)
                          : ZimbaColors.secondaryText,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _ToneSegmented(dark: dark, onChanged: onChanged),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToneSegmented extends StatelessWidget {
  const _ToneSegmented({required this.dark, required this.onChanged});

  final bool dark;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ZimbaColors.muted,
        borderRadius: BorderRadius.circular(ZimbaRadii.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ToneOption(
              label: 'Claro',
              selected: !dark,
              onTap: () => onChanged(false),
            ),
            _ToneOption(
              label: 'Escuro',
              selected: dark,
              onTap: () => onChanged(true),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToneOption extends StatelessWidget {
  const _ToneOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          constraints: const BoxConstraints(minHeight: 36, minWidth: 68),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? ZimbaColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: selected ? ZimbaShadows.card : null,
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label, this.trailing, this.top = 24});

  final String label;
  final Widget? trailing;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, top, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _IconSectionTitle extends StatelessWidget {
  const _IconSectionTitle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ZimbaColors.accentSoft,
              borderRadius: BorderRadius.circular(ZimbaRadii.md),
            ),
            child: Icon(icon, size: 16, color: ZimbaColors.accent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoVariations extends StatelessWidget {
  const _LogoVariations();

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MicroLabel('Lockup (símbolo + texto)'),
          const SizedBox(height: 8),
          const Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 20,
            runSpacing: 12,
            children: [
              ZimbaLogo(size: ZimbaLogoSize.sm),
              ZimbaLogo(size: ZimbaLogoSize.md),
              ZimbaLogo(size: ZimbaLogoSize.lg),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MicroLabel('Símbolo'),
                    SizedBox(height: 8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 10,
                      children: [
                        ZimbaLogo(
                          variant: ZimbaLogoVariant.mark,
                          size: ZimbaLogoSize.sm,
                        ),
                        ZimbaLogo(
                          variant: ZimbaLogoVariant.mark,
                          size: ZimbaLogoSize.md,
                        ),
                        ZimbaLogo(
                          variant: ZimbaLogoVariant.mark,
                          size: ZimbaLogoSize.lg,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MicroLabel('Wordmark'),
                    SizedBox(height: 8),
                    ZimbaLogo(
                      variant: ZimbaLogoVariant.wordmark,
                      size: ZimbaLogoSize.sm,
                    ),
                    SizedBox(height: 8),
                    ZimbaLogo(
                      variant: ZimbaLogoVariant.wordmark,
                      size: ZimbaLogoSize.md,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _MicroLabel('Monocromático'),
          const SizedBox(height: 8),
          const ZimbaLogo(size: ZimbaLogoSize.md, tone: ZimbaLogoTone.monoDark),
        ],
      ),
    );
  }
}

class _MicroLabel extends StatelessWidget {
  const _MicroLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: ZimbaColors.secondaryText,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: .7,
      ),
    );
  }
}

class _Swatch {
  const _Swatch(this.name, this.hex, this.color);

  final String name;
  final String hex;
  final Color color;
}

class _SwatchGroupData {
  const _SwatchGroupData(this.label, this.colors);

  final String label;
  final List<_Swatch> colors;
}

const _swatchGroups = [
  _SwatchGroupData('Superfícies', [
    _Swatch('Background', '#F7F8FA', ZimbaColors.background),
    _Swatch('Surface', '#FFFFFF', ZimbaColors.surface),
    _Swatch('Surface Muted', '#F1F3F6', ZimbaColors.surfaceMuted),
    _Swatch('Muted', '#EEF1F4', ZimbaColors.muted),
  ]),
  _SwatchGroupData('Marca', [
    _Swatch('Primary', '#111827', ZimbaColors.primary),
    _Swatch('Primary Foreground', '#FFFFFF', ZimbaColors.surface),
    _Swatch('Accent', '#0EA5E9', ZimbaColors.accent),
    _Swatch('Accent Soft', '#E0F2FE', ZimbaColors.accentSoft),
    _Swatch('Secondary', '#6B7280', ZimbaColors.secondary),
  ]),
  _SwatchGroupData('Status', [
    _Swatch('Success', '#16A34A', ZimbaColors.success),
    _Swatch('Success Soft', '#DCFCE7', ZimbaColors.successSoft),
    _Swatch('Warning', '#D97706', ZimbaColors.warning),
    _Swatch('Warning Soft', '#FEF3C7', ZimbaColors.warningSoft),
    _Swatch('Danger', '#DC2626', ZimbaColors.destructive),
    _Swatch('Danger Soft', '#FEE2E2', ZimbaColors.destructiveSoft),
    _Swatch('Info Soft', '#EDE9FE', ZimbaColors.infoSoft),
  ]),
  _SwatchGroupData('Neutros', [
    _Swatch('Foreground', '#0F172A', ZimbaColors.foreground),
    _Swatch('Text Secondary', '#475569', ZimbaColors.secondaryText),
    _Swatch('Border', '#E2E8F0', ZimbaColors.border),
    _Swatch('Border Strong', '#CBD5E1', ZimbaColors.borderStrong),
  ]),
];

class _SwatchGroup extends StatelessWidget {
  const _SwatchGroup({
    required this.group,
    required this.copiedHex,
    required this.onCopy,
  });

  final _SwatchGroupData group;
  final String? copiedHex;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MicroLabel(group.label),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: group.colors.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 106,
          ),
          itemBuilder: (context, index) {
            final swatch = group.colors[index];
            return Semantics(
              button: true,
              label: 'Copiar ${swatch.name} ${swatch.hex}',
              child: InkWell(
                onTap: () => onCopy(swatch.hex),
                borderRadius: BorderRadius.circular(ZimbaRadii.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: swatch.color,
                        border: Border.all(color: ZimbaColors.border),
                        borderRadius: BorderRadius.circular(ZimbaRadii.md),
                        boxShadow: ZimbaShadows.card,
                      ),
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.all(6),
                      child: copiedHex == swatch.hex
                          ? Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: ZimbaColors.foreground.withValues(
                                  alpha: .1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(LucideIcons.check, size: 14),
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      swatch.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.noScaling,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      swatch.hex,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.noScaling,
                      style: const TextStyle(
                        color: ZimbaColors.secondaryText,
                        fontSize: 10,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TypographyCard extends StatelessWidget {
  const _TypographyCard();

  static const rows = [
    ('Saldo da família', 'Display XL', 34.0, FontWeight.w700, 1.12),
    ('Caixa de Revisão', 'Display L', 26.0, FontWeight.w700, 1.15),
    ('Movimentações', 'Display M', 19.0, FontWeight.w600, 1.2),
    (
      'Confirme a classificação sugerida pelo app.',
      'Body L',
      16.0,
      FontWeight.w400,
      1.5,
    ),
    (
      'Pagador, beneficiários e centro de custo.',
      'Body M',
      14.0,
      FontWeight.w400,
      1.5,
    ),
    ('Confiança 92% · regra Mercado', 'Caption', 12.0, FontWeight.w400, 1.4),
    ('SUGERIDO', 'Micro', 10.0, FontWeight.w600, 1.2),
    ('+R\$ 8.420,00', 'Tabular Num', 24.0, FontWeight.w600, 1.2),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ZimbaRadii.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ZimbaColors.surface,
          border: Border.all(color: ZimbaColors.border),
          borderRadius: BorderRadius.circular(ZimbaRadii.lg),
          boxShadow: ZimbaShadows.card,
        ),
        child: Column(
          children: [
            const ColoredBox(
              color: ZimbaColors.muted,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inter / SF Pro Display',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Tabular figures em valores · pesos 400, 500, 600, 700',
                        style: TextStyle(
                          color: ZimbaColors.secondaryText,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            for (var index = 0; index < rows.length; index++) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rows[index].$1,
                        style: TextStyle(
                          color: rows[index].$2 == 'Tabular Num'
                              ? ZimbaColors.success
                              : ZimbaColors.foreground,
                          fontSize: rows[index].$3,
                          fontWeight: rows[index].$4,
                          height: rows[index].$5,
                          fontFeatures: rows[index].$2 == 'Tabular Num'
                              ? const [FontFeature.tabularFigures()]
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rows[index].$2.toUpperCase(),
                        style: const TextStyle(
                          color: ZimbaColors.secondaryText,
                          fontSize: 10,
                          letterSpacing: .6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (index < rows.length - 1) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpacingCard extends StatelessWidget {
  const _SpacingCard();

  static const steps = [
    (4, '1'),
    (8, '2'),
    (12, '3'),
    (16, '4'),
    (20, '5'),
    (24, '6'),
    (32, '8'),
    (40, '10'),
    (48, '12'),
  ];

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      child: Column(
        children: [
          for (final step in steps) ...[
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Text(
                    '${step.$1}px',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: ZimbaColors.secondaryText,
                      fontSize: 11,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 24,
                  child: Text(
                    step.$2,
                    style: const TextStyle(
                      color: ZimbaColors.secondaryText,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: step.$1.toDouble(),
                  height: 24,
                  decoration: BoxDecoration(
                    color: ZimbaColors.accent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            if (step != steps.last) const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          const Text.rich(
            TextSpan(
              style: TextStyle(
                color: ZimbaColors.secondaryText,
                fontSize: 11,
                height: 1.35,
              ),
              children: [
                TextSpan(text: 'Margem lateral padrão: '),
                TextSpan(
                  text: '16 px',
                  style: TextStyle(
                    color: ZimbaColors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: '. Alvos de toque mínimos: '),
                TextSpan(
                  text: '48 px',
                  style: TextStyle(
                    color: ZimbaColors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RadiusGrid extends StatelessWidget {
  const _RadiusGrid();

  static const values = [
    ('sm', 8.0),
    ('md', 12.0),
    ('lg', 16.0),
    ('xl', 20.0),
    ('2xl', 24.0),
    ('3xl', 28.0),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 88,
      ),
      itemBuilder: (context, index) {
        final value = values[index];
        return Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ZimbaColors.surface,
                  border: Border.all(color: ZimbaColors.border),
                  borderRadius: BorderRadius.circular(value.$2),
                  boxShadow: ZimbaShadows.card,
                ),
                child: Text(
                  '${value.$2.toInt()}px',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value.$1.toUpperCase(),
              style: const TextStyle(
                color: ZimbaColors.secondaryText,
                fontSize: 10,
                letterSpacing: .5,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShadowGrid extends StatelessWidget {
  const _ShadowGrid();

  @override
  Widget build(BuildContext context) {
    final values = [
      ('card', ZimbaShadows.card),
      ('elevated', ZimbaShadows.elevated),
      (
        'nav',
        const <BoxShadow>[
          BoxShadow(color: ZimbaColors.border, offset: Offset(0, -1)),
        ],
      ),
    ];
    return Row(
      children: [
        for (var index = 0; index < values.length; index++) ...[
          Expanded(
            child: Container(
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ZimbaColors.surface,
                border: Border.all(color: ZimbaColors.border),
                borderRadius: BorderRadius.circular(ZimbaRadii.lg),
                boxShadow: values[index].$2,
              ),
              child: Text(
                values[index].$1,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (index < values.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _ComponentCatalog extends StatelessWidget {
  const _ComponentCatalog({
    required this.touchTarget,
    required this.onTouchTargetChanged,
  });

  final bool touchTarget;
  final ValueChanged<bool> onTouchTargetChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ZimbaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MicroLabel('Botões'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(onPressed: () {}, child: const Text('Primário')),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: ZimbaColors.success,
                    ),
                    onPressed: () {},
                    child: const Text('Confirmar'),
                  ),
                  OutlinedButton(onPressed: () {}, child: const Text('Editar')),
                  TextButton(onPressed: () {}, child: const Text('Ghost')),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ZimbaColors.destructive,
                    ),
                    onPressed: () {},
                    child: const Text('Excluir'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Exemplo',
                    onPressed: () {},
                    icon: const Icon(LucideIcons.star),
                  ),
                  const SizedBox(width: 8),
                  const FilledButton(
                    onPressed: null,
                    child: Text('Desativado'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const ZimbaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MicroLabel('Badges & Chips'),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ZimbaBadge(label: 'Parcela'),
                  ZimbaBadge(label: 'Sugerido', tone: ZimbaTone.accent),
                  ZimbaBadge(label: 'Revisado', tone: ZimbaTone.success),
                  ZimbaBadge(label: 'Conflito', tone: ZimbaTone.warning),
                  ZimbaBadge(label: 'Duplicado', tone: ZimbaTone.danger),
                  ZimbaBadge(label: 'Novo', tone: ZimbaTone.info),
                ],
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text('Ativo'),
                    backgroundColor: ZimbaColors.accentSoft,
                  ),
                  Chip(label: Text('Inativo')),
                  Chip(
                    label: Text('Filtro'),
                    backgroundColor: ZimbaColors.accentSoft,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ZimbaCard(
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alvo de toque 48 px',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Acessibilidade mínima',
                      style: TextStyle(
                        color: ZimbaColors.secondaryText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(value: touchTarget, onChanged: onTouchTargetChanged),
            ],
          ),
        ),
      ],
    );
  }
}
