// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Centralized design tokens. Never hardcode hex colors in widgets —
// import and use these instead, so the palette stays consistent and
// easy to re-theme.
//
// Design anchor: the astrolabe — manuscript illumination, not neon.
// Backgrounds read almost black with a green cast; gold is
// punctuation, not paint.

import 'package:flutter/material.dart';

/// Static color palette for `noor`.
abstract final class AppColors {
  /// Deepest ground — app background.
  static const Color ink = Color(0xFF060D0A);

  /// Surface, one step up from [ink].
  static const Color emerald = Color(0xFF0A1912);

  /// Raised cards.
  static const Color card = Color(0xFF12241B);

  /// 1px dividers and card borders.
  static const Color hairline = Color(0xFF1E3327);

  /// Accent — punctuation, used sparingly (active states, the current
  /// prayer marker, the astrolabe's position needle).
  static const Color gold = Color(0xFFC9A227);

  /// Inactive/dimmed gold.
  static const Color goldSoft = Color(0xFF8C7420);

  /// Primary text.
  static const Color parchment = Color(0xFFF2EDE1);

  /// Secondary text — captions, section labels.
  static const Color sage = Color(0xFF94A79B);
}
