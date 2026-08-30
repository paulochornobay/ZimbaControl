import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'zimba_theme.dart';

enum ZimbaLogoVariant { mark, wordmark, lockup }

enum ZimbaLogoSize { sm, md, lg, xl }

enum ZimbaLogoTone { color, monoLight, monoDark }

/// Marca vetorial do ZimbaControl traduzida da referência congelada do Lovable.
/// O símbolo é desenhado nativamente e não depende de imagem rasterizada.
class ZimbaLogo extends StatelessWidget {
  const ZimbaLogo({
    super.key,
    this.variant = ZimbaLogoVariant.lockup,
    this.size = ZimbaLogoSize.md,
    this.tone = ZimbaLogoTone.color,
  });

  final ZimbaLogoVariant variant;
  final ZimbaLogoSize size;
  final ZimbaLogoTone tone;

  double get _markSize => switch (size) {
    ZimbaLogoSize.sm => 32,
    ZimbaLogoSize.md => 40,
    ZimbaLogoSize.lg => 56,
    ZimbaLogoSize.xl => 80,
  };

  double get _fontSize => switch (size) {
    ZimbaLogoSize.sm => 16,
    ZimbaLogoSize.md => 19,
    ZimbaLogoSize.lg => 26,
    ZimbaLogoSize.xl => 34,
  };

  double get _gap => switch (size) {
    ZimbaLogoSize.sm => 8,
    ZimbaLogoSize.md => 10,
    ZimbaLogoSize.lg => 12,
    ZimbaLogoSize.xl => 16,
  };

  @override
  Widget build(BuildContext context) {
    final mark = _ZimbaMark(size: _markSize, tone: tone);
    final wordmark = RichText(
      textScaler: TextScaler.noScaling,
      text: TextSpan(
        style: TextStyle(
          color: tone == ZimbaLogoTone.monoLight
              ? ZimbaColors.surface
              : ZimbaColors.foreground,
          fontFamily: 'Inter',
          fontSize: _fontSize,
          height: 1,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
        ),
        children: const [
          TextSpan(text: 'Zimba'),
          TextSpan(
            text: 'Control',
            style: TextStyle(color: ZimbaColors.accent),
          ),
        ],
      ),
    );

    return Semantics(
      label: 'ZimbaControl',
      image: true,
      excludeSemantics: true,
      child: switch (variant) {
        ZimbaLogoVariant.mark => mark,
        ZimbaLogoVariant.wordmark => FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: wordmark,
        ),
        ZimbaLogoVariant.lockup => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            mark,
            SizedBox(width: _gap),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: wordmark,
              ),
            ),
          ],
        ),
      },
    );
  }
}

class _ZimbaMark extends StatelessWidget {
  const _ZimbaMark({required this.size, required this.tone});

  final double size;
  final ZimbaLogoTone tone;

  @override
  Widget build(BuildContext context) {
    final decoration = switch (tone) {
      ZimbaLogoTone.color => BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ZimbaColors.logoGradientStart, ZimbaColors.logoGradientEnd],
        ),
        borderRadius: BorderRadius.circular(size * .28),
      ),
      ZimbaLogoTone.monoLight => BoxDecoration(
        color: ZimbaColors.foreground,
        borderRadius: BorderRadius.circular(size * .28),
      ),
      ZimbaLogoTone.monoDark => BoxDecoration(
        color: ZimbaColors.surface,
        border: Border.all(color: ZimbaColors.border),
        borderRadius: BorderRadius.circular(size * .28),
      ),
    };

    final barColor = switch (tone) {
      ZimbaLogoTone.monoDark => ZimbaColors.accent,
      _ => ZimbaColors.surface,
    };

    return DecoratedBox(
      decoration: decoration,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _ZPainter(color: barColor)),
      ),
    );
  }
}

class _ZPainter extends CustomPainter {
  const _ZPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width * .56 / 48;
    final offset = size.width * .22;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    RRect bar(double x, double y) => RRect.fromRectAndRadius(
      Rect.fromLTWH(
        offset + x * scale,
        offset + y * scale,
        36 * scale,
        6 * scale,
      ),
      Radius.circular(3 * scale),
    );

    canvas.drawRRect(bar(6, 9), paint);
    canvas.save();
    final center = Offset(offset + 24 * scale, offset + 24 * scale);
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-34 * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawRRect(bar(6, 21), paint);
    canvas.restore();
    canvas.drawRRect(bar(6, 33), paint);
  }

  @override
  bool shouldRepaint(covariant _ZPainter oldDelegate) =>
      oldDelegate.color != color;
}
