// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The "NOOR" wordmark shown once, at the end of the splash sequence,
// after the Bismillah dissolves into it — see big_bang_splash_view.dart.
// Not shown anywhere else: the persistent top bar deliberately dropped
// this same mark (2026-08-24 live-device review) since repeating it on
// every screen made it the dominant element site-wide. This is a
// splash-only widget, not a re-export of that removed one.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

class NoorSplashWordmark extends StatelessWidget {
  const NoorSplashWordmark({super.key, this.fontSize = 40});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'noor',
      child: ExcludeSemantics(
        child: Text(
          'NOOR',
          style: TextStyle(
            fontFamily: AppTypography.displayFamily,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 10,
            color: AppColors.gold,
          ),
        ),
      ),
    );
  }
}
