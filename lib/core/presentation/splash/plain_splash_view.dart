// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reduced-motion fallback: the Arabic Bismillah and the NOOR wordmark
// shown together, calm and still, with no animation beyond the
// parent's fade — a dissolve has no meaningful "settled" instant to
// jump to, so both are simply present at once instead.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_typography.dart';
import '../widgets/noor_splash_wordmark.dart';

class PlainSplashView extends StatelessWidget {
  const PlainSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: AppStrings.splashGreetingSemanticLabel,
              child: const ExcludeSemantics(
                child: Text(
                  AppStrings.splashGreeting,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.arabicFamily,
                    color: AppColors.gold,
                    fontSize: 26,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const NoorSplashWordmark(fontSize: 32),
          ],
        ),
      ),
    );
  }
}
