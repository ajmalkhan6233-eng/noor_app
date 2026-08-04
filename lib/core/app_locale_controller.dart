// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Global signal for the app's active UI language. `SettingsRepository`
// is the source of truth persisted to disk, but `NoorApp` only reads
// it once on launch — this notifier lets a language change made in
// Settings reach the root `MaterialApp` immediately, with no restart.

import 'package:flutter/material.dart';

class AppLocaleController {
  AppLocaleController._();

  static final AppLocaleController instance = AppLocaleController._();

  /// `null` means "not yet loaded" — `NoorApp` fills this in from the
  /// persisted setting once on startup, then Settings updates it live.
  final ValueNotifier<Locale?> locale = ValueNotifier<Locale?>(null);
}
