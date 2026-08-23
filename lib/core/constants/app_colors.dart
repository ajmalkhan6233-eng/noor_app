// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Centralized design tokens. Never hardcode hex colors in widgets —
// import and use these instead, so the palette stays consistent and
// easy to re-theme.
//
// Design anchor (locked): near-black background/cards, gold as the
// dominant accent, cyan used sparingly for specific accents/borders.
// `ink`/`sage` were derived for contrast against this background —
// not part of the original four locked values, but the app has no
// readable text without them.

import 'package:flutter/material.dart';

/// Static color palette for `noor`.
abstract final class AppColors {
  /// App background — near-black.
  static const Color paper = Color(0xFF05070B);

  /// Cards — raised off the background with a hairline + soft shadow,
  /// never a filled color block.
  static const Color card = Color(0xFF0D1117);

  /// Primary text. Derived for contrast — see file header.
  static const Color ink = Color(0xFFEDEFF2);

  /// Secondary text — captions, section labels. Same derivation note
  /// as [ink].
  static const Color sage = Color(0xFF8A93A3);

  /// 1px borders and dividers on ordinary cards — cyan at 20% opacity.
  static const Color hairline = Color(0x3300F2FE);

  /// 1px border for featured/dua cards — gold at 20% opacity, per the
  /// locked spec's "gold border on featured/dua cards" rule.
  static const Color goldBorder = Color(0x33FFB703);

  /// Legacy accent — fully migrated to gold/cyan everywhere in v1 as
  /// of the final pre-release palette pass. The only remaining
  /// reference is inside the cut-from-v1 Hajj/Umrah guide feature
  /// (unreachable from the UI, see CLAUDE.md's Deferred section), kept
  /// only so that dead-but-present code still compiles. Do not use
  /// this for any new or active screen — use [gold].
  static const Color emerald = Color(0xFF14603C);

  /// Dimmed/inactive variant of [emerald], same retirement note.
  static const Color emeraldSoft = Color(0xFFAFC6BA);

  /// Primary accent — dominant, used most: active nav states, gold
  /// gradients, the Allah calligraphy, featured-card borders/glows.
  static const Color gold = Color(0xFFFFB703);

  /// Secondary accent — sparing, specific spots only (e.g. the
  /// next-prayer countdown capsule's border).
  static const Color accentSecondary = Color(0xFF00F2FE);
}
