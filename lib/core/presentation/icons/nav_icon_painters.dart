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

/// Reverted to the shared glossy orb-badge treatment (2026-09-13) — the
/// 2026-09-11 gold-line test pass stays on the other 4 bottom-nav
/// glyphs, but Home goes back to [paintNavOrbBadge] per direct request.
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
///
/// Clean, minimal gold-line aesthetic (2026-09-11) — same treatment as
/// [HomeIconPainter]: no orb badge, no fills/gradients, just [color]
/// strokes at matching weights, so the bottom-nav set reads as one
/// consistent family.
class PrayerTimesIconPainter extends CustomPainter {
  PrayerTimesIconPainter(this.color, {this.active = true});
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);

    final stroke = noorIconStroke(color, width: active ? 1.7 : 1.4);
    final thinStroke = noorIconStroke(color, width: active ? 1.3 : 1.1);

    const dialRect = Rect.fromLTRB(4, 16.5, 20, 19.5);
    canvas.drawOval(dialRect, stroke);

    final gnomonPath = Path()
      ..moveTo(10.6, 18)
      ..lineTo(11.6, 18)
      ..lineTo(12, 5.2)
      ..lineTo(10.2, 8.5)
      ..moveTo(11.6, 18)
      ..lineTo(12, 5.2);
    canvas.drawPath(gnomonPath, thinStroke);

    for (final tick in [
      [const Offset(5.6, 17.9), const Offset(6.1, 17)],
      [const Offset(18.4, 17.9), const Offset(17.9, 17)],
    ]) {
      canvas.drawLine(tick[0], tick[1], thinStroke);
    }
  }

  @override
  bool shouldRepaint(covariant PrayerTimesIconPainter old) => old.active != active || old.color != color;
}

