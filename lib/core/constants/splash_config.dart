// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Every tunable for the launch splash lives here. Nothing about the
// cosmic sequence's timing, palette, or particle behaviour should be
// hardcoded in the widgets/painters themselves — change values here.

import 'package:flutter/material.dart';

/// Tunables for `SplashScreen` and its cosmic sub-widgets.
abstract final class SplashConfig {
  /// Master switch. When false, [SplashScreen] shows a plain still
  /// centred greeting instead of the animated cosmic sequence.
  static const bool cosmicEnabled = true;

  /// Total duration of the cosmic sequence before `onFinished` fires.
  static const Duration totalDuration = Duration(milliseconds: 5200);

  // --- Background gradient (never pure black) ---
  static const Color emeraldCenter = Color(0xFF1B3D2B);
  static const Color emeraldMid = Color(0xFF0A1912);
  static const Color emeraldEdge = Color(0xFF050D09);

  // --- Gold centre glow, slowly breathing ---
  static const Color glowColor = Color(0xFFD4AF37);
  static const double glowBaseRadiusFraction = 0.22;
  static const double glowAmplitudeFraction = 0.06;
  static const double glowBreathPeriodSeconds = 3.6;
  static const double glowPeakOpacity = 0.32;

  // --- Whole-field slow rotation ---
  /// One full rotation every 48 seconds.
  static const double rotationRadiansPerSecond = 2 * 3.14159265358979 / 48.0;

  // --- Starfield ---
  static const int starCount = 140;
  static const int starFieldSeed = 20260803;

  /// Distance (fraction of the field's max radius) covered by the
  /// initial fast burst term.
  static const double starBurstDistanceFraction = 0.55;

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
  static const double starBaseAlpha = 0.55;
  static const double starTwinkleAmplitude = 0.45;
  static const double starTwinkleFreqMinHz = 0.6;
  static const double starTwinkleFreqMaxHz = 1.8;

  // --- Greeting: word-by-word reveal, hold, then scale-through-fade ---
  static const double wordStaggerSeconds = 0.35;
  static const double wordAppearDurationSeconds = 0.5;
  static const double holdDurationSeconds = 1.8;
  static const double exitDurationSeconds = 2.2;

  /// Starting scale for a word appearing "small/distant".
  static const double wordSmallScale = 0.15;

  /// Scale a word reaches as it passes the viewer during exit.
  static const double wordFarScale = 3.2;

  static const double textFontSize = 26;
  static const double textLetterSpacing = 1.4;

  // --- Plain (non-cosmic) fallback ---
  static const Duration plainHoldDuration = Duration(milliseconds: 2400);
  static const Duration plainFadeDuration = Duration(milliseconds: 600);
}
