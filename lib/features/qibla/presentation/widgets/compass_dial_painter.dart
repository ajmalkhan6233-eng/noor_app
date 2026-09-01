// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The entire compass dial — rings, ticks, cardinals, the "القبلة"
// label, the needle, and the Kaaba badge — drawn in one paint() call
// on one Canvas. Previously these were five separate widgets/painters
// composited via a Stack (some behind their own RepaintBoundary, one
// behind a Ticker-driven StatefulWidget) and the dial intermittently
// collapsed to a small malformed fragment on-device. Root-caused
// 2026-09-01 through elimination: removing gradients/blur didn't fix
// it, decoupling repaint rate via a local Ticker didn't fix it, and
// disabling Impeller via the AndroidManifest flag didn't fix it either
// (that flag is itself a known-broken no-op on some Android configs —
// see flutter/flutter#154252). What's common to every attempt that
// failed is that they all still asked the engine to composite several
// separately-painted layers together. Real Qibla apps avoid this class
// of bug by keeping the whole compass as one simple rotating draw —
// so this painter does the same: single Canvas, single paint(), no
// nested layers for the engine to glitch between.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';

class CompassDialPainter extends CustomPainter {
  CompassDialPainter({
    required this.rotationDegrees,
    required this.alpha,
    required this.locked,
    required this.gold,
    required this.cyan,
    required this.ink,
    required this.sage,
  });

  final double rotationDegrees;
  final double alpha;
  final bool locked;
  final Color gold;
  final Color cyan;
  final Color ink;
  final Color sage;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    _drawRings(canvas, center, r);
    _drawTickDiamonds(canvas, center, r);
    _drawFineTicks(canvas, center, r);
    _drawCardinals(canvas, center, r);
    _drawArabicLabel(canvas, center, r);
    _drawHub(canvas, center);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationDegrees * math.pi / 180);
    _drawNeedle(canvas, r);
    _drawKaabaBadge(canvas, r);
    canvas.restore();
  }

  void _drawRings(Canvas canvas, Offset center, double r) {
    canvas.drawCircle(center, r, Paint()..color = const Color(0xFF121522).withValues(alpha: 0.6));
    canvas.drawCircle(center, r, Paint()
      ..color = gold.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4);
    for (final (radiusFactor, color, ringAlpha) in [
      (150 / 160, gold, 0.22),
      (122 / 160, gold, 0.15),
      (90 / 160, gold, 0.2),
      (60 / 160, cyan, 0.14),
    ]) {
      canvas.drawCircle(
        center,
        r * radiusFactor,
        Paint()
          ..color = color.withValues(alpha: ringAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
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
      canvas.drawRect(const Rect.fromLTWH(-3.5, -3.5, 7, 7), Paint()..color = color.withValues(alpha: 0.75));
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

    _text(canvas, 'N', center + const Offset(0, -1) * (r - 32), ink, 19, FontWeight.w800, AppTypography.bodyFamily);
    _text(canvas, 'S', center + const Offset(0, 1) * (r - 38), sage, 15, FontWeight.w700, AppTypography.bodyFamily);
    _text(canvas, 'E', center + Offset(r - 38, 0), sage, 15, FontWeight.w700, AppTypography.bodyFamily);
    _text(canvas, 'W', center + Offset(-(r - 38), 0), sage, 15, FontWeight.w700, AppTypography.bodyFamily);
  }

  void _drawArabicLabel(Canvas canvas, Offset center, double r) {
    _text(
      canvas,
      'القبلة',
      center + Offset(0, -r * 0.44),
      gold.withValues(alpha: 0.8),
      17,
      FontWeight.normal,
      AppTypography.arabicFamily,
      direction: TextDirection.rtl,
    );
  }

  void _drawHub(Canvas canvas, Offset center) {
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

  void _drawNeedle(Canvas canvas, double r) {
    final color = locked ? gold : cyan;
    final tipY = -r + 12;

    final needlePath = Path()
      ..moveTo(0, 0)
      ..lineTo(-8, 0)
      ..lineTo(0, tipY)
      ..lineTo(8, 0)
      ..close();
    canvas.drawPath(needlePath, Paint()..color = color.withValues(alpha: alpha));

    final tailPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, r - 20)
      ..lineTo(-5, 0)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFF3B3C42).withValues(alpha: 0.55 * alpha));
  }

  void _drawKaabaBadge(Canvas canvas, double r) {
    canvas.save();
    canvas.translate(0, -r * 0.76);

    const badgeRadius = 25.0;
    const ringRadius = badgeRadius * 0.74;
    canvas.drawCircle(Offset.zero, ringRadius, Paint()..color = const Color(0xFF0A0D14).withValues(alpha: alpha));
    canvas.drawCircle(
      Offset.zero,
      ringRadius,
      Paint()
        ..color = gold.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    final kiswahRect = Rect.fromCenter(center: Offset.zero, width: ringRadius * 1.02, height: ringRadius * 0.82);
    final borderPaint = Paint()
      ..color = gold.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final rrect = RRect.fromRectAndRadius(kiswahRect, const Radius.circular(1));
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF161B29).withValues(alpha: alpha));
    canvas.drawRRect(rrect, borderPaint);

    canvas.drawRect(
      Rect.fromLTWH(kiswahRect.left, kiswahRect.top, kiswahRect.width, kiswahRect.height * 0.26),
      Paint()..color = gold.withValues(alpha: alpha),
    );

    final doorArch = Path()
      ..moveTo(-4, kiswahRect.top)
      ..lineTo(0, kiswahRect.top - 7)
      ..lineTo(4, kiswahRect.top);
    canvas.drawPath(doorArch, borderPaint);

    final doorRect = Rect.fromCenter(center: Offset(0, kiswahRect.bottom - kiswahRect.height * 0.28), width: 6, height: kiswahRect.height * 0.46);
    canvas.drawRect(doorRect, Paint()..color = const Color(0xFF0A0D14).withValues(alpha: alpha));
    canvas.drawRect(
      doorRect,
      Paint()
        ..color = gold.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    canvas.restore();
  }

  void _text(
    Canvas canvas,
    String text,
    Offset center,
    Color color,
    double fontSize,
    FontWeight weight,
    String fontFamily, {
    TextDirection direction = TextDirection.ltr,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: weight, fontFamily: fontFamily)),
      textDirection: direction,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CompassDialPainter old) =>
      old.rotationDegrees != rotationDegrees || old.alpha != alpha || old.locked != locked;
}
