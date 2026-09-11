// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Quran and Duas bottom-nav glyphs — split out of nav_icon_painters.dart
// to stay under this project's 150-line-per-file convention.
//
// Clean, minimal gold-line aesthetic (2026-09-11) — same treatment as
// [HomeIconPainter]: no orb badge, no fills/gradients, just [color]
// strokes at matching weights, so the bottom-nav set reads as one
// consistent family. Quran keeps its open-book silhouette; Duas keeps
// its crescent-and-light motif — just re-drawn as line art.

import 'package:flutter/material.dart';

import 'noor_icon_style.dart';

class QuranIconPainter extends CustomPainter {
  QuranIconPainter(this.color, {this.active = true});
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);

    final stroke = noorIconStroke(color, width: active ? 1.7 : 1.4);
    final thinStroke = noorIconStroke(color, width: active ? 1.3 : 1.1);

    final leftPage = Path()
      ..moveTo(12, 8.2)
      ..quadraticBezierTo(7.3, 6.3, 4, 7.6)
      ..lineTo(4, 17.8)
      ..quadraticBezierTo(7.3, 16.3, 12, 18.2);
    final rightPage = Path()
      ..moveTo(12, 8.2)
      ..quadraticBezierTo(16.7, 6.3, 20, 7.6)
      ..lineTo(20, 17.8)
      ..quadraticBezierTo(16.7, 16.3, 12, 18.2);
    canvas.drawPath(leftPage, stroke);
    canvas.drawPath(rightPage, stroke);
    canvas.drawLine(const Offset(12, 8.2), const Offset(12, 18.2), thinStroke);

    canvas.drawPath(
      Path()
        ..moveTo(13.4, 4.6)
        ..lineTo(13.4, 8.7)
        ..lineTo(12.2, 7.8)
        ..lineTo(11, 8.7)
        ..lineTo(11, 4.6),
      thinStroke,
    );
  }

  @override
  bool shouldRepaint(covariant QuranIconPainter old) => old.active != active || old.color != color;
}

/// A crescent cradling a small radiant light — dua as calling toward
/// light/guidance, tying into the app's own "noor" (light) name —
/// instead of a literal raised-hands or human figure.
class DuasIconPainter extends CustomPainter {
  DuasIconPainter(this.color, {this.active = true});
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);

    final stroke = noorIconStroke(color, width: active ? 1.7 : 1.4);
    final thinStroke = noorIconStroke(color, width: active ? 1.3 : 1.1);

    final crescent = Path()
      ..moveTo(16.2, 5.3)
      ..arcToPoint(const Offset(16.2, 18.7), radius: const Radius.circular(7.5), largeArc: true, clockwise: false)
      ..arcToPoint(const Offset(16.2, 5.3), radius: const Radius.circular(6), clockwise: true);
    canvas.drawPath(crescent, stroke);

    final spark = Path()
      ..moveTo(9.2, 11.5)
      ..lineTo(9.9, 13.6)
      ..lineTo(12, 14.3)
      ..lineTo(9.9, 15)
      ..lineTo(9.2, 17.1)
      ..lineTo(8.5, 15)
      ..lineTo(6.4, 14.3)
      ..lineTo(8.5, 13.6)
      ..close();
    canvas.drawPath(spark, thinStroke);
  }

  @override
  bool shouldRepaint(covariant DuasIconPainter old) => old.active != active || old.color != color;
}
