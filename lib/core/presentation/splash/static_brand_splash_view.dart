// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The launch screen (2026-11-19, Aj's decision): Bismillah and the Noor
// wordmark, still, no animation, shown for a fraction of a second.
// The Bismillah string is AppStrings.splashGreeting (identical to
// Tanzil 1:1, checked by test), never retyped here.

import 'package:flutter/material.dart';

import '../../constants/app_color_tokens.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_typography.dart';
import '../widgets/noor_splash_wordmark.dart';

class StaticBrandSplashView extends StatelessWidget {
  const StaticBrandSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.splashGreeting,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTypography.arabic(context.colors.gold, size: 26, height: 1.6),
          ),
          const SizedBox(height: 16),
          const NoorSplashWordmark(fontSize: AppTypography.brandSize),
        ],
      ),
    );
  }
}
