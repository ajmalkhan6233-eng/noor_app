// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Three families, each with one job. Display (Cormorant Garamond) for
// prayer times, the Bismillah, and section headers — letterspaced,
// light, generous. Body (Inter) for everything else: labels,
// settings, controls. Arabic (Amiri) for Arabic text wherever it
// appears. Bundled as assets — never fetched at runtime.

import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const String displayFamily = 'Cormorant Garamond';
  static const String bodyFamily = 'Inter';
  static const String arabicFamily = 'Amiri';

  /// Additional UI-chrome typefaces for languages Inter has no glyphs
  /// for — registered as a theme-wide fallback so any UI text (button
  /// labels, titles) renders correctly when the app language is Tamil
  /// or Sinhala, without ever touching Arabic/Quran/Azkar styling
  /// (those always use [arabicFamily] explicitly).
  static const List<String> uiFontFallback = [
    'Noto Sans Tamil',
    'Noto Sans Sinhala',
  ];

  /// Explicit UI font family for a given language code — used where a
  /// widget always renders a specific language's text regardless of
  /// the active locale, e.g. each option's native name in the language
  /// picker. Returns `null` for English (falls back to [bodyFamily]).
  static String? uiFamilyForLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'ta':
        return 'Noto Sans Tamil';
      case 'si':
        return 'Noto Sans Sinhala';
      default:
        return null;
    }
  }

  /// The largest display moment — the next-prayer name.
  static const TextStyle heroDisplay = TextStyle(
    fontFamily: displayFamily,
    fontWeight: FontWeight.w300,
    fontSize: 44,
    letterSpacing: 1.2,
    color: AppColors.ink,
  );

  /// Small letterspaced caption headers above a section's content.
  static const TextStyle sectionHeader = TextStyle(
    fontFamily: displayFamily,
    fontWeight: FontWeight.w500,
    fontSize: 13,
    letterSpacing: 2.4,
    color: AppColors.sage,
  );

  /// Quiet caption text — e.g. the active method/madhab line.
  static const TextStyle caption = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    letterSpacing: 0.4,
    color: AppColors.sage,
  );

  /// Tabular-figure time display (prayer times list).
  static const TextStyle time = TextStyle(
    fontFamily: bodyFamily,
    fontFeatures: [FontFeature.tabularFigures()],
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle arabic = TextStyle(
    fontFamily: arabicFamily,
    color: AppColors.ink,
    height: 1.9,
  );

  /// A large tap-to-count number — the tasbih counter.
  static const TextStyle counter = TextStyle(
    fontFamily: bodyFamily,
    fontFeatures: [FontFeature.tabularFigures()],
    fontSize: 56,
    fontWeight: FontWeight.bold,
    color: AppColors.ink,
  );
}
