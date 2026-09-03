// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The "turning page" 3D transform shared by both page-turn readers
// (paginated_surah_text.dart for one surah, paginated_full_quran_text
// .dart for the whole book) — extracted here once the second reader
// needed the identical animation, rather than duplicating it again.

import 'dart:math' as math;

import 'package:flutter/material.dart';

class PageTurnTransition extends StatelessWidget {
  const PageTurnTransition({
    super.key,
    required this.controller,
    required this.index,
    required this.child,
  });

  final PageController controller;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, animatedChild) {
        var offset = 0.0;
        if (controller.position.haveDimensions) {
          offset = (controller.page ?? index.toDouble()) - index;
        }
        return Transform(
          alignment: offset > 0 ? Alignment.centerLeft : Alignment.centerRight,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(offset * -0.6 * math.pi / 4),
          child: Opacity(opacity: (1 - offset.abs() * 0.4).clamp(0.5, 1.0), child: animatedChild),
        );
      },
      child: child,
    );
  }
}
