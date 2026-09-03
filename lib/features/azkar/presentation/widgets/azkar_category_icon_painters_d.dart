// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Continued from azkar_category_icon_painters_a/_b/_c.dart — new file
// rather than appending, since _c.dart is already near the 150-line
// limit. Waking up, home, clothing, wudu.

import 'package:flutter/material.dart';

import '../../../../core/presentation/icons/noor_icon_style.dart';

/// Waking up — a rising sun (half-disc + rays), distinct from the
/// evening/morning header icons elsewhere in the app.
class AzkarWakingUpIconPainter extends CustomPainter {
  AzkarWakingUpIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(4, 17), const Offset(20, 17), stroke);
    canvas.drawArc(const Rect.fromLTWH(7, 6, 10, 10), 3.4, 2.6, false, stroke);
    for (final dx in [7.0, 12.0, 17.0]) {
      canvas.drawLine(Offset(dx, 3), Offset(dx, 6), stroke);
    }
  }

  @override
  bool shouldRepaint(covariant AzkarWakingUpIconPainter old) => old.color != color;
}

/// Home — a plain house outline, for entering/leaving the house.
class AzkarHomeIconPainter extends CustomPainter {
  AzkarHomeIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(4, 12)
        ..lineTo(12, 5)
        ..lineTo(20, 12),
      stroke,
    );
    canvas.drawRect(const Rect.fromLTWH(6.5, 12, 11, 8), stroke);
    canvas.drawLine(const Offset(10.5, 20), const Offset(10.5, 15), stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarHomeIconPainter old) => old.color != color;
}

/// Clothing — a simple garment silhouette, for dressing duas.
class AzkarClothingIconPainter extends CustomPainter {
  AzkarClothingIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(9, 5)
        ..lineTo(4, 8)
        ..lineTo(6, 11)
        ..lineTo(8, 9.5)
        ..lineTo(8, 20)
        ..lineTo(16, 20)
        ..lineTo(16, 9.5)
        ..lineTo(18, 11)
        ..lineTo(20, 8)
        ..lineTo(15, 5)
        ..cubicTo(15, 7, 9, 7, 9, 5)
        ..close(),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant AzkarClothingIconPainter old) => old.color != color;
}

/// Wudu (ablution) — a water droplet.
class AzkarWuduIconPainter extends CustomPainter {
  AzkarWuduIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(12, 4)
        ..cubicTo(16.5, 10, 18, 13, 18, 15.5)
        ..cubicTo(18, 19.6, 15.3, 21.5, 12, 21.5)
        ..cubicTo(8.7, 21.5, 6, 19.6, 6, 15.5)
        ..cubicTo(6, 13, 7.5, 10, 12, 4)
        ..close(),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant AzkarWuduIconPainter old) => old.color != color;
}
