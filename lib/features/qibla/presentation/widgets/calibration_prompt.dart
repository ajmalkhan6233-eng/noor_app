// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_color_tokens.dart';

/// Shown whenever the compass is uncalibrated or its reported
/// accuracy is too low to trust, alongside a dimmed needle.
class CalibrationPrompt extends StatelessWidget {
  const CalibrationPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final message = AppLocalizations.of(context)!.qiblaCalibrationPromptMessage;
    return Semantics(
      liveRegion: true,
      label: message,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.gold),
        ),
      ),
    );
  }
}
