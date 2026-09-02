// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Continued from azkar_category_icon_painters_a.dart/_b.dart — new
// file rather than appending, since both were already near the
// 150-line limit. Funeral, weather, food & fasting, marriage.

import 'package:flutter/material.dart';

import '../../../../core/presentation/icons/noor_icon_style.dart';

/// Funeral & bereavement — a headstone with a crescent, distinct from
/// visiting-the-grave's plain headstone (that one stays as-is).
class AzkarFuneralIconPainter extends CustomPainter {
  AzkarFuneralIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(3, 20), const Offset(21, 20), stroke);
    canvas.drawPath(
      Path()
        ..moveTo(7, 20)
        ..lineTo(7, 12)
        ..arcToPoint(const Offset(17, 12), radius: const Radius.circular(5))
        ..lineTo(17, 20),
      stroke,
    );
    canvas.drawArc(const Rect.fromLTWH(9.5, 5, 5, 5), -2.2, 4.6, false, stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarFuneralIconPainter old) => old.color != color;
}

/// Weather — a cloud with a raindrop.
class AzkarWeatherIconPainter extends CustomPainter {
  AzkarWeatherIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(6.5, 15)
        ..cubicTo(4, 15, 4, 11, 6.7, 11.1)
        ..cubicTo(7.1, 8, 11.6, 7.6, 12.6, 10.2)
        ..cubicTo(15, 9.4, 17, 11.2, 16.3, 13.3)
        ..cubicTo(18.8, 13.6, 18.4, 17, 15.6, 17)
        ..lineTo(6.5, 17)
        ..close(),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(11, 19.5)
        ..cubicTo(11, 21.5, 13.5, 21.5, 13.5, 19.5)
        ..cubicTo(13.5, 18.2, 11, 20.5, 11, 19.5)
        ..close(),
      noorIconFill(color),
    );
  }

  @override
  bool shouldRepaint(covariant AzkarWeatherIconPainter old) => old.color != color;
}

/// Food & fasting — a crescent moon over a bowl, tying it to breaking
/// the fast rather than a generic meal glyph.
class AzkarFoodFastingIconPainter extends CustomPainter {
  AzkarFoodFastingIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(4.5, 14)
        ..cubicTo(4.5, 18, 8, 20, 12, 20)
        ..cubicTo(16, 20, 19.5, 18, 19.5, 14)
        ..close(),
      stroke,
    );
    canvas.drawLine(const Offset(4.5, 14), const Offset(19.5, 14), stroke);
    canvas.drawArc(const Rect.fromLTWH(13, 3, 6, 6), 2.3, 4.8, false, stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarFoodFastingIconPainter old) => old.color != color;
}

/// Marriage — two interlocking rings.
class AzkarMarriageIconPainter extends CustomPainter {
  AzkarMarriageIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawCircle(const Offset(9.5, 14), 5, stroke);
    canvas.drawCircle(const Offset(14.5, 14), 5, stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarMarriageIconPainter old) => old.color != color;
}
