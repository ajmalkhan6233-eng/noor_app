// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Centralized design tokens. Never hardcode hex colors in widgets —
// import and use these instead, so the palette stays consistent and
// easy to re-theme.

import 'package:flutter/material.dart';

/// Static color palette for `noor`.
///
/// Deep emerald + metallic gold, evoking traditional Islamic manuscript
/// illumination while staying legible on low-end/OLED screens.
abstract final class AppColors {
  /// Primary app background — Deep Emerald.
  static const Color background = Color(0xFF0A1912);

  /// Card / surface background — Dark Card.
  static const Color surface = Color(0xFF132A20);

  /// Primary accent — Metallic Gold. Used for active states, counters,
  /// highlighted Arabic text, and progress indicators.
  static const Color accent = Color(0xFFD4AF37);

  /// Primary text on dark backgrounds.
  static const Color textPrimary = Color(0xFFF5F0E6);

  /// Secondary / muted text on dark backgrounds.
  static const Color textSecondary = Color(0xFFB8C4BD);

  /// Divider / hairline color, low-contrast on emerald surfaces.
  static const Color divider = Color(0xFF23392E);

  /// Success / milestone-reached color (used sparingly, e.g. tasbih
  /// milestone pulses at 33/66/100).
  static const Color milestone = Color(0xFFE8C766);
}
