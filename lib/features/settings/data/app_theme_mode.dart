// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

/// User-selectable theme preference. The palette itself is always
/// the emerald/gold seed (`AppColors.gold`) — this only chooses
/// which brightness Flutter derives from it, or defers to the OS.
/// `mushaf` must stay last: the option is persisted by name, and the
/// order only drives the Settings picker.
enum AppThemeModeOption { dark, light, system, mushaf }

extension AppThemeModeOptionLabel on AppThemeModeOption {
  String get label {
    switch (this) {
      case AppThemeModeOption.dark:
        return 'Nebula';
      case AppThemeModeOption.light:
        return 'Dawn';
      case AppThemeModeOption.system:
        return 'Follow system';
      case AppThemeModeOption.mushaf:
        return 'Mushaf';
    }
  }

  ThemeMode get flutterThemeMode {
    switch (this) {
      case AppThemeModeOption.dark:
        return ThemeMode.dark;
      case AppThemeModeOption.light:
        return ThemeMode.light;
      case AppThemeModeOption.system:
        return ThemeMode.system;
      case AppThemeModeOption.mushaf:
        // Rendered through MaterialApp.theme (see AppThemeController.mushaf).
        return ThemeMode.light;
    }
  }
}
