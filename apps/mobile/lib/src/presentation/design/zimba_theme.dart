import 'package:flutter/material.dart';

abstract final class ZimbaColors {
  static const background = Color(0xFFF7F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF1F3F6);
  static const muted = Color(0xFFEEF1F4);
  static const foreground = Color(0xFF0F172A);
  static const primary = Color(0xFF111827);
  static const secondary = Color(0xFF6B7280);
  static const secondaryText = Color(0xFF475569);
  static const border = Color(0xFFE2E8F0);
  static const borderStrong = Color(0xFFCBD5E1);
  static const accent = Color(0xFF0EA5E9);
  static const accentSoft = Color(0xFFE0F2FE);
  static const success = Color(0xFF16A34A);
  // Browser conversion of Lovable's `oklch(0.95 0.05 145)` token.
  static const successSoft = Color(0xFFDBF8DA);
  static const warning = Color(0xFFD97706);
  static const warningSoft = Color(0xFFFEF3C7);
  static const destructive = Color(0xFFDC2626);
  static const destructiveSoft = Color(0xFFFEE2E2);
  static const infoSoft = Color(0xFFEDE9FE);

  static const logoGradientStart = Color(0xFF12B2F4);
  static const logoGradientEnd = Color(0xFF0072D5);
}

abstract final class ZimbaRadii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 28.0;
}

abstract final class ZimbaShadows {
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x0A0F172A), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x080F172A), blurRadius: 3, offset: Offset(0, 1)),
  ];

  static const elevated = <BoxShadow>[
    BoxShadow(color: Color(0x1F0F172A), blurRadius: 24, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0A0F172A), blurRadius: 6, offset: Offset(0, 2)),
  ];
}

abstract final class ZimbaTheme {
  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: ZimbaColors.accent,
          brightness: Brightness.light,
          surface: ZimbaColors.surface,
          error: ZimbaColors.destructive,
        ).copyWith(
          primary: ZimbaColors.primary,
          onPrimary: Colors.white,
          secondary: ZimbaColors.accent,
          onSecondary: Colors.white,
          surface: ZimbaColors.surface,
          onSurface: ZimbaColors.foreground,
          outline: ZimbaColors.border,
          surfaceContainerHighest: ZimbaColors.surfaceMuted,
        );

    const textTheme = TextTheme(
      headlineMedium: TextStyle(
        fontSize: 34,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.7,
      ),
      headlineSmall: TextStyle(
        fontSize: 26,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.25,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5),
      bodySmall: TextStyle(fontSize: 12, height: 1.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ZimbaColors.background,
      fontFamily: 'Inter',
      textTheme: textTheme.apply(
        bodyColor: ZimbaColors.foreground,
        displayColor: ZimbaColors.foreground,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: ZimbaColors.background,
        foregroundColor: ZimbaColors.foreground,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
        toolbarHeight: 72,
        titleTextStyle: TextStyle(
          color: ZimbaColors.foreground,
          fontFamily: 'Inter',
          fontSize: 19,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: ZimbaColors.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ZimbaColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ZimbaColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ZimbaColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ZimbaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ZimbaColors.accent, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ZimbaColors.foreground,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ZimbaRadii.lg),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ZimbaColors.foreground,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          side: const BorderSide(color: ZimbaColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ZimbaColors.surfaceMuted,
        selectedColor: ZimbaColors.accentSoft,
        secondarySelectedColor: ZimbaColors.accentSoft,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ZimbaColors.foreground,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: ZimbaColors.accent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      ),
      listTileTheme: const ListTileThemeData(
        dense: false,
        minVerticalPadding: 8,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        iconColor: ZimbaColors.secondaryText,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(ZimbaColors.surface),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? ZimbaColors.accent
              : ZimbaColors.border,
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 66,
        backgroundColor: ZimbaColors.surface,
        indicatorColor: ZimbaColors.accentSoft,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ZimbaColors.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: ZimbaColors.surface,
        modalBarrierColor: ZimbaColors.foreground.withValues(alpha: .32),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ZimbaRadii.xl),
          ),
        ),
        dragHandleColor: ZimbaColors.borderStrong,
        dragHandleSize: const Size(36, 4),
        showDragHandle: true,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(color: ZimbaColors.border),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ZimbaRadii.md),
            ),
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? ZimbaColors.accent
                : ZimbaColors.secondaryText,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? ZimbaColors.accentSoft
                : ZimbaColors.surface,
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      dividerColor: ZimbaColors.border,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ZimbaColors.foreground,
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: ZimbaColors.accentSoft,
        insetPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ZimbaRadii.md),
        ),
      ),
    );
  }
}

class ZimbaSectionTitle extends StatelessWidget {
  const ZimbaSectionTitle(this.label, {super.key, this.trailing});

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: ZimbaColors.secondaryText,
                letterSpacing: 0.7,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
