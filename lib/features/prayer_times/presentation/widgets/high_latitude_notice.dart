// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Shown instead of prayer times whenever the repository returns
/// `HighLatitudeUnresolved` — never a guessed clock time.
class HighLatitudeNotice extends StatelessWidget {
  const HighLatitudeNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: AppStrings.highLatitudeUnresolvedMessage,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          AppStrings.highLatitudeUnresolvedMessage,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
