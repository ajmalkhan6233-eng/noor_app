// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Original line-art for the Azkar category rows, replacing generic
// Material glyphs (2026-08-31, direct request: distinct, purpose-made
// icons per category, not repeated/generic ones). Split A–F; see
// azkar_category_icon_painters_b.dart for the rest. Same 24x24 box /
// stroke-weight convention as core/presentation/icons.

import 'package:flutter/material.dart';

import '../../../../core/presentation/icons/noor_icon_style.dart';

/// Morning — sunrise over the horizon.
class AzkarMorningIconPainter extends CustomPainter {
  AzkarMorningIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(3, 16), const Offset(21, 16), stroke);
    canvas.drawArc(const Rect.fromLTRB(6, 8, 18, 20), 3.14159, 3.14159, false, stroke);
    for (final dx in [7.0, 12.0, 17.0]) {
      canvas.drawLine(Offset(dx, 4), Offset(dx, 7), stroke);
    }
  }

  @override
  bool shouldRepaint(covariant AzkarMorningIconPainter old) => old.color != color;
}

/// Evening — crescent with a star, the sky after Maghrib.
class AzkarEveningIconPainter extends CustomPainter {
  AzkarEveningIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(15, 5)
        ..arcToPoint(const Offset(15, 19), radius: const Radius.circular(7), clockwise: false)
        ..arcToPoint(const Offset(15, 5), radius: const Radius.circular(9.5), clockwise: true),
      stroke,
    );
    canvas.drawCircle(const Offset(19, 7), 0.9, noorIconFill(color));
  }

  @override
  bool shouldRepaint(covariant AzkarEveningIconPainter old) => old.color != color;
}

/// After prayer — a small mosque silhouette (dome + minaret).
class AzkarAfterPrayerIconPainter extends CustomPainter {
  AzkarAfterPrayerIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(3, 19), const Offset(21, 19), stroke);
    canvas.drawArc(const Rect.fromLTRB(7, 9, 15, 17), 3.14159, 3.14159, false, stroke);
    canvas.drawLine(const Offset(7, 13), const Offset(7, 19), stroke);
    canvas.drawLine(const Offset(15, 13), const Offset(15, 19), stroke);
    canvas.drawLine(const Offset(18, 6), const Offset(18, 19), stroke);
    canvas.drawLine(const Offset(18, 5), const Offset(18, 5), noorIconStroke(color, width: 2.4));
  }

  @override
  bool shouldRepaint(covariant AzkarAfterPrayerIconPainter old) => old.color != color;
}

/// Sleep — a simple bed with a pillow.
class AzkarSleepIconPainter extends CustomPainter {
  AzkarSleepIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(4, 19), const Offset(4, 10), stroke);
    canvas.drawLine(const Offset(4, 10), const Offset(20, 10), stroke);
    canvas.drawLine(const Offset(20, 10), const Offset(20, 19), stroke);
    canvas.drawLine(const Offset(4, 15), const Offset(20, 15), stroke);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(5.5, 11.3, 4.5, 2.4), const Radius.circular(1.2)), stroke);
    canvas.drawLine(const Offset(2, 19), const Offset(22, 19), stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarSleepIconPainter old) => old.color != color;
}

/// Travel — a suitcase.
class AzkarTravelIconPainter extends CustomPainter {
  AzkarTravelIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(4, 9, 16, 11), const Radius.circular(2)), stroke);
    canvas.drawPath(
      Path()
        ..moveTo(9, 9)
        ..lineTo(9, 6.5)
        ..arcToPoint(const Offset(15, 6.5), radius: const Radius.circular(2))
        ..lineTo(15, 9),
      stroke,
    );
    canvas.drawLine(const Offset(12, 12.5), const Offset(12, 16.5), stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarTravelIconPainter old) => old.color != color;
}

/// Child protection — a shield with a small heart.
class AzkarChildProtectionIconPainter extends CustomPainter {
  AzkarChildProtectionIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(12, 3.5)
        ..lineTo(19, 6.5)
        ..lineTo(19, 12)
        ..cubicTo(19, 16.5, 16, 19.5, 12, 20.5)
        ..cubicTo(8, 19.5, 5, 16.5, 5, 12)
        ..lineTo(5, 6.5)
        ..close(),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(12, 14.5)
        ..cubicTo(9, 12, 9, 9.8, 10.4, 9.2)
        ..cubicTo(11.3, 8.8, 12, 9.7, 12, 10.3)
        ..cubicTo(12, 9.7, 12.7, 8.8, 13.6, 9.2)
        ..cubicTo(15, 9.8, 15, 12, 12, 14.5)
        ..close(),
      noorIconFill(color),
    );
  }

  @override
  bool shouldRepaint(covariant AzkarChildProtectionIconPainter old) => old.color != color;
}
