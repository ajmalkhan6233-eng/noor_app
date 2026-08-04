// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A calm, still, centred greeting on paper, with no animation beyond
// the parent's fade.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../widgets/allah_calligraphy.dart';

class PlainSplashView extends StatelessWidget {
  const PlainSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AllahCalligraphy(fontSize: 56),
            SizedBox(height: 24),
            Text(
              AppStrings.splashGreeting,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
