// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The 5 bottom-nav glyphs. Each sits inside the shared glossy "orb"
// badge from noor_icon_style.dart (paintNavOrbBadge) so all five read
// as one dimensional family instead of flat line icons. Home and
// Prayer live here; More lives in nav_icon_painters_more.dart, Quran
// and Duas live in nav_icon_painters_b.dart — split to stay under
// this project's 150-line-per-file convention.

import 'package:flutter/material.dart';

import 'noor_icon_style.dart';

class HomeIconPainter extends CustomPainter {
  HomeIconPainter(this.color, {this.active = true});
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    paintNavOrbBadge(canvas, active: active);

    const wallRect = Rect.fromLTRB(6.5, 12, 18, 19.5);
    canvas.drawRect(
      wallRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: active
              ? const [Color(0xFF1A3A45), Color(0xFF081821)]
              : const [Color(0xFF101820), Color(0xFF0B1116)],
        ).createShader(wallRect),
    );
    canvas.drawRect(
      wallRect,
      noorIconStroke(active ? const Color(0xFF00F2FE) : const Color(0xFF6B7C90), width: 1.3),
    );

    final roofPath = Path()
      ..moveTo(3.5, 12.5)
      ..lineTo(12, 4.5)
      ..lineTo(20.5, 12.5)
      ..lineTo(18, 12.5)
      ..lineTo(12, 7)
      ..lineTo(6, 12.5)
      ..close();
    const roofRect = Rect.fromLTRB(3.5, 4.5, 20.5, 12.5);
    canvas.drawPath(
      roofPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: active
              ? const [Color(0xFFFFDD8C), Color(0xFFC98A00)]
              : const [Color(0xFF3A3020), Color(0xFF22201A)],
        ).createShader(roofRect),
    );
    canvas.drawPath(
      roofPath,
      noorIconStroke(active ? const Color(0xFF8A5A00) : const Color(0xFF6B7C90), width: 0.7),
    );
    if (active) {
      canvas.drawLine(
        const Offset(5.5, 9.5),
        const Offset(12, 5.2),
        noorIconStroke(const Color(0xFFFFF3D6).withValues(alpha: 0.6), width: 0.9),
      );
    }

    const doorRect = Rect.fromLTWH(9.8, 14.5, 4.4, 5);
    final doorRRect = RRect.fromRectAndRadius(doorRect, const Radius.circular(0.3));
    canvas.drawRRect(
      doorRRect,
      Paint()
        ..shader = LinearGradient(
          colors: active
              ? const [Color(0xFFB87A00), Color(0xFF7A5000)]
              : const [Color(0xFF22201A), Color(0xFF1C1A14)],
        ).createShader(doorRect),
    );
    canvas.drawRRect(
      doorRRect,
      noorIconStroke(active ? const Color(0xFF5A3B00) : const Color(0xFF6B7C90), width: 0.6),
    );
    if (active) {
      canvas.drawCircle(const Offset(13.4, 17), 0.4, noorIconFill(const Color(0xFFFFE9B0)));
    }
  }

  @override
  bool shouldRepaint(covariant HomeIconPainter old) => old.active != active;
}

/// A sundial — the classical prayer-time instrument — instead of a
/// generic wall clock, since this tab is specifically about the five
/// prayer times, not time in general.
class PrayerTimesIconPainter extends CustomPainter {
  PrayerTimesIconPainter(this.color, {this.active = true});
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    paintNavOrbBadge(canvas, active: active);

    const dialRect = Rect.fromLTRB(4, 17.4, 20, 20.6);
    canvas.drawOval(
      dialRect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.2, -0.3),
          colors: active
              ? const [Color(0xFF345C69), Color(0xFF1B3944), Color(0xFF081821)]
              : const [Color(0xFF141F27), Color(0xFF0B1116)],
        ).createShader(dialRect),
    );
    canvas.drawOval(dialRect, noorIconStroke(active ? const Color(0xFF00F2FE) : const Color(0xFF6B7C90), width: 1.1));

    final tickColor = active ? const Color(0xFF00F2FE).withValues(alpha: 0.65) : const Color(0xFF6B7C90);
    for (final tick in [
      [const Offset(5.3, 19), const Offset(5.7, 18.1)],
      [const Offset(7.3, 18.7), const Offset(7.7, 17.3)],
      [const Offset(16.7, 18.7), const Offset(16.3, 17.3)],
      [const Offset(18.7, 19), const Offset(18.3, 18.1)],
    ]) {
      canvas.drawLine(tick[0], tick[1], noorIconStroke(tickColor, width: 0.7));
    }

    final gnomonPath = Path()
      ..moveTo(10.4, 19)
      ..lineTo(11.8, 19)
      ..lineTo(11.2, 6.5)
      ..close();
    const gnomonRect = Rect.fromLTRB(10.4, 6.5, 11.8, 19);
    canvas.drawPath(
      gnomonPath,
      Paint()
        ..shader = LinearGradient(
          colors: active
              ? const [Color(0xFFFFEFC2), Color(0xFFC98A00)]
              : const [Color(0xFF3A3020), Color(0xFF22201A)],
        ).createShader(gnomonRect),
    );
    canvas.drawPath(gnomonPath, noorIconStroke(active ? const Color(0xFF8A5A00) : const Color(0xFF6B7C90), width: 0.5));

    if (active) {
      canvas.drawLine(
        const Offset(11.3, 8.5),
        const Offset(16.3, 18.3),
        noorIconStroke(Colors.black.withValues(alpha: 0.35), width: 0.9),
      );
      canvas.drawCircle(const Offset(11.25, 7.2), 0.3, noorIconFill(const Color(0xFFFFF3D6)));
    }
  }

  @override
  bool shouldRepaint(covariant PrayerTimesIconPainter old) => old.active != active;
}

