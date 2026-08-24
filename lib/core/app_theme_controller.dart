// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Global signal for the app's active theme brightness, mirroring
// AppLocaleController. `SettingsRepository` is the source of truth
// persisted to disk, but `NoorApp` only read it once on launch — a
// theme change made in Settings' DisplaySection updated the
// persisted value and that screen's own BlocBuilder, but never
// reached the root MaterialApp, so the Dark/Light toggle visibly did
// nothing. This notifier fixes that: NoorApp listens to it live.

import 'package:flutter/material.dart';

class AppThemeController {
  AppThemeController._();

  static final AppThemeController instance = AppThemeController._();

  /// `null` means "not yet loaded" — `NoorApp` fills this in from the
  /// persisted setting once on startup, then Settings updates it live.
  final ValueNotifier<ThemeMode?> themeMode = ValueNotifier<ThemeMode?>(null);
}
