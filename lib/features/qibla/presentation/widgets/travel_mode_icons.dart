// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The three small stroke icons above the route card's travel-estimate
// columns — same 24x24-box CustomPainter convention as the app's main
// nav/More icon set (see core/presentation/icons/), not Material
// icons, so these match the rest of the app's hand-drawn line-art
// language instead of reading as a stock glyph set.

import 'package:flutter/material.dart';

import '../../../../core/presentation/icons/noor_icon_style.dart';

class FlyingIconPainter extends CustomPainter {
  FlyingIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    canvas.drawPath(
      Path()
        ..moveTo(3, 19)
        ..lineTo(21, 11)
        ..lineTo(3, 3)
        ..lineTo(3, 10)
        ..lineTo(15, 11)
        ..lineTo(3, 12)
        ..close(),
      noorIconFill(color),
    );
  }

  @override
  bool shouldRepaint(covariant FlyingIconPainter old) => old.color != color;
}

/// A simple two-hump camel silhouette, walking left to right.
class CamelIconPainter extends CustomPainter {
  CamelIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color, width: 1.5);
    canvas.drawPath(
      Path()
        ..moveTo(2, 19)
        ..lineTo(3.5, 12)
        ..quadraticBezierTo(5, 7, 7.5, 9.5)
        ..quadraticBezierTo(9, 11, 8.3, 13)
        ..quadraticBezierTo(11, 8.5, 13.5, 9.5)
        ..quadraticBezierTo(15.5, 10.3, 14.7, 12.5)
        ..quadraticBezierTo(17.5, 8.5, 20, 10)
        ..quadraticBezierTo(21.5, 11, 20.5, 13)
        ..lineTo(22, 19),
      stroke,
    );
    canvas.drawLine(const Offset(5.5, 19), const Offset(5.5, 15.5), stroke);
    canvas.drawLine(const Offset(9, 19), const Offset(9, 15.5), stroke);
    canvas.drawLine(const Offset(17.5, 19), const Offset(17.5, 15.5), stroke);
    canvas.drawLine(const Offset(20.5, 19), const Offset(20.5, 15.5), stroke);
    canvas.drawLine(const Offset(19.5, 10), const Offset(23, 6), stroke);
    canvas.drawLine(const Offset(23, 6), const Offset(24, 8.5), stroke);
    canvas.drawLine(const Offset(21.5, 11), const Offset(24.5, 9), stroke);
  }

  @override
  bool shouldRepaint(covariant CamelIconPainter old) => old.color != color;
}

/// A simple walking-figure stick silhouette, mid-stride.
class WalkingIconPainter extends CustomPainter {
  WalkingIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color, width: 1.8);
    canvas.drawCircle(const Offset(14, 4), 2, noorIconFill(color));
    canvas.drawPath(
      Path()
        ..moveTo(14, 6)
        ..lineTo(11, 13)
        ..lineTo(14, 15)
        ..lineTo(13, 21),
      stroke,
    );
    canvas.drawLine(const Offset(14, 15), const Offset(18, 19), stroke);
    canvas.drawLine(const Offset(11, 13), const Offset(7, 15), stroke);
    canvas.drawLine(const Offset(14, 6), const Offset(9, 9), stroke);
  }

  @override
  bool shouldRepaint(covariant WalkingIconPainter old) => old.color != color;
}
