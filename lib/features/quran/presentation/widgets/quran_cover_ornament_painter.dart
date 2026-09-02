// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Purely decorative geometric frame for QuranCoverScreen — a nested
// gold/cyan rounded-rectangle border, evoking a Mus'haf cover without
// any bundled image asset (none exists in this project; every visual
// here is hand-drawn, see noor-icon-generation). Static — painted
// once, no animation, no per-frame cost.

import 'package:flutter/material.dart';

class QuranCoverOrnamentPainter extends CustomPainter {
  const QuranCoverOrnamentPainter({required this.gold, required this.cyan});

  final Color gold;
  final Color cyan;

  @override
  void paint(Canvas canvas, Size size) {
    final outer = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(18),
    );
    canvas.drawRRect(
      outer,
      Paint()
        ..color = gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    const inset = 10.0;
    final inner = RRect.fromRectAndRadius(
      const Offset(inset, inset) & Size(size.width - inset * 2, size.height - inset * 2),
      const Radius.circular(10),
    );
    canvas.drawRRect(
      inner,
      Paint()
        ..color = cyan.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant QuranCoverOrnamentPainter oldDelegate) =>
      oldDelegate.gold != gold || oldDelegate.cyan != cyan;
}
