// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The particle model and painter behind CosmicBackground — kept
// separate so neither file needs to grow past the 150-line limit.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/app_color_tokens.dart';

class DriftingParticle {
  DriftingParticle({
    required this.x,
    required this.y,
    required this.driftAngle,
    required this.driftRadius,
    required this.radius,
    required this.phase,
    required this.gold,
    required this.opacity,
  });

  final double x;
  final double y;
  final double driftAngle;
  final double driftRadius;
  final double radius;
  final double phase;
  final bool gold;
  final double opacity;

  static List<DriftingParticle> generate(int count) {
    final random = math.Random();
    return List.generate(count, (i) {
      return DriftingParticle(
        // Normalized (0-1) so painting scales to any screen size.
        x: random.nextDouble(),
        y: random.nextDouble(),
        driftAngle: random.nextDouble() * 2 * math.pi,
        driftRadius: 0.02 + random.nextDouble() * 0.05,
        radius: 0.8 + random.nextDouble() * 1.8,
        phase: random.nextDouble() * 2 * math.pi,
        gold: i.isEven,
        opacity: 0.12 + random.nextDouble() * 0.18,
      );
    });
  }
}

class CosmicPainter extends CustomPainter {
  const CosmicPainter({required this.particles, required this.t, required this.tokens});

  final List<DriftingParticle> particles;

  /// 0..1 loop progress.
  final double t;

  /// The active theme's palette — drives both particle color and, for
  /// Light, a lower opacity ceiling so particles stay a quiet ambient
  /// detail on a white background instead of reading as noisy dots.
  final AppColorTokens tokens;

  @override
  void paint(Canvas canvas, Size size) {
    final isLight = tokens.brightness == Brightness.light;
    // Light needs materially dimmer particles — the same alpha that
    // reads as a subtle glow on obsidian reads as a spattered dot on
    // white. Not simply disabled, per spec: still moving, still two
    // alternating tones, just quieter.
    final opacityScale = isLight ? 0.45 : 1.0;
    final angle = t * 2 * math.pi;
    for (final p in particles) {
      // Each particle slowly circles a fixed anchor point rather than
      // travelling in one direction — keeps it on-screen forever
      // without needing to wrap/respawn.
      final localAngle = angle + p.phase;
      final dx = math.cos(p.driftAngle + localAngle) * p.driftRadius;
      final dy = math.sin(p.driftAngle + localAngle) * p.driftRadius;
      final center = Offset(
        (p.x + dx) * size.width,
        (p.y + dy) * size.height,
      );
      // Gentle breathing so it doesn't read as static even mid-drift.
      final breathe = 0.75 + 0.25 * math.sin(localAngle * 1.3);
      canvas.drawCircle(
        center,
        p.radius,
        Paint()
          ..color = (p.gold ? tokens.gold : tokens.accentSecondary)
              .withValues(alpha: p.opacity * breathe * opacityScale),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CosmicPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.tokens != tokens;
}
