// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The compass dial's static ring stack, tick marks, and cardinal
// letters — the part of the new dial (2026-08-30 mockup rebuild) that
// never rotates; only the needle and Kaaba badge (separate painters)
// move as the bearing/heading change. Ticks are generated in a loop
// rather than one shape per angle, unlike the mockup's literal SVG —
// same visual result, far less code.

import 'dart:math' as math;

import 'package:flutter/material.dart';

class CompassRingsPainter extends CustomPainter {
  CompassRingsPainter({required this.gold, required this.cyan, required this.ink, required this.sage});

  final Color gold;
  final Color cyan;
  final Color ink;
  final Color sage;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    canvas.drawCircle(center, r, Paint()..color = const Color(0xFF121522).withValues(alpha: 0.6));
    canvas.drawCircle(center, r, Paint()
      ..color = gold.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4);
    for (final (radiusFactor, color, alpha) in [
      (150 / 160, gold, 0.22),
      (122 / 160, gold, 0.15),
      (90 / 160, gold, 0.2),
      (60 / 160, cyan, 0.14),
    ]) {
      canvas.drawCircle(
        center,
        r * radiusFactor,
        Paint()
          ..color = color.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    _drawTickDiamonds(canvas, center, r);
    _drawFineTicks(canvas, center, r);
    _drawCardinals(canvas, center, r);
    canvas.drawCircle(center, 9, Paint()..color = const Color(0xFF0A0D14));
    canvas.drawCircle(
      center,
      9,
      Paint()
        ..color = gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(center, 3, Paint()..color = gold);
  }

  void _drawTickDiamonds(Canvas canvas, Offset center, double r) {
    for (var angle = 30; angle < 360; angle += 30) {
      if (angle == 0 || angle == 90 || angle == 180 || angle == 270) continue;
      final color = angle % 90 < 60 ? cyan : gold;
      final rad = angle * math.pi / 180;
      final point = center + Offset(math.sin(rad), -math.cos(rad)) * (r - 20);
      canvas.save();
      canvas.translate(point.dx, point.dy);
      canvas.rotate(rad + math.pi / 4);
      canvas.drawRect(
        const Rect.fromLTWH(-3.5, -3.5, 7, 7),
        Paint()..color = color.withValues(alpha: 0.75),
      );
      canvas.restore();
    }
  }

  void _drawFineTicks(Canvas canvas, Offset center, double r) {
    final paint = Paint()
      ..color = sage.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    for (var angle = 0; angle < 360; angle += 10) {
      if (angle % 30 == 0) continue;
      final rad = angle * math.pi / 180;
      final dir = Offset(math.sin(rad), -math.cos(rad));
      canvas.drawLine(center + dir * (r - 8), center + dir * (r - 16), paint);
    }
  }

  void _drawCardinals(Canvas canvas, Offset center, double r) {
    canvas.save();
    canvas.translate(center.dx, center.dy - r + 5);
    canvas.rotate(math.pi / 4);
    canvas.drawRect(const Rect.fromLTWH(-5, -5, 10, 10), Paint()..color = ink);
    canvas.restore();

    _text(canvas, 'N', center + const Offset(0, -1) * (r - 32), ink, 19, FontWeight.w800);
    _text(canvas, 'S', center + const Offset(0, 1) * (r - 38), sage, 15, FontWeight.w700);
    _text(canvas, 'E', center + Offset(r - 38, 0), sage, 15, FontWeight.w700);
    _text(canvas, 'W', center + Offset(-(r - 38), 0), sage, 15, FontWeight.w700);
  }

  void _text(Canvas canvas, String text, Offset center, Color color, double fontSize, FontWeight weight) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: weight)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CompassRingsPainter old) => false;
}
