// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Icons for the nine categories added 2026-09-01 with the full Hisnul
// Muslim import — see azkar_category.dart and
// azkar_supplementary_import_4.dart. Same 24x24 box / stroke-weight
// convention as azkar_category_icon_painters_a/b.dart.

import 'package:flutter/material.dart';

import '../../../../core/presentation/icons/noor_icon_style.dart';

/// Purification — a water droplet.
class AzkarPurificationIconPainter extends CustomPainter {
  AzkarPurificationIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(12, 3.5)
        ..cubicTo(16, 9, 19, 13, 19, 16.5)
        ..cubicTo(19, 20, 16, 21.5, 12, 21.5)
        ..cubicTo(8, 21.5, 5, 20, 5, 16.5)
        ..cubicTo(5, 13, 8, 9, 12, 3.5)
        ..close(),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant AzkarPurificationIconPainter old) => old.color != color;
}

/// During prayer — a small figure in rukū' (bowing).
class AzkarDuringPrayerIconPainter extends CustomPainter {
  AzkarDuringPrayerIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawCircle(const Offset(16, 6), 1.6, stroke);
    canvas.drawPath(
      Path()
        ..moveTo(16, 8)
        ..lineTo(10, 11)
        ..lineTo(6, 11),
      stroke,
    );
    canvas.drawLine(const Offset(10, 11), const Offset(12, 16), stroke);
    canvas.drawLine(const Offset(12, 16), const Offset(8, 20), stroke);
    canvas.drawLine(const Offset(12, 16), const Offset(16, 19), stroke);
    canvas.drawLine(const Offset(4, 21), const Offset(20, 21), stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarDuringPrayerIconPainter old) => old.color != color;
}

/// Death & funeral — a headstone arch (distinct from the plain
/// rounded-top marker used for [AzkarVisitingGraveIconPainter]).
class AzkarDeathAndFuneralIconPainter extends CustomPainter {
  AzkarDeathAndFuneralIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(7, 20)
        ..lineTo(7, 11)
        ..arcToPoint(const Offset(17, 11), radius: const Radius.circular(5))
        ..lineTo(17, 20)
        ..close(),
      stroke,
    );
    canvas.drawLine(const Offset(4, 20), const Offset(20, 20), stroke);
    canvas.drawLine(const Offset(12, 13), const Offset(12, 17), stroke);
    canvas.drawLine(const Offset(10, 15), const Offset(14, 15), stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarDeathAndFuneralIconPainter old) => old.color != color;
}

/// Weather & nature — a raincloud.
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
        ..cubicTo(4, 15, 3, 11.5, 6, 11)
        ..cubicTo(6.3, 8, 10.7, 7.4, 12, 9.5)
        ..cubicTo(16.5, 8.5, 18.5, 13, 15.5, 15)
        ..close(),
      stroke,
    );
    for (final dx in [9.0, 12.5, 16.0]) {
      canvas.drawLine(Offset(dx, 17), Offset(dx - 1.4, 20.5), stroke);
    }
  }

  @override
  bool shouldRepaint(covariant AzkarWeatherIconPainter old) => old.color != color;
}

/// Eating & fasting — a crescent moon over a plate.
class AzkarEatingAndFastingIconPainter extends CustomPainter {
  AzkarEatingAndFastingIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawOval(const Rect.fromLTWH(4, 15, 16, 5), stroke);
    canvas.drawPath(
      Path()
        ..moveTo(15, 4.5)
        ..arcToPoint(const Offset(15, 12.5), radius: const Radius.circular(4), clockwise: false)
        ..arcToPoint(const Offset(15, 4.5), radius: const Radius.circular(5.4), clockwise: true),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant AzkarEatingAndFastingIconPainter old) => old.color != color;
}

/// Daily life & manners — a handshake (two overlapping curved arms).
class AzkarDailyLifeIconPainter extends CustomPainter {
  AzkarDailyLifeIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawPath(
      Path()
        ..moveTo(3.5, 12)
        ..lineTo(8, 12)
        ..lineTo(12, 15.5)
        ..lineTo(9.5, 17.5)
        ..lineTo(6, 14.5),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(20.5, 12)
        ..lineTo(16, 12)
        ..lineTo(12, 15.5)
        ..lineTo(14.5, 17.5)
        ..lineTo(18, 14.5),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant AzkarDailyLifeIconPainter old) => old.color != color;
}

/// Hajj & Umrah — the Kaaba, a simple draped cube.
class AzkarHajjUmrahIconPainter extends CustomPainter {
  AzkarHajjUmrahIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawRect(const Rect.fromLTWH(6, 8, 12, 11), stroke);
    canvas.drawLine(const Offset(6, 11.5), const Offset(18, 11.5), stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarHajjUmrahIconPainter old) => old.color != color;
}

/// Remembrance of Allah — prayer beads (a small loop of circles).
class AzkarRemembranceIconPainter extends CustomPainter {
  AzkarRemembranceIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    const positions = [
      Offset(12, 4.5), Offset(17, 7), Offset(19, 12), Offset(17, 17),
      Offset(12, 19.5), Offset(7, 17), Offset(5, 12), Offset(7, 7),
    ];
    for (final p in positions) {
      canvas.drawCircle(p, 1.4, stroke);
    }
    canvas.drawLine(const Offset(12, 19.5), const Offset(12, 23), stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarRemembranceIconPainter old) => old.color != color;
}

/// Everyday moments — a small sparkle/star burst.
class AzkarEverydayMomentsIconPainter extends CustomPainter {
  AzkarEverydayMomentsIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    final stroke = noorIconStroke(color);
    canvas.drawLine(const Offset(12, 3), const Offset(12, 10), stroke);
    canvas.drawLine(const Offset(12, 14), const Offset(12, 21), stroke);
    canvas.drawLine(const Offset(3, 12), const Offset(10, 12), stroke);
    canvas.drawLine(const Offset(14, 12), const Offset(21, 12), stroke);
    canvas.drawCircle(const Offset(12, 12), 2.2, stroke);
  }

  @override
  bool shouldRepaint(covariant AzkarEverydayMomentsIconPainter old) => old.color != color;
}
