// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Continued from azkar_category_icon_painters_a/_b/_c/_d.dart — new
// file rather than appending, since _d.dart is already near the
// 150-line limit. Toilet, mosque, anger, fear, sneezing.

import 'package:flutter/material.dart';

import '../../../../core/presentation/icons/noor_icon_style.dart';

/// Toilet — a door with a handle, for entering/leaving the toilet.
class AzkarToiletIconPainter extends CustomPainter {
  AzkarToiletIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(6, 3.5, 12, 17), const Radius.circular(1.5)),
      stroke,
    );
    canvas.drawCircle(const Offset(14.5, 12), 0.9, noorIconFill(color));
  }

  @override
  bool shouldRepaint(covariant AzkarToiletIconPainter old) => old.color != color;
}

/// Mosque — a dome with a crescent finial, for going to/entering/
/// leaving the mosque and the adhan.
class AzkarMosqueIconPainter extends CustomPainter {
  AzkarMosqueIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(3.5, 20), const Offset(20.5, 20), stroke);
    canvas.drawPath(
      Path()
        ..moveTo(6, 20)
        ..lineTo(6, 13)
        ..cubicTo(6, 8.5, 18, 8.5, 18, 13)
        ..lineTo(18, 20),
      stroke,
    );
    canvas.drawLine(const Offset(12, 8.5), const Offset(12, 5), stroke);
    canvas.drawArc(const Rect.fromLTWH(9.7, 2.7, 4.6, 4.6), 2.3, 4.8, false, stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarMosqueIconPainter old) => old.color != color;
}

/// Anger — a small burst of radiating lines, an abstract "flare up".
class AzkarAngerIconPainter extends CustomPainter {
  AzkarAngerIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    const center = Offset(12, 12);
    for (var i = 0; i < 8; i++) {
      final angle = i * 3.14159265 / 4;
      final inner = center + Offset(4.5 * _cos(angle), 4.5 * _sin(angle));
      final outer = center + Offset(9 * _cos(angle), 9 * _sin(angle));
      canvas.drawLine(inner, outer, stroke);
    }
  }

  double _cos(double a) => (a).isNaN ? 0 : Offset.fromDirection(a).dx;
  double _sin(double a) => (a).isNaN ? 0 : Offset.fromDirection(a).dy;

  @override
  bool shouldRepaint(covariant AzkarAngerIconPainter old) => old.color != color;
}

/// Fear — a wide, watchful eye, for fright/unease duas — distinct from
/// Distress's raincloud.
class AzkarFearIconPainter extends CustomPainter {
  AzkarFearIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(3.5, 12)
        ..cubicTo(6.5, 6.5, 17.5, 6.5, 20.5, 12)
        ..cubicTo(17.5, 17.5, 6.5, 17.5, 3.5, 12)
        ..close(),
      stroke,
    );
    canvas.drawCircle(const Offset(12, 12), 2.6, stroke);
    canvas.drawCircle(const Offset(12, 12), 1, noorIconFill(color));
  }

  @override
  bool shouldRepaint(covariant AzkarFearIconPainter old) => old.color != color;
}

/// Sneezing — a curved line with small burst dashes, distinct from
/// Anger's symmetric radiating burst by being one-sided and paired
/// with a curved "face" line.
class AzkarSneezingIconPainter extends CustomPainter {
  AzkarSneezingIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawArc(const Rect.fromLTWH(4, 4, 14, 16), 1.9, 2.5, false, stroke);
    for (final offset in [const Offset(16, 8), const Offset(19, 11), const Offset(18, 15)]) {
      canvas.drawLine(offset, offset + const Offset(3, -0.5), stroke);
    }
  }

  @override
  bool shouldRepaint(covariant AzkarSneezingIconPainter old) => old.color != color;
}
