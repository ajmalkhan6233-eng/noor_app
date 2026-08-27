// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// More-screen glyphs, part 1: Qibla, Tasbih, Calendar, Zakat. See
// noor_icon_type.dart for why these exist instead of Material icons.

import 'package:flutter/material.dart';

import 'noor_icon_style.dart';

/// Deliberately echoes the redesigned Qibla screen's own compass
/// needle shape, so the More-tile and the screen it opens read as the
/// same object.
class QiblaIconPainter extends CustomPainter {
  QiblaIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    canvas.drawCircle(const Offset(12, 12), 8, noorIconStroke(color));
    canvas.save();
    canvas.translate(12, 12);
    canvas.rotate(-0.5);
    canvas.drawPath(
      Path()
        ..moveTo(0, -6)
        ..lineTo(1.6, 0)
        ..lineTo(0, 6)
        ..lineTo(-1.6, 0)
        ..close(),
      noorIconFill(color),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant QiblaIconPainter old) => old.color != color;
}

/// A strand of prayer beads instead of a generic "blur circular" glyph.
class TasbihIconPainter extends CustomPainter {
  TasbihIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final fill = noorIconFill(color);
    const beadPositions = [
      Offset(12, 5.5),
      Offset(17, 7.5),
      Offset(19.5, 12.5),
      Offset(17, 17.5),
      Offset(12, 19.5),
      Offset(7, 17.5),
      Offset(4.5, 12.5),
      Offset(7, 7.5),
    ];
    for (final p in beadPositions) {
      canvas.drawCircle(p, 1.5, fill);
    }
    // The imam bead, slightly larger, marking where a round completes.
    canvas.drawCircle(const Offset(12, 5.5), 2.1, fill);
  }

  @override
  bool shouldRepaint(covariant TasbihIconPainter old) => old.color != color;
}

class CalendarIconPainter extends CustomPainter {
  CalendarIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTRB(4, 6, 20, 20), const Radius.circular(2.5)),
      stroke,
    );
    canvas.drawLine(const Offset(4, 10.5), const Offset(20, 10.5), stroke);
    canvas.drawLine(const Offset(8, 4.5), const Offset(8, 7.5), stroke);
    canvas.drawLine(const Offset(16, 4.5), const Offset(16, 7.5), stroke);
    canvas.drawCircle(const Offset(12, 15), 1.3, noorIconFill(color));
  }

  @override
  bool shouldRepaint(covariant CalendarIconPainter old) => old.color != color;
}

/// A balance scale — zakat is literally about weighing wealth against
/// nisab — instead of a calculator glyph.
class ZakatIconPainter extends CustomPainter {
  ZakatIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(12, 5), const Offset(12, 19), stroke);
    canvas.drawLine(const Offset(5, 19), const Offset(19, 19), stroke);
    canvas.drawLine(const Offset(5, 7), const Offset(19, 7), stroke);
    canvas.drawLine(const Offset(5, 7), const Offset(5, 11), stroke);
    canvas.drawLine(const Offset(19, 7), const Offset(19, 11), stroke);
    canvas.drawArc(const Rect.fromLTRB(2.5, 9.5, 7.5, 14.5), 0.2, 2.7, false, stroke);
    canvas.drawArc(const Rect.fromLTRB(16.5, 9.5, 21.5, 14.5), 0.2, 2.7, false, stroke);
  }

  @override
  bool shouldRepaint(covariant ZakatIconPainter old) => old.color != color;
}
