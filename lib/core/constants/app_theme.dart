// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One place where every Switch/Slider/Dropdown/Card/BottomNavigationBar
// in the app picks up the astrolabe palette — so individual screens
// never need to restyle a default Material control by hand.

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppTypography.bodyFamily,
    scaffoldBackgroundColor: AppColors.ink,
    canvasColor: AppColors.ink,
    cardColor: AppColors.card,
    dividerColor: AppColors.hairline,
    // Material 3 tints elevated surfaces with colorScheme.surfaceTint by
    // default, which turns our near-black cards a bright, unintended
    // green. Cards must render exactly AppColors.card — flat, no tint.
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.dark,
      surface: AppColors.card,
    ).copyWith(surfaceTint: Colors.transparent),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.ink,
      foregroundColor: AppColors.parchment,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.hairline),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.gold
            : AppColors.sage,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.goldSoft
            : AppColors.hairline,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(AppColors.hairline),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.gold,
      inactiveTrackColor: AppColors.hairline,
      thumbColor: AppColors.gold,
      overlayColor: Color(0x22C9A227),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(color: AppColors.parchment),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.sage),
      hintStyle: TextStyle(color: AppColors.sage),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.hairline),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.gold),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.ink,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.sage,
      type: BottomNavigationBarType.fixed,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.card,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.card,
      contentTextStyle: TextStyle(color: AppColors.parchment),
      actionTextColor: AppColors.gold,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: AppColors.parchment,
      iconColor: AppColors.sage,
    ),
    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(color: AppColors.card),
      textStyle: TextStyle(color: AppColors.parchment),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      textStyle: TextStyle(color: AppColors.parchment),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: AppTypography.displayFamily,
        color: AppColors.parchment,
      ),
      titleMedium: TextStyle(color: AppColors.parchment),
      bodyLarge: TextStyle(color: AppColors.parchment),
      bodyMedium: TextStyle(color: AppColors.parchment),
      bodySmall: TextStyle(color: AppColors.sage),
      labelLarge: TextStyle(color: AppColors.gold),
    ),
  );
}

ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTypography.bodyFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.light,
    ),
  );
}
