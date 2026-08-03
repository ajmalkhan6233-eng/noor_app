// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Fallback shown when `SplashConfig.cosmicEnabled` is false: a plain,
// still, centred greeting with no animation beyond the parent's fade.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';

/// Static centred greeting, used when the cosmic sequence is disabled.
class PlainSplashView extends StatelessWidget {
  const PlainSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          AppStrings.splashGreeting,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.accent,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
