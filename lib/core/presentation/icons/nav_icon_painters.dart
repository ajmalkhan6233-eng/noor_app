// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The 5 bottom-nav glyphs. See noor_icon_type.dart for why these
// exist instead of Material icons.

import 'package:flutter/material.dart';

import 'noor_icon_style.dart';

class HomeIconPainter extends CustomPainter {
  HomeIconPainter(this.color);
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
    canvas.drawRect(const Rect.fromLTRB(6.5, 12, 17.5, 19.5), stroke);
    canvas.drawLine(const Offset(12, 19.5), const Offset(12, 15), stroke);
  }

  @override
  bool shouldRepaint(covariant HomeIconPainter old) => old.color != color;
}

/// A sundial — the classical prayer-time instrument — instead of a
/// generic wall clock, since this tab is specifically about the five
/// prayer times, not time in general.
class PrayerTimesIconPainter extends CustomPainter {
  PrayerTimesIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(4, 19), const Offset(20, 19), stroke);
    canvas.drawPath(
      Path()
        ..moveTo(8, 19)
        ..lineTo(15.5, 19)
        ..lineTo(8, 8)
        ..close(),
      stroke,
    );
    canvas.drawLine(const Offset(15.5, 19), const Offset(19, 15), stroke);
  }

  @override
  bool shouldRepaint(covariant PrayerTimesIconPainter old) => old.color != color;
}

class QuranIconPainter extends CustomPainter {
  QuranIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(12, 6), const Offset(12, 19), stroke);
    canvas.drawPath(
      Path()
        ..moveTo(12, 8)
        ..quadraticBezierTo(7, 6, 4, 7.5)
        ..lineTo(4, 18)
        ..quadraticBezierTo(7.5, 16.5, 12, 18.5),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(12, 8)
        ..quadraticBezierTo(17, 6, 20, 7.5)
        ..lineTo(20, 18)
        ..quadraticBezierTo(16.5, 16.5, 12, 18.5),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant QuranIconPainter old) => old.color != color;
}

/// Two raised palms — the dua gesture — rather than a generic seated
/// meditation figure.
class DuasIconPainter extends CustomPainter {
  DuasIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(11, 19)
        ..quadraticBezierTo(9, 15, 8.5, 10)
        ..quadraticBezierTo(8.3, 7, 6.5, 5.5),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(13, 19)
        ..quadraticBezierTo(15, 15, 15.5, 10)
        ..quadraticBezierTo(15.7, 7, 17.5, 5.5),
      stroke,
    );
    canvas.drawCircle(const Offset(12, 12.5), 1.1, noorIconFill(color));
  }

  @override
  bool shouldRepaint(covariant DuasIconPainter old) => old.color != color;
}

class MoreIconPainter extends CustomPainter {
  MoreIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final fill = noorIconFill(color);
    for (final dx in [6.0, 12.0, 18.0]) {
      canvas.drawCircle(Offset(dx, 12), 1.6, fill);
    }
  }

  @override
  bool shouldRepaint(covariant MoreIconPainter old) => old.color != color;
}
