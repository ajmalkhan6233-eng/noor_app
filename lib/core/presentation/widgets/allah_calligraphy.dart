// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// الله rendered in Amiri, gold, with a genuine embossed effect: a
// light highlight offset up-left and a soft dark shadow offset
// down-right, so it reads as raised from the paper. Purely
// decorative — never wrapped in a tappable area, never overlapping
// other content.

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
                color: Colors.white.withValues(alpha: 0.85),
                offset: const Offset(-1, -1),
                blurRadius: 0.6,
              ),
              Shadow(
                color: AppColors.ink.withValues(alpha: 0.4),
                offset: const Offset(1.2, 1.4),
                blurRadius: 2.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
