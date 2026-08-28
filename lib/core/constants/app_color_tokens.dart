// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The real theme-switching mechanism behind Settings' Dark/Light/System
// toggle. One `AppColorTokens` shape, two locked instances — `cosmic`
// (today's obsidian/gold/cyan palette, values copied verbatim from the
// old static AppColors so Cosmic is pixel-identical to before) and
// `light` (the new white/gold theme). Both are registered as a
// ThemeExtension on their respective ThemeData in app_theme.dart, so
// `context.colors` resolves to whichever one MaterialApp is currently
// showing — a real Theme.of(context) dependency, so every widget that
// reads it rebuilds automatically when the toggle flips, including
// screens already mounted in an off-screen tab.

import 'package:flutter/material.dart';

@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.paper,
    required this.card,
    required this.ink,
    required this.sage,
    required this.hairline,
    required this.goldBorder,
    required this.gold,
    required this.accentSecondary,
    required this.brightness,
  });

  /// App background.
  final Color paper;

  /// Card surface.
  final Color card;

  /// Primary text.
  final Color ink;

  /// Secondary text — captions, section labels.
  final Color sage;

  /// 1px borders/dividers on ordinary cards.
  final Color hairline;

  /// 1px border for featured/dua cards.
  final Color goldBorder;

  /// Primary accent — the one constant across both themes.
  final Color gold;

  /// Secondary accent, used sparingly.
  final Color accentSecondary;

  /// Drives which particle/glass treatment CosmicBackground/GlassCard use.
  final Brightness brightness;

  /// Cosmic — locked dark obsidian/gold/cyan palette. Values copied
  /// verbatim from the retired static `AppColors` constants; never
  /// change these without re-checking every locked spec they came from.
  static const cosmic = AppColorTokens(
    paper: Color(0xFF05070B),
    card: Color(0xFF0D1117),
    ink: Color(0xFFEDEFF2),
    // Bumped from 0x8A93A3 (direct feedback: too low-contrast against
    // the near-black background) — lighter and slightly cooler so it
    // still reads as calm secondary text, not full-white emphasis.
    sage: Color(0xFFAAB3C2),
    hairline: Color(0x3300F2FE),
    goldBorder: Color(0x33FFB703),
    gold: Color(0xFFFFB703),
    accentSecondary: Color(0xFF00F2FE),
    brightness: Brightness.dark,
  );

  /// Light — soft white/off-white surfaces, one accent (the same gold),
  /// no separate cyan (kept only as a very light neutral hairline tint
  /// so shared code paths that reference [accentSecondary] still render
  /// sensibly instead of clashing).
  static const light = AppColorTokens(
    paper: Color(0xFFF7F5F1),
    card: Color(0xFFFFFFFF),
    ink: Color(0xFF1B1B1F),
    // Bumped from 0x6B6F76 (direct feedback, 2026-08-28, after
    // confirming Light looked good overall: a subtle further contrast
    // increase for readability) — darker, still a neutral gray, not a
    // big jump.
    sage: Color(0xFF54585F),
    hairline: Color(0x1A1B1B1F),
    goldBorder: Color(0x40FFB703),
    gold: Color(0xFFFFB703),
    accentSecondary: Color(0xFFCB8F00),
    brightness: Brightness.light,
  );

  @override
  AppColorTokens copyWith({
    Color? paper,
    Color? card,
    Color? ink,
    Color? sage,
    Color? hairline,
    Color? goldBorder,
    Color? gold,
    Color? accentSecondary,
    Brightness? brightness,
  }) {
    return AppColorTokens(
      paper: paper ?? this.paper,
      card: card ?? this.card,
      ink: ink ?? this.ink,
      sage: sage ?? this.sage,
      hairline: hairline ?? this.hairline,
      goldBorder: goldBorder ?? this.goldBorder,
      gold: gold ?? this.gold,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      brightness: brightness ?? this.brightness,
    );
  }

  // Dark and Light never cross-fade — MaterialApp swaps ThemeData
  // wholesale on toggle, so lerp only ever runs at t=0 or t=1 in
  // practice. Snapping (no interpolation) avoids muddy in-between
  // colors on the one frame Flutter might call this.
  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) return this;
    return t < 0.5 ? this : other;
  }
}

/// `context.colors` — the one place every widget should read the active
/// theme's palette from, instead of a hardcoded constant.
extension AppColorTokensContext on BuildContext {
  AppColorTokens get colors =>
      Theme.of(this).extension<AppColorTokens>() ?? AppColorTokens.cosmic;
}
