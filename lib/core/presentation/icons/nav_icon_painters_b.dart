// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Quran and Duas bottom-nav glyphs — split out of nav_icon_painters.dart
// to stay under this project's 150-line-per-file convention. Quran is
// a real open book (page curves, page edges, spine, bookmark ribbon)
// with a small "الله" mark on each page — the word itself, not a
// Quranic verse, so it doesn't need Tanzil-style source verification.
// Duas uses a crescent-and-light motif instead of raised hands, so it
// doesn't overlap visually with the separate Tasbih beads glyph.

import 'package:flutter/material.dart';

import 'noor_icon_style.dart';

class QuranIconPainter extends CustomPainter {
  QuranIconPainter(this.color, {this.active = true});
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    paintNavOrbBadge(canvas, active: active);

    final pageStroke = active ? const Color(0xFF00F2FE) : const Color(0xFF6B7C90);
    final pageFill = active ? const Color(0xFF164450) : const Color(0xFF101820);
    final leftPage = Path()
      ..moveTo(12, 8.2)
      ..quadraticBezierTo(7.3, 6.3, 4, 7.6)
      ..lineTo(4, 17.8)
      ..quadraticBezierTo(7.3, 16.3, 12, 18.2)
      ..close();
    final rightPage = Path()
      ..moveTo(12, 8.2)
      ..quadraticBezierTo(16.7, 6.3, 20, 7.6)
      ..lineTo(20, 17.8)
      ..quadraticBezierTo(16.7, 16.3, 12, 18.2)
      ..close();
    for (final page in [leftPage, rightPage]) {
      canvas.drawPath(page, noorIconFill(pageFill));
      canvas.drawPath(page, noorIconStroke(pageStroke, width: 1.1));
    }

    if (active) {
      canvas.drawLine(const Offset(4.7, 8.7), const Offset(4.7, 18), noorIconStroke(pageStroke.withValues(alpha: 0.5), width: 0.5));
      canvas.drawLine(const Offset(19.3, 8.7), const Offset(19.3, 18), noorIconStroke(pageStroke.withValues(alpha: 0.5), width: 0.5));
    }

    const spineRect = Rect.fromLTWH(11.1, 7.6, 1.8, 10.8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(spineRect, const Radius.circular(0.5)),
      Paint()
        ..shader = LinearGradient(
          colors: active
              ? const [Color(0xFFFFEFC2), Color(0xFFFFDD8C), Color(0xFFC98A00)]
              : const [Color(0xFF3A3020), Color(0xFF22201A)],
        ).createShader(spineRect),
    );

    if (active) {
      canvas.drawPath(
        Path()
          ..moveTo(13.5, 4.3)
          ..lineTo(13.5, 9.2)
          ..lineTo(12.2, 8.2)
          ..lineTo(10.9, 9.2)
          ..lineTo(10.9, 4.3)
          ..close(),
        noorIconFill(const Color(0xFFFFB703)),
      );
    }

    final textStyle = TextStyle(
      fontFamily: 'Arial',
      fontSize: 2.6,
      color: active ? const Color(0xFFD9F6FF) : const Color(0xFF6B7C90),
    );
    for (final dx in [8.2, 15.8]) {
      final painter = TextPainter(
        text: TextSpan(text: 'الله', style: textStyle),
        textDirection: TextDirection.rtl,
      )..layout();
      painter.paint(canvas, Offset(dx - painter.width / 2, 10.2));
    }
  }

  @override
  bool shouldRepaint(covariant QuranIconPainter old) => old.active != active;
}

/// A crescent cradling a small radiant light — dua as calling toward
/// light/guidance, tying into the app's own "noor" (light) name —
/// instead of a literal raised-hands or human figure.
class DuasIconPainter extends CustomPainter {
  DuasIconPainter(this.color, {this.active = true});
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    scaleToBox(canvas, size);
    paintNavOrbBadge(canvas, active: active);

    final crescent = Path()
      ..moveTo(16.2, 5.3)
      ..arcToPoint(const Offset(16.2, 18.7), radius: const Radius.circular(7.5), largeArc: true, clockwise: false)
      ..arcToPoint(const Offset(16.2, 5.3), radius: const Radius.circular(6), clockwise: true)
      ..close();
    canvas.drawPath(
      crescent,
      Paint()
        ..shader = const LinearGradient(colors: [Color(0xFFFFEFC2), Color(0xFFFFDD8C), Color(0xFFC98A00)])
            .createShader(const Rect.fromLTRB(8.7, 5.3, 16.2, 18.7)),
    );
    canvas.drawPath(
      crescent,
      noorIconStroke(active ? const Color(0xFF8A5A00) : const Color(0xFF6B7C90), width: 0.6),
    );

    final spark = Path()
      ..moveTo(9.5, 12)
      ..lineTo(10.2, 14)
      ..lineTo(12.2, 14.5)
      ..lineTo(10.2, 15)
      ..lineTo(9.5, 17)
      ..lineTo(8.8, 15)
      ..lineTo(6.8, 14.5)
      ..lineTo(8.8, 14)
      ..close();
    canvas.drawPath(
      spark,
      noorIconFill(active ? const Color(0xFFD9F6FF) : const Color(0xFF6B7C90)),
    );
    if (active) {
      canvas.drawPath(spark, noorIconStroke(const Color(0xFF00F2FE), width: 0.3));
      canvas.drawLine(const Offset(9.5, 9.6), const Offset(9.5, 8.4), noorIconStroke(const Color(0xFF00F2FE).withValues(alpha: 0.6), width: 0.4));
      canvas.drawLine(const Offset(5.6, 14.5), const Offset(4.4, 14.5), noorIconStroke(const Color(0xFF00F2FE).withValues(alpha: 0.6), width: 0.4));
    }
  }

  @override
  bool shouldRepaint(covariant DuasIconPainter old) => old.active != active;
}
