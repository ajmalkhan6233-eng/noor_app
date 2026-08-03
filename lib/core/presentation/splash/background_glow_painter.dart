// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Paints the deep-emerald radial background (never pure black) plus a
// soft gold glow at centre that breathes in and out.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/splash_config.dart';

/// Static emerald backdrop with a breathing gold centre glow.
class BackgroundGlowPainter extends CustomPainter {
  BackgroundGlowPainter({required this.elapsedSeconds});

  final double elapsedSeconds;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Offset.zero & size;
    final maxRadius = size.longestSide * 0.75;

    final backgroundPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          SplashConfig.emeraldCenter,
          SplashConfig.emeraldMid,
          SplashConfig.emeraldEdge,
        ],
        stops: [0.0, 0.55, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    final breath = math.sin(
      2 * math.pi * elapsedSeconds / SplashConfig.glowBreathPeriodSeconds,
    );
    final glowRadius = maxRadius *
        (SplashConfig.nurRadius +
            SplashConfig.glowAmplitudeFraction * breath);
    final glowOpacity =
        SplashConfig.glowPeakOpacity * (0.7 + 0.3 * breath.abs());

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          SplashConfig.glowColor.withValues(alpha: glowOpacity),
          SplashConfig.glowColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: glowRadius));
    canvas.drawCircle(center, glowRadius, glowPaint);
  }

  @override
  bool shouldRepaint(covariant BackgroundGlowPainter oldDelegate) =>
      oldDelegate.elapsedSeconds != elapsedSeconds;
}
