// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The "القبلة" (al-qiblah, "the Qibla") label arcing across the
// dial's inner ring, per the 2026-08-30 mockup. Rendered as a single,
// correctly-shaped Text — not warped letter-by-letter along the arc —
// deliberately: Arabic script needs contextual glyph shaping (each
// letter's joined/isolated form depends on its neighbours), and
// drawing codepoints individually along a path would break that
// shaping and render the wrong letterforms. This still sits in the
// dial's upper arc, tilted to suggest the curve, without risking a
// mis-shaped word for the sake of a literal per-letter warp.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';

class QiblaArabicLabel extends StatelessWidget {
  const QiblaArabicLabel({super.key, required this.color});

  final Color color;

  static const _text = 'القبلة';

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        _text,
        textDirection: TextDirection.rtl,
        style: AppTypography.arabic(color).copyWith(fontSize: 17, letterSpacing: 1),
      ),
    );
  }
}
