// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Inter is the single UI family for every screen. Arabic (Amiri) remains
// reserved for Arabic text. All fonts are bundled as assets — never
// fetched at runtime.
//
// The colour-bearing styles below take their colour as a parameter
// (usually `context.colors.ink` or `context.colors.sage`) instead of a
// hardcoded constant, so the same style definition renders correctly
// in both Cosmic and Light — callers pass whichever token applies,
// same as any other themed color in the app.
//
// ONE TYPE SCALE. Every text size in the app comes from this file; a
// test (test/core/type_scale_test.dart) fails if a numeric `fontSize`
// appears anywhere else in lib/. Sizes in logical pixels:
//   display 44 / title 28 / timeLarge 22 / timeSmall 16 / body 15 /
//   section 13 / caption 12 (+ counter 56 for the tasbih number, and
//   the Arabic reading sizes below).
// Screen titles on every screen use [title], at the same size in all
// four themes; only the typeface changes in Mushaf (see
// AppColorTokens.headingFontFamily).

import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String bodyFamily = 'Inter';
  static const String displayFamily = bodyFamily;
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

  // ---- the scale (logical pixels) ----
  static const double displaySize = 44;
  static const double titleSize = 28;
  static const double timeLargeSize = 22;
  static const double timeSmallSize = 16;
  static const double bodySize = 15;
  static const double sectionSize = 13;
  static const double captionSize = 12;
  static const double counterSize = 56;

  /// Arabic reading sizes (multiplied by the user's text-size setting).
  static const double quranSize = 22;
  static const double arabicLargeSize = 26;
  static const double arabicSmallSize = 16;

  /// Brand art (splash wordmark, calligraphy) is not UI text.
  static const double brandSize = 32;
  static const double brandLargeSize = 40;

  /// Line heights that go with the scale.
  static const double bodyHeight = 1.4;
  static const double titleHeight = 1.2;
  static const double quranHeight = 2.1;

  /// Largest display moment, e.g. the next-prayer name.
  static TextStyle display(Color color) => TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: displaySize,
        letterSpacing: 1.2,
        color: color,
      );

  /// Screen titles: the same style on every screen. [family] is only
  /// set by themes that give headings their own typeface (Mushaf).
  static TextStyle title(Color color, {String? family}) => TextStyle(
        fontFamily: family,
        fontWeight: FontWeight.w600,
        fontSize: titleSize,
        height: titleHeight,
        color: color,
      );

  /// Section headings: small, letterspaced captions above content.
  static TextStyle section(Color color, {String? family}) => TextStyle(
        fontFamily: family,
        fontWeight: FontWeight.w500,
        fontSize: sectionSize,
        letterSpacing: 2.4,
        color: color,
      );

  /// Ordinary reading text.
  static TextStyle body(Color color) => TextStyle(
        fontSize: bodySize,
        height: bodyHeight,
        color: color,
      );

  /// Body size, heavier: dialog and sheet headings.
  static TextStyle bodyStrong(Color color) => body(color).copyWith(fontWeight: FontWeight.w600);

  /// Quiet caption text.
  static TextStyle caption(Color color) => TextStyle(
        fontSize: captionSize,
        letterSpacing: 0.4,
        color: color,
      );

  /// Large tabular figures: countdowns and the main prayer time.
  static TextStyle timeLarge(Color color) => TextStyle(
        fontFeatures: const [FontFeature.tabularFigures()],
        fontSize: timeLargeSize,
        fontWeight: FontWeight.w600,
        color: color,
      );

  /// Tabular figures for rows of prayer times: same on Home and Prayer Times.
  static TextStyle timeSmall(Color color) => TextStyle(
        fontFeatures: const [FontFeature.tabularFigures()],
        fontSize: timeSmallSize,
        fontWeight: FontWeight.w600,
        color: color,
      );

  /// Arabic text. [size] is one of the Arabic sizes above (times the
  /// user's text-size setting, applied by the caller).
  static TextStyle arabic(Color color, {double size = quranSize, double height = 1.9}) => TextStyle(
        fontFamily: arabicFamily,
        fontSize: size,
        color: color,
        height: height,
      );

  /// A large tap-to-count number: the tasbih counter.
  static TextStyle counter(Color color) => TextStyle(
        fontFeatures: const [FontFeature.tabularFigures()],
        fontSize: counterSize,
        fontWeight: FontWeight.bold,
        color: color,
      );

  // ---- older names, kept so existing call sites read the same scale ----
  static TextStyle heroDisplay(Color color) => display(color);
  static TextStyle sectionHeader(Color color) => section(color);
  static TextStyle time(Color color) => timeSmall(color);
}
