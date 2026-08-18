import 'package:flutter/material.dart';

abstract final class ZimbaColors {
  static const background = Color(0xFFF7F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF1F3F5);
  static const foreground = Color(0xFF0F172A);
  static const secondaryText = Color(0xFF64748B);
  static const border = Color(0xFFE5E7EB);
  static const accent = Color(0xFF0EA5E9);
  static const accentSoft = Color(0xFFE0F2FE);
  static const success = Color(0xFF16A34A);
  static const successSoft = Color(0xFFEDF9EF);
  static const warning = Color(0xFFD97706);
  static const warningSoft = Color(0xFFFFF3DB);
  static const destructive = Color(0xFFDC2626);
  static const destructiveSoft = Color(0xFFFEE2E2);
  static const infoSoft = Color(0xFFF0F2FF);
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
          primary: ZimbaColors.foreground,
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
        fontSize: 30,
        height: 1.08,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.7,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.25,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(fontSize: 15, height: 1.35),
      bodyMedium: TextStyle(fontSize: 14, height: 1.35),
      bodySmall: TextStyle(fontSize: 12, height: 1.35),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
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
        titleSpacing: 20,
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
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ZimbaColors.foreground,
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          side: const BorderSide(color: ZimbaColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
        height: 72,
        backgroundColor: ZimbaColors.surface,
        indicatorColor: ZimbaColors.accentSoft,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
      dividerColor: ZimbaColors.border,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ZimbaColors.foreground,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
