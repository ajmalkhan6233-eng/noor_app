// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The gold-trimmed Kaaba badge that sits on the compass ring at the
// live bearing, per the 2026-08-30 mockup rebuild — a simple kiswah
// (the Kaaba's black cloth covering)+door glyph, not a literal replica.

import 'package:flutter/material.dart';

class KaabaBadgePainter extends CustomPainter {
  KaabaBadgePainter({required this.alpha, required this.gold});

  final double alpha;
  final Color gold;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [gold.withValues(alpha: 0.55 * alpha), gold.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    final ringRadius = radius * 0.74;
    canvas.drawCircle(center, ringRadius, Paint()..color = const Color(0xFF0A0D14).withValues(alpha: alpha));
    canvas.drawCircle(
      center,
      ringRadius,
      Paint()
        ..color = gold.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    final kiswahRect = Rect.fromCenter(center: Offset.zero, width: ringRadius * 1.02, height: ringRadius * 0.82);
    final kiswahPaint = Paint()..color = const Color(0xFF161B29).withValues(alpha: alpha);
    final borderPaint = Paint()
      ..color = gold.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final rrect = RRect.fromRectAndRadius(kiswahRect, const Radius.circular(1));
    canvas.drawRRect(rrect, kiswahPaint);
    canvas.drawRRect(rrect, borderPaint);

    // Gold band across the top — the kiswah's embroidered belt.
    canvas.drawRect(
      Rect.fromLTWH(kiswahRect.left, kiswahRect.top, kiswahRect.width, kiswahRect.height * 0.26),
      Paint()..color = gold.withValues(alpha: alpha),
    );

    // Door arch.
    final doorArch = Path()
      ..moveTo(-4, kiswahRect.top)
      ..lineTo(0, kiswahRect.top - 7)
      ..lineTo(4, kiswahRect.top);
    canvas.drawPath(doorArch, borderPaint);

    // Door accent.
    final doorRect = Rect.fromCenter(center: Offset(0, kiswahRect.bottom - kiswahRect.height * 0.28), width: 6, height: kiswahRect.height * 0.46);
    canvas.drawRect(doorRect, Paint()..color = const Color(0xFF0A0D14).withValues(alpha: alpha));
    canvas.drawRect(doorRect, Paint()
      ..color = gold.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant KaabaBadgePainter old) => old.alpha != alpha;
}
