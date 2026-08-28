// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Three families, each with one job. Display (Cormorant Garamond) for
// prayer times, the Bismillah, and section headers — letterspaced,
// light, generous. Body (Inter) for everything else: labels,
// settings, controls. Arabic (Amiri) for Arabic text wherever it
// appears. Bundled as assets — never fetched at runtime.
//
// The colour-bearing styles below take their colour as a parameter
// (usually `context.colors.ink` or `context.colors.sage`) instead of a
// hardcoded constant, so the same style definition renders correctly
// in both Cosmic and Light — callers pass whichever token applies,
// same as any other themed color in the app.

import 'package:flutter/material.dart';

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
  static TextStyle heroDisplay(Color color) => TextStyle(
        fontFamily: displayFamily,
        fontWeight: FontWeight.w300,
        fontSize: 44,
        letterSpacing: 1.2,
        color: color,
      );

  /// Small letterspaced caption headers above a section's content.
  static TextStyle sectionHeader(Color color) => TextStyle(
        fontFamily: displayFamily,
        fontWeight: FontWeight.w500,
        fontSize: 13,
        letterSpacing: 2.4,
        color: color,
      );

  /// Quiet caption text — e.g. the active method/madhab line.
  static TextStyle caption(Color color) => TextStyle(
        fontFamily: bodyFamily,
        fontSize: 12,
        letterSpacing: 0.4,
        color: color,
      );

  /// Tabular-figure time display (prayer times list).
  static TextStyle time(Color color) => TextStyle(
        fontFamily: bodyFamily,
        fontFeatures: const [FontFeature.tabularFigures()],
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle arabic(Color color) => TextStyle(
        fontFamily: arabicFamily,
        color: color,
        height: 1.9,
      );

  /// A large tap-to-count number — the tasbih counter.
  static TextStyle counter(Color color) => TextStyle(
        fontFamily: bodyFamily,
        fontFeatures: const [FontFeature.tabularFigures()],
        fontSize: 56,
        fontWeight: FontWeight.bold,
        color: color,
      );
}
