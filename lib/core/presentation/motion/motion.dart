// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shared motion constants so every screen moves on the same clock:
// calm, deliberate easing, never bouncy. Every animated widget in the
// app should route its duration through [Motion.effective] so
// MediaQuery.disableAnimations collapses it to instant, as
// accessibility requires.

import 'package:flutter/material.dart';

abstract final class Motion {
  /// Standard entrance/transition duration.
  static const Duration duration = Duration(milliseconds: 320);

  /// Short, local feedback (tap scale, digit fade).
  static const Duration short = Duration(milliseconds: 180);

  /// The one curve used for motion in this app.
  static const Curve curve = Curves.easeOutCubic;

  /// Rise distance for fade+rise entrances.
  static const double riseDistance = 16;

  /// Per-item delay for staggered entrances.
  static const Duration stagger = Duration(milliseconds: 60);

  static bool reduced(BuildContext context) =>
      MediaQuery.of(context).disableAnimations;

  /// Returns [value], or [Duration.zero] when the user has asked for
  /// reduced motion — the single place this check should happen.
  static Duration effective(BuildContext context, Duration value) =>
      reduced(context) ? Duration.zero : value;
}
