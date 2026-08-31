// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Restyled 2026-08-30 as a compact status pill rather than a full-
// width text block — FR-9's honest low-accuracy warning stays intact
// (still shown/hidden by AnimatedCalibrationBanner, never a screen-
// blocking modal), just visually smaller so it reads as a status
// chip, matching the new compass dial's overall compactness.

import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_color_tokens.dart';

/// Shown whenever the compass is uncalibrated or its reported
/// accuracy is too low to trust, alongside a dimmed needle.
class CalibrationPrompt extends StatelessWidget {
  const CalibrationPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final message = AppLocalizations.of(context)!.qiblaCalibrationPromptMessage;
    return Semantics(
      liveRegion: true,
      label: message,
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colors.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.gold.withValues(alpha: 0.35)),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.gold, fontSize: 12.5),
          ),
        ),
      ),
    );
  }
}
