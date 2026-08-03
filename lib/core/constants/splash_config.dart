// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Every tunable for the launch splash lives here. Nothing about the
// cosmic sequence's timing, palette, or particle behaviour should be
// hardcoded in the widgets/painters themselves — change values here.

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tunables for `SplashScreen` and its cosmic sub-widgets.
abstract final class SplashConfig {
  /// Master switch. When false, [SplashScreen] shows a plain still
  /// centred greeting instead of the animated cosmic sequence.
  static const bool cosmicEnabled = true;

  /// Total duration of the cosmic sequence before `onFinished` fires.
  static const Duration totalDuration = Duration(milliseconds: 2800);

  // --- Background gradient (never pure black, but reads almost so —
  // a green cast, not a lit scene) ---
  static const Color emeraldCenter = AppColors.card;
  static const Color emeraldMid = AppColors.emerald;
  static const Color emeraldEdge = AppColors.ink;

  // --- Gold centre glow ("nur"), slowly breathing ---
  static const Color glowColor = AppColors.gold;

  /// Base glow radius as a fraction of the field's max radius. Kept
  /// modest so the gold glow reads as a soft accent, never a wash
  /// over the whole screen.
  static const double nurRadius = 0.22;
  static const double glowAmplitudeFraction = 0.04;
  static const double glowBreathPeriodSeconds = 3.6;

  /// Peak glow opacity — deliberately low; a suggestion of light, not
  /// a floodlight. This glow sits behind a starfield and gold text
  /// and must never compete with either.
  static const double glowPeakOpacity = 0.06;

  // --- Whole-field slow rotation ---
  /// One full rotation every 48 seconds.
  static const double rotationRadiansPerSecond = 2 * 3.14159265358979 / 48.0;

  // --- Starfield ---
  static const int starCount = 140;
  static const int starFieldSeed = 20260803;

  /// Distance (fraction of the field's max radius) covered by the
  /// initial fast burst term — calmer than a full sweep to the edge.
  static const double starBurstDistanceFraction = 0.4;

  /// Decay constant (seconds) of the burst term — smaller means the
  /// burst dies out faster, handing off to the steady drift term.
  static const double starBurstTau = 0.9;

  /// Steady outward drift speed once the burst has eased off, as a
  /// fraction of the field's max radius per second.
  static const double starDriftFractionPerSecond = 0.05;

  /// How far back in time (seconds) each streak's trailing end is
  /// sampled from, relative to the star's current position.
  static const double starStreakTrailSeconds = 0.045;

  static const double starStrokeWidth = 1.4;
  static const double starBaseAlpha = 0.4;
  static const double starTwinkleAmplitude = 0.3;
  static const double starTwinkleFreqMinHz = 0.6;
  static const double starTwinkleFreqMaxHz = 1.8;

  // --- Greeting: gentle fade in, hold, gentle fade out. No scaling
  // past the viewer — a calm greeting, not a flourish. ---
  static const double wordStaggerSeconds = 0.22;
  static const double wordAppearDurationSeconds = 0.35;
  static const double holdDurationSeconds = 1.31;
  static const double exitDurationSeconds = 0.7;

  /// Starting scale for a word gently arriving.
  static const double wordSmallScale = 0.92;

  /// Scale held through hold and exit — `1.0` means no scale change
  /// at all once a word has arrived; the exit is opacity-only.
  static const double textEndScale = 1.0;

  static const double textFontSize = 26;
  static const double textLetterSpacing = 3.2;

  /// Height reserved per word line — generous enough that even the
  /// gentle arrival scale never crowds neighbouring lines.
  static const double wordLineHeight = 64;

  /// A soft lift for the gold text, not a glow.
  static const double textShadowBlurRadius = 2;

  // --- Plain (non-cosmic) fallback ---
  static const Duration plainHoldDuration = Duration(milliseconds: 2400);
  static const Duration plainFadeDuration = Duration(milliseconds: 600);
}
