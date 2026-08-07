// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// الله rendered in Amiri, gold, with a genuine engraved effect: a
// dark shadow offset up-left (as if light isn't reaching that edge)
// and a soft light highlight offset down-right (catching the raised
// far edge), so it reads as pressed into the surface rather than
// sitting on top of it. Purely decorative — never wrapped in a
// tappable area, never overlapping other content.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

class AllahCalligraphy extends StatelessWidget {
  const AllahCalligraphy({super.key, this.fontSize = 32});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Allah',
      child: ExcludeSemantics(
        child: Text(
          'الله',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: AppTypography.arabicFamily,
            fontSize: fontSize,
            color: AppColors.gold,
            shadows: [
              Shadow(
                color: AppColors.paper.withValues(alpha: 0.85),
                offset: const Offset(-1.4, -1.4),
                blurRadius: 1.4,
              ),
              Shadow(
                color: Colors.white.withValues(alpha: 0.5),
                offset: const Offset(1.2, 1.2),
                blurRadius: 1.8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
