// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Paints the starfield: each star as a short streak from its previous
// to current position, under a slow whole-field rotation.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../constants/splash_config.dart';
import 'star.dart';

/// Draws [stars] as outward-streaming streaks at time [elapsedSeconds].
class StarFieldPainter extends CustomPainter {
  StarFieldPainter({required this.stars, required this.elapsedSeconds});

  final List<Star> stars;
  final double elapsedSeconds;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.longestSide * 0.75;
    final rotation =
        elapsedSeconds * SplashConfig.rotationRadiansPerSecond;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final paint = Paint()
      ..strokeWidth = SplashConfig.starStrokeWidth
      ..strokeCap = StrokeCap.round;

    for (final star in stars) {
      final currentRadius = star.radiusAt(elapsedSeconds, maxRadius);
      final trailT = math.max(
        0.0,
        elapsedSeconds - SplashConfig.starStreakTrailSeconds,
      );
      final trailRadius = star.radiusAt(trailT, maxRadius);
      if (currentRadius <= 0) continue;

      final direction = Offset(math.cos(star.angle), math.sin(star.angle));
      final from = direction * trailRadius;
      final to = direction * currentRadius;
      final alpha = star.alphaAt(elapsedSeconds);

      paint.color = ui.Color.fromRGBO(245, 240, 230, alpha);
      canvas.drawLine(from, to, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) =>
      oldDelegate.elapsedSeconds != elapsedSeconds;
}
