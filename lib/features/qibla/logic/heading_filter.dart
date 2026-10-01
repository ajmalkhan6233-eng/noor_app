// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Low-pass filter for a compass heading. Works on the circle, so a
// reading that crosses north (359 -> 1) moves 2 degrees, not 358; a
// small dead-band hides sensor jitter that would otherwise make the
// needle shiver.

import '../../../core/utils/angle_math.dart';

class HeadingFilter {
  HeadingFilter({this.factor = 0.3, this.deadbandDegrees = 0.2});

  /// Fraction (0-1) moved toward each new reading; lower is smoother.
  final double factor;

  /// Steps smaller than this are ignored.
  final double deadbandDegrees;

  double? _value;

  /// Feeds a raw heading (any degrees value) and returns the smoothed
  /// heading in [0, 360).
  double update(double raw) {
    final target = AngleMath.normalise(raw);
    final previous = _value;
    if (previous == null) return _value = target;
    final next = AngleMath.smooth(previous, target, factor);
    if (AngleMath.difference(next, previous).abs() < deadbandDegrees) return previous;
    return _value = next;
  }

  void reset() => _value = null;
}
