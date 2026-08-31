// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The compass dial's tapered needle — a plain Canvas Path drawing, not
// a text-glyph Icon(). This matters for a concrete reason logged
// 2026-08-30: the previous Icon(Icons.navigation)-based needle
// rendered as a near-invisible malformed speck on a real test device
// (a GPU/driver compositing glitch, root cause outside this app's
// control — see the qibla_needle.dart history). Pure vector Path
// drawing sidesteps that whole class of bug rather than risking a
// repeat of it in the redesigned dial.

import 'package:flutter/material.dart';

class CompassNeedlePainter extends CustomPainter {
  CompassNeedlePainter({required this.alpha, required this.cyan, required this.gold});

  /// 0..1 — dims the needle when the compass reading isn't trustworthy,
  /// same meaning as the previous needle widget's `dimmed` flag.
  final double alpha;
  final Color cyan;
  final Color gold;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final gradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [cyan.withValues(alpha: alpha), gold.withValues(alpha: alpha)],
      ).createShader(Rect.fromCircle(center: center, radius: size.height / 2))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final tipY = -size.height / 2 + 12;
    final glowPath = Path()
      ..moveTo(0, 0)
      ..lineTo(-9, 0)
      ..lineTo(0, tipY - 6)
      ..lineTo(9, 0)
      ..close();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.drawPath(glowPath, gradient..color = gradient.color.withValues(alpha: 0.35 * alpha));

    final needlePath = Path()
      ..moveTo(0, 0)
      ..lineTo(-8, 0)
      ..lineTo(0, tipY)
      ..lineTo(8, 0)
      ..close();
    canvas.drawPath(
      needlePath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [cyan.withValues(alpha: alpha), gold.withValues(alpha: alpha)],
        ).createShader(Rect.fromLTWH(-8, tipY, 16, -tipY)),
    );

    final tailPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height / 2 - 20)
      ..lineTo(-5, 0)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFF3B3C42).withValues(alpha: 0.55 * alpha));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CompassNeedlePainter old) => old.alpha != alpha;
}
