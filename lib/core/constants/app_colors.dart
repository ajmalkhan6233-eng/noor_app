// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Centralized design tokens. Never hardcode hex colors in widgets —
// import and use these instead, so the palette stays consistent and
// easy to re-theme.
//
// Design anchor: fine paper and ink, not a dark dashboard. Warm
// cream, dark text, colour used sparingly and only where it carries
// meaning. Calm, spacious, premium.

import 'package:flutter/material.dart';

/// Static color palette for `noor`.
abstract final class AppColors {
  /// App background — warm cream paper.
  static const Color paper = Color(0xFFF2EFE7);

  /// Cards — white, raised off the paper with a hairline + soft
  /// shadow, never a filled color block.
  static const Color card = Color(0xFFFFFFFF);

  /// Primary text.
  static const Color ink = Color(0xFF16211C);

  /// Secondary text — captions, section labels.
  static const Color sage = Color(0xFF6E7B72);

  /// 1px borders and dividers.
  static const Color hairline = Color(0xFFE3DFD4);

  /// Primary accent — active states, prayer names, progress. The only
  /// colour used for interaction; punctuation, not paint.
  static const Color emerald = Color(0xFF14603C);

  /// Dimmed/inactive accent (unselected track, soft marks).
  static const Color emeraldSoft = Color(0xFFAFC6BA);

  /// Reserved exclusively for the الله calligraphy — never used for
  /// buttons, chips, links, or any other UI element.
  static const Color gold = Color(0xFFB8912F);
}
