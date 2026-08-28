// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The particle model and painter behind ParticleBurst — kept separate
// so neither file needs to grow past a single clear responsibility.

import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../constants/app_color_tokens.dart';

/// One particle's fixed launch angle, distance, and size — generated
/// once per burst and then just interpolated by [progress] each frame.
class BurstParticle {
  const BurstParticle({
    required this.angle,
    required this.distance,
    required this.radius,
    required this.delay,
    required this.soft,
  });

  final double angle;
  final double distance;
  final double radius;

  /// Fraction (0–1) of the burst's total progress before this
  /// particle starts moving, so the burst reads as a single outward
  /// pulse rather than every particle firing in lockstep.
  final double delay;

  /// Alternates between the accent colour and its dimmed variant, so
  /// the burst has depth without introducing a new colour.
  final bool soft;

  /// [intensity] (0–1) scales both particle count and travel — a
  /// small value gives a handful of short-throw sparks (qibla lock);
  /// near 1 gives a fuller burst (tasbih milestone). [maxDistance]
  /// caps how far a particle can travel in logical pixels — defaults
  /// to the original fixed 28–74px range (in-context effects like the
  /// Tasbih/Tawaf-Sa'i bursts stay unchanged); pass a screen-derived
  /// value for a full-screen effect like the splash burst so it reads
  /// as a genuine expansion rather than a fixed-size sparkle on a
  /// much bigger canvas.
  static List<BurstParticle> generate(double intensity, {double maxDistance = 74}) {
    final random = math.Random();
    final count = (6 + intensity * 14).round();
    final minDistance = maxDistance * 0.38;
    final spread = maxDistance - minDistance;
    return List.generate(count, (i) {
      return BurstParticle(
        angle: random.nextDouble() * 2 * math.pi,
        distance: (minDistance + random.nextDouble() * spread) * (0.4 + intensity * 0.6),
        radius: 2 + random.nextDouble() * 3,
        delay: random.nextDouble() * 0.25,
        soft: i.isEven,
      );
    });
  }
}

/// Draws every particle radiating outward from [center] and fading as
/// [progress] runs 0→1, plus a soft central glow that blooms then
/// dissolves — the same "breathing" quality the app's other glow
/// effects (calligraphy, needle) use.
class ParticleBurstPainter extends CustomPainter {
  const ParticleBurstPainter({
    required this.center,
    required this.progress,
    required this.particles,
    required this.color,
    this.softColor = const Color(0xFF00F2FE),
    this.growing = false,
  });

  final Offset center;
  final double progress;
  final List<BurstParticle> particles;
  final Color color;

  /// False (default, every existing caller — Tasbih, Tawaf/Sa'i, Qibla
  /// lock): particles start at full size/brightness and fade out as
  /// they travel, an "ignition then dissolve" read. True (the splash's
  /// Big Bang only): inverted — particles start small and dim at
  /// centre and grow larger/brighter as they expand outward, an
  /// "emerging from nothing" read that suits an opening moment better
  /// than a completion one.
  final bool growing;

  /// Colour for particles where [BurstParticle.soft] is true. Defaults
  /// to the locked cyan accent (every caller — Tasbih, Tawaf/Sa'i,
  /// Qibla lock, the splash burst — now shares the same gold/cyan
  /// pairing; legacy emerald was retired app-wide in the final
  /// pre-release palette pass).
  final Color softColor;

  @override
  void paint(Canvas canvas, Size size) {
    final glowOpacity = (math.sin(progress * math.pi) * 0.35).clamp(0.0, 1.0);
    if (glowOpacity > 0) {
      canvas.drawCircle(
        center,
        18 + progress * 10,
        Paint()
          ..color = color.withValues(alpha: glowOpacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    for (final particle in particles) {
      final local = ((progress - particle.delay) / (1 - particle.delay))
          .clamp(0.0, 1.0);
      if (local <= 0) continue;

      final eased = Curves.easeOutCubic.transform(local);
      final offset = Offset(
        center.dx + math.cos(particle.angle) * particle.distance * eased,
        center.dy + math.sin(particle.angle) * particle.distance * eased,
      );
      // growing (splash only): without this tail-fade, particles hit
      // full opacity at local==1 and — since this CustomPaint has no
      // dissolve/removal of its own — stayed frozen there, visible
      // straight through the Bismillah and NOOR phases as a stray dot
      // (2026-08-25 live-device review: "there is a dot in the
      // middle... even after the NOOR name comes up"). Ramping back
      // down over the last 30% of each particle's own progress means
      // every particle is fully gone by the time the burst controller
      // completes, with nothing outside this painter needing to know.
      final growingFade = local < 0.7 ? 1.0 : (1 - (local - 0.7) / 0.3).clamp(0.0, 1.0);
      final opacity = growing ? local * 0.9 * growingFade : (1 - local) * 0.9;
      if (opacity <= 0) continue;
      final radiusScale = growing ? 0.2 + local * 0.8 : (1 - local * 0.4);

      canvas.drawCircle(
        offset,
        particle.radius * radiusScale,
        Paint()
          ..color = (particle.soft ? softColor : color)
              .withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticleBurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
