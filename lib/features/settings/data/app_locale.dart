// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The three UI languages noor ships with. Distinct from Arabic/Quran
// text, which always renders in its own script regardless of this
// setting — this only controls interface chrome (labels, buttons,
// titles).

import 'package:flutter/material.dart';

enum AppLocaleOption { english, tamil, sinhala }

extension AppLocaleOptionData on AppLocaleOption {
  /// BCP-47 language code persisted in the database.
  String get languageCode {
    switch (this) {
      case AppLocaleOption.english:
        return 'en';
      case AppLocaleOption.tamil:
        return 'ta';
      case AppLocaleOption.sinhala:
        return 'si';
    }
  }

  Locale get locale => Locale(languageCode);

  /// Each language's own name in its own script, for the picker.
  String get nativeName {
    switch (this) {
      case AppLocaleOption.english:
        return 'English';
      case AppLocaleOption.tamil:
        return 'தமிழ்';
      case AppLocaleOption.sinhala:
        return 'සිංහල';
    }
  }

  static AppLocaleOption fromLanguageCode(String code) {
    return AppLocaleOption.values.firstWhere(
      (option) => option.languageCode == code,
      orElse: () => AppLocaleOption.english,
    );
  }
}
