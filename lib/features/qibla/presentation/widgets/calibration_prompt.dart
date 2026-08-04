// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Shown whenever the compass is uncalibrated or its reported
/// accuracy is too low to trust, alongside a dimmed needle.
class CalibrationPrompt extends StatelessWidget {
  const CalibrationPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: AppStrings.qiblaCalibrationPromptMessage,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          AppStrings.qiblaCalibrationPromptMessage,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.gold),
        ),
      ),
    );
  }
}
