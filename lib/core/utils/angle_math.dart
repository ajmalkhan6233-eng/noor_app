// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure circular-angle helpers, shared by anything that averages or
// smooths bearings (qibla, compass heading). Angles wrap at 360°, so
// they must always be combined as unit vectors — never as plain
// scalars, or a mean of 359° and 1° comes out as 180° instead of 0°.

import 'dart:math' as math;

/// Circular-angle utilities operating in degrees.
abstract final class AngleMath {
  /// Normalises [degrees] into the range `[0, 360)`.
  static double normalise(double degrees) {
    var wrapped = degrees % 360;
    if (wrapped < 0) wrapped += 360;
    // Floating-point rounding can push a tiny-negative input's modulo
    // to exactly 360.0 instead of just under it — fold that back to 0.
    if (wrapped >= 360) wrapped -= 360;
    return wrapped;
  }

  /// Shortest signed difference `a - b`, in the range `(-180, 180]`.
  static double difference(double a, double b) {
    final raw = normalise(a - b);
    return raw > 180 ? raw - 360 : raw;
  }

  /// Mean of [anglesDegrees], computed as the resultant of unit
  /// vectors rather than an arithmetic mean of the scalar values —
  /// so `circularMean([359, 1])` is `0`, not `180`.
  static double circularMean(List<double> anglesDegrees) {
    if (anglesDegrees.isEmpty) {
      throw ArgumentError('anglesDegrees must not be empty');
    }
    var sumSin = 0.0;
    var sumCos = 0.0;
    for (final degrees in anglesDegrees) {
      final radians = degrees * math.pi / 180;
      sumSin += math.sin(radians);
      sumCos += math.cos(radians);
    }
    final meanRadians = math.atan2(sumSin, sumCos);
    return normalise(meanRadians * 180 / math.pi);
  }

  /// Moves [previous] a fraction [factor] (`0`–`1`) of the way toward
  /// [target], travelling the shorter way around the circle — for
  /// damping a jittery live compass/bearing reading frame to frame.
  static double smooth(double previous, double target, double factor) {
    final clampedFactor = factor.clamp(0.0, 1.0);
    final delta = difference(target, previous);
    return normalise(previous + delta * clampedFactor);
  }
}
