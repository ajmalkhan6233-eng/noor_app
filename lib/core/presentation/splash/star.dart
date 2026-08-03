// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A single starfield particle: a fixed outward direction plus
// independent twinkle and speed variation, so the field reads as
// organic rather than mechanically uniform.

import 'dart:math' as math;

import '../../constants/splash_config.dart';

/// One star streaming outward from the splash's centre.
class Star {
  const Star({
    required this.angle,
    required this.twinklePhase,
    required this.twinkleFreqHz,
    required this.speedFactor,
  });

  /// Fixed direction from the centre, in radians.
  final double angle;

  /// Phase offset so stars twinkle independently of one another.
  final double twinklePhase;

  /// Individual twinkle frequency, within the configured range.
  final double twinkleFreqHz;

  /// Per-star multiplier on burst/drift distance, for organic variety.
  final double speedFactor;

  /// Generates a deterministic field of [count] stars.
  static List<Star> generateField(int count, int seed) {
    final random = math.Random(seed);
    const freqRange =
        SplashConfig.starTwinkleFreqMaxHz - SplashConfig.starTwinkleFreqMinHz;
    return List<Star>.generate(count, (_) {
      return Star(
        angle: random.nextDouble() * 2 * math.pi,
        twinklePhase: random.nextDouble() * 2 * math.pi,
        twinkleFreqHz:
            SplashConfig.starTwinkleFreqMinHz + random.nextDouble() * freqRange,
        speedFactor: 0.7 + random.nextDouble() * 0.6,
      );
    });
  }

  /// Outward distance from the centre at time [t] (seconds), given the
  /// field's [maxRadius] in pixels. Fast burst term decays smoothly
  /// into a steady drift term — a single continuous function rather
  /// than a hard cut between two phases.
  double radiusAt(double t, double maxRadius) {
    final burstDistance =
        maxRadius * SplashConfig.starBurstDistanceFraction * speedFactor;
    final tau = SplashConfig.starBurstTau * speedFactor;
    final driftSpeed =
        maxRadius * SplashConfig.starDriftFractionPerSecond * speedFactor;
    final clampedT = t < 0 ? 0.0 : t;
    return burstDistance * (1 - math.exp(-clampedT / tau)) +
        driftSpeed * clampedT;
  }

  /// Twinkle opacity at time [t], clamped to a valid alpha range.
  double alphaAt(double t) {
    final wave = math.sin(2 * math.pi * twinkleFreqHz * t + twinklePhase);
    final alpha = SplashConfig.starBaseAlpha +
        SplashConfig.starTwinkleAmplitude * wave;
    return alpha.clamp(0.0, 1.0);
  }
}
