// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One place where every Switch/Slider/Dropdown/Card/BottomNavigationBar
// in the app picks up the active theme's palette — so individual
// screens never need to restyle a default Material control by hand.
// buildDarkTheme() (Cosmic) and buildLightTheme() (Light) both funnel
// through buildAppTheme(), parameterized by an AppColorTokens instance,
// so the two themes share one architecture instead of being hand-kept
// in sync as separate copies. Cosmic's call site passes the exact same
// values it always has — nothing about its rendered output changes.

import 'package:flutter/material.dart';

import 'app_color_tokens.dart';
import 'app_typography.dart';

ThemeData buildAppTheme(AppColorTokens tokens) {
  // Light gets fully rounded, pill-shaped controls; Cosmic keeps its
  // existing 20px card radius / 10px segment radius untouched.
  final isLight = tokens.brightness == Brightness.light;
  final cardRadius = isLight ? 24.0 : 20.0;
  final pillRadius = isLight ? 999.0 : 10.0;

  return ThemeData(
    useMaterial3: true,
    brightness: tokens.brightness,
    fontFamily: AppTypography.bodyFamily,
    // Falls back to the bundled Noto Sans Tamil/Sinhala faces for any
    // glyph Inter can't render — the mechanism that makes Tamil/
    // Sinhala UI chrome display correctly without per-widget locale
    // checks. Arabic text always sets AppTypography.arabicFamily
    // explicitly, so this fallback never touches it.
    fontFamilyFallback: AppTypography.uiFontFallback,
    scaffoldBackgroundColor: tokens.paper,
    canvasColor: tokens.paper,
    cardColor: tokens.card,
    dividerColor: tokens.hairline,
    extensions: [tokens],
    // Material 3 tints elevated surfaces with colorScheme.surfaceTint
    // by default. Cards must render flat, exactly tokens.card — no tint.
    colorScheme: ColorScheme.fromSeed(
      seedColor: tokens.gold,
      brightness: tokens.brightness,
      surface: tokens.card,
    ).copyWith(surfaceTint: Colors.transparent),
    appBarTheme: AppBarTheme(
      backgroundColor: tokens.paper,
      foregroundColor: tokens.ink,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: tokens.card,
      elevation: isLight ? 2 : 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: (isLight ? Colors.black : tokens.ink).withValues(
        alpha: isLight ? 0.10 : 0.08,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: BorderSide(color: tokens.hairline),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? tokens.gold
            : tokens.sage,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? tokens.goldBorder
            : tokens.hairline,
      ),
      trackOutlineColor: WidgetStatePropertyAll(tokens.hairline),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: tokens.gold,
      inactiveTrackColor: tokens.hairline,
      thumbColor: tokens.gold,
      overlayColor: tokens.gold.withValues(alpha: 0.13),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: tokens.ink),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: tokens.sage),
      hintStyle: TextStyle(color: tokens.sage),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: tokens.hairline),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: tokens.gold),
      ),
    ),
    // Pill-shaped everywhere a button appears via the framework theme,
    // so ElevatedButton/OutlinedButton/TextButton/FilledButton pick up
    // Light's fully-rounded look without every call site overriding shape.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(pillRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(pillRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(pillRadius),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(pillRadius),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: tokens.paper,
      selectedItemColor: tokens.gold,
      unselectedItemColor: tokens.sage,
      type: BottomNavigationBarType.fixed,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: tokens.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: tokens.card,
      contentTextStyle: TextStyle(color: tokens.ink),
      actionTextColor: tokens.gold,
    ),
    listTileTheme: ListTileThemeData(
      textColor: tokens.ink,
      iconColor: tokens.sage,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: tokens.card),
      textStyle: TextStyle(color: tokens.ink),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: tokens.card,
      surfaceTintColor: Colors.transparent,
      textStyle: TextStyle(color: tokens.ink),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: AppTypography.displayFamily,
        color: tokens.ink,
      ),
      titleMedium: TextStyle(color: tokens.ink),
      bodyLarge: TextStyle(color: tokens.ink),
      bodyMedium: TextStyle(color: tokens.ink),
      bodySmall: TextStyle(color: tokens.sage),
      labelLarge: TextStyle(color: tokens.gold),
    ),
  );
}

/// Cosmic — the confirmed-working dark obsidian/gold/cyan theme.
/// Untouched: same tokens, same values, as before this file gained a
/// second theme.
ThemeData buildDarkTheme() => buildAppTheme(AppColorTokens.cosmic);

/// Light — clean white/off-white theme, same accent (gold), pill-shaped
/// controls, generous spacing handled at the widget level.
ThemeData buildLightTheme() => buildAppTheme(AppColorTokens.light);
