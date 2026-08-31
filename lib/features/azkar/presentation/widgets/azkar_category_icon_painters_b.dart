// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Continued from azkar_category_icon_painters_a.dart — G–K.

import 'package:flutter/material.dart';

import '../../../../core/presentation/icons/noor_icon_style.dart';

/// Illness — a pulse/heartbeat line.
class AzkarIllnessIconPainter extends CustomPainter {
  AzkarIllnessIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(3, 12)
        ..lineTo(8, 12)
        ..lineTo(10, 6)
        ..lineTo(13.5, 18)
        ..lineTo(16, 12)
        ..lineTo(21, 12),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant AzkarIllnessIconPainter old) => old.color != color;
}

/// Distress — a storm cloud, hardship passing overhead.
class AzkarDistressIconPainter extends CustomPainter {
  AzkarDistressIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(6, 14)
        ..cubicTo(3.5, 14, 3.5, 10.2, 6.2, 10.3)
        ..cubicTo(6.6, 7.6, 10.6, 7.3, 11.6, 9.6)
        ..cubicTo(13.6, 8.6, 16.2, 10, 15.7, 12.2)
        ..cubicTo(18.6, 12.3, 18.4, 16, 15.5, 16)
        ..lineTo(6, 16)
        ..close(),
      stroke,
    );
    canvas.drawLine(const Offset(9, 18), const Offset(8, 21), stroke);
    canvas.drawLine(const Offset(13, 18), const Offset(12, 21), stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarDistressIconPainter old) => old.color != color;
}

/// Debt — a receipt/scroll with a line item, distinct from Zakat's scale.
class AzkarDebtIconPainter extends CustomPainter {
  AzkarDebtIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(6, 4)
        ..lineTo(18, 4)
        ..lineTo(18, 20)
        ..lineTo(15, 18)
        ..lineTo(12, 20)
        ..lineTo(9, 18)
        ..lineTo(6, 20)
        ..close(),
      stroke,
    );
    canvas.drawLine(const Offset(9, 9), const Offset(15, 9), stroke);
    canvas.drawLine(const Offset(9, 13), const Offset(13, 13), stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarDebtIconPainter old) => old.color != color;
}

/// Visiting the grave — a simple headstone.
class AzkarVisitingGraveIconPainter extends CustomPainter {
  AzkarVisitingGraveIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(3, 20), const Offset(21, 20), stroke);
    canvas.drawPath(
      Path()
        ..moveTo(7, 20)
        ..lineTo(7, 11)
        ..arcToPoint(const Offset(17, 11), radius: const Radius.circular(5))
        ..lineTo(17, 20),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant AzkarVisitingGraveIconPainter old) => old.color != color;
}

/// Visiting the sick — an open hand offering care.
class AzkarVisitingSickIconPainter extends CustomPainter {
  AzkarVisitingSickIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(5, 15)
        ..cubicTo(5, 19, 8.5, 21, 12, 21)
        ..cubicTo(15.5, 21, 18, 19, 18, 16)
        ..lineTo(18, 12.5)
        ..cubicTo(18, 11.5, 16.5, 11.5, 16.5, 12.5)
        ..lineTo(16.5, 14.5),
      stroke,
    );
    canvas.drawLine(const Offset(5, 15), const Offset(5, 10), stroke);
    for (final dx in [7.5, 10.0, 12.5]) {
      canvas.drawLine(Offset(dx, 14), Offset(dx, 9), stroke);
    }
    canvas.drawLine(const Offset(11, 4.5), const Offset(11, 7.5), noorIconStroke(color, width: 1.4));
    canvas.drawLine(const Offset(9.5, 6), const Offset(12.5, 6), noorIconStroke(color, width: 1.4));
  }

  @override
  bool shouldRepaint(covariant AzkarVisitingSickIconPainter old) => old.color != color;
}
