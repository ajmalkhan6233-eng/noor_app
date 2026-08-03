// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

/// User-selectable theme preference. The palette itself is always
/// the emerald/gold seed (`AppColors.accent`) — this only chooses
/// which brightness Flutter derives from it, or defers to the OS.
enum AppThemeModeOption { dark, light, system }

extension AppThemeModeOptionLabel on AppThemeModeOption {
  String get label {
    switch (this) {
      case AppThemeModeOption.dark:
        return 'Dark';
      case AppThemeModeOption.light:
        return 'Light';
      case AppThemeModeOption.system:
        return 'Follow system';
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
    }
  }
}
