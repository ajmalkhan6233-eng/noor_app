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

/// Test pass (2026-09-11): clean, minimal gold-line aesthetic instead of
/// the shared glossy orb badge — matches the launcher icon's line-art
/// feel on dark surfaces. Scoped to Home only; the other 4 bottom-nav
/// glyphs still use [paintNavOrbBadge] and are untouched pending review.
class HomeIconPainter extends CustomPainter {
  HomeIconPainter(this.color, {this.active = true});
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);

    final stroke = noorIconStroke(color, width: active ? 1.7 : 1.4);

    final roofPath = Path()
      ..moveTo(4, 12.5)
      ..lineTo(12, 5)
      ..lineTo(20, 12.5);
    canvas.drawPath(roofPath, stroke);

    const wallRect = Rect.fromLTRB(7, 12.5, 17, 19.5);
    canvas.drawRect(wallRect, stroke);

    const doorRect = Rect.fromLTWH(10.2, 14.8, 3.6, 4.7);
    canvas.drawRect(doorRect, noorIconStroke(color, width: active ? 1.3 : 1.1));
  }

  @override
  bool shouldRepaint(covariant HomeIconPainter old) => old.active != active || old.color != color;
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

