// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Maps each TimeOfDayGradientPhase to a LinearGradient built purely
// from the active AppColorTokens (paper/card/gold/accentSecondary) —
// no new hardcoded colors. Nebula-only by design: callers must gate
// on `context.colors.brightness == Brightness.dark` before using
// this, same rule as every other Nebula-only effect in this app.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../logic/time_of_day_gradient_phase.dart';

LinearGradient prayerHeroGradientFor(
  TimeOfDayGradientPhase phase,
  AppColorTokens colors,
) {
  final Color top;
  switch (phase) {
    case TimeOfDayGradientPhase.night:
      top = colors.card;
    case TimeOfDayGradientPhase.dawn:
      top = Color.alphaBlend(colors.gold.withValues(alpha: 0.16), colors.card);
    case TimeOfDayGradientPhase.day:
      top = Color.alphaBlend(colors.accentSecondary.withValues(alpha: 0.14), colors.card);
    case TimeOfDayGradientPhase.afternoon:
      top = Color.alphaBlend(colors.gold.withValues(alpha: 0.22), colors.card);
    case TimeOfDayGradientPhase.evening:
      top = Color.alphaBlend(colors.accentSecondary.withValues(alpha: 0.20), colors.card);
  }

  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [top, colors.paper],
  );
}
