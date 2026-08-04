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

  /// The largest display moment — the next-prayer name.
  static const TextStyle heroDisplay = TextStyle(
    fontFamily: displayFamily,
    fontWeight: FontWeight.w300,
    fontSize: 44,
    letterSpacing: 1.2,
    color: AppColors.parchment,
  );

  /// The Bismillah / splash greeting.
  static const TextStyle greeting = TextStyle(
    fontFamily: displayFamily,
    fontWeight: FontWeight.w300,
    fontSize: 26,
    letterSpacing: 3.2,
    color: AppColors.gold,
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
    color: AppColors.parchment,
  );

  static const TextStyle arabic = TextStyle(
    fontFamily: arabicFamily,
    color: AppColors.parchment,
    height: 1.9,
  );

  /// A large tap-to-count number — the tasbih counter.
  static const TextStyle counter = TextStyle(
    fontFamily: bodyFamily,
    fontFeatures: [FontFeature.tabularFigures()],
    fontSize: 56,
    fontWeight: FontWeight.bold,
    color: AppColors.parchment,
  );
}
