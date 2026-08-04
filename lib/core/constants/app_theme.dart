// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One place where every Switch/Slider/Dropdown/Card/BottomNavigationBar
// in the app picks up the paper-and-ink palette — so individual
// screens never need to restyle a default Material control by hand.
// The app is light-only by design; buildDarkTheme/buildLightTheme
// both return the same theme so the existing theme-mode setting still
// resolves to something, without a second, contradictory palette.

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTypography.bodyFamily,
    // Falls back to the bundled Noto Sans Tamil/Sinhala faces for any
    // glyph Inter can't render — the mechanism that makes Tamil/
    // Sinhala UI chrome display correctly without per-widget locale
    // checks. Arabic text always sets AppTypography.arabicFamily
    // explicitly, so this fallback never touches it.
    fontFamilyFallback: AppTypography.uiFontFallback,
    scaffoldBackgroundColor: AppColors.paper,
    canvasColor: AppColors.paper,
    cardColor: AppColors.card,
    dividerColor: AppColors.hairline,
    // Material 3 tints elevated surfaces with colorScheme.surfaceTint
    // by default. Cards must render flat white — no tint.
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.emerald,
      brightness: Brightness.light,
      surface: AppColors.card,
    ).copyWith(surfaceTint: Colors.transparent),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.paper,
      foregroundColor: AppColors.ink,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.ink.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.hairline),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.emerald
            : AppColors.sage,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.emeraldSoft
            : AppColors.hairline,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(AppColors.hairline),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.emerald,
      inactiveTrackColor: AppColors.hairline,
      thumbColor: AppColors.emerald,
      overlayColor: Color(0x2214603C),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(color: AppColors.ink),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.sage),
      hintStyle: TextStyle(color: AppColors.sage),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.hairline),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.emerald),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.paper,
      selectedItemColor: AppColors.emerald,
      unselectedItemColor: AppColors.sage,
      type: BottomNavigationBarType.fixed,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.card,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: TextStyle(color: AppColors.paper),
      actionTextColor: AppColors.emerald,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: AppColors.ink,
      iconColor: AppColors.sage,
    ),
    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(color: AppColors.card),
      textStyle: TextStyle(color: AppColors.ink),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      textStyle: TextStyle(color: AppColors.ink),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: AppTypography.displayFamily,
        color: AppColors.ink,
      ),
      titleMedium: TextStyle(color: AppColors.ink),
      bodyLarge: TextStyle(color: AppColors.ink),
      bodyMedium: TextStyle(color: AppColors.ink),
      bodySmall: TextStyle(color: AppColors.sage),
      labelLarge: TextStyle(color: AppColors.emerald),
    ),
  );
}

/// The app is light-only; both resolve to the same theme so the
/// existing theme-mode preference has no visible effect rather than
/// contradicting the brand.
ThemeData buildDarkTheme() => buildAppTheme();

ThemeData buildLightTheme() => buildAppTheme();
