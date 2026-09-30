// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/constants/app_color_tokens.dart';
import 'package:noor/core/constants/app_color_tokens_mushaf.dart';
import 'package:noor/core/constants/app_theme_mushaf.dart';
import 'package:noor/features/settings/data/app_theme_mode.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  const t = appColorTokensMushaf;

  test('body text and accent meet WCAG AA on paper and card', () {
    for (final bg in [t.paper, t.card]) {
      expect(_contrast(t.ink, bg), greaterThanOrEqualTo(4.5));
      expect(_contrast(t.sage, bg), greaterThanOrEqualTo(4.5));
      expect(_contrast(t.gold, bg), greaterThanOrEqualTo(4.5));
    }
    expect(_contrast(t.paper, t.gold), greaterThanOrEqualTo(4.5));
    // Large headings only need 3:1.
    expect(_contrast(t.goldMuted, t.paper), greaterThanOrEqualTo(3.0));
  });

  test('is a flat, square, light theme with Cormorant headings', () {
    final theme = buildMushafTheme();
    expect(t.brightness, Brightness.light);
    expect(t.cornerRadius, lessThanOrEqualTo(2));
    expect(t.flatSurfaces, isTrue);
    expect(theme.extension<AppColorTokens>(), t);
    expect(theme.cardTheme.elevation, 0);
    expect(theme.textTheme.titleLarge!.fontFamily, 'Cormorant Garamond');
    expect(theme.appBarTheme.titleTextStyle!.fontFamily, 'Cormorant Garamond');
    expect(theme.textTheme.bodyMedium!.fontFamily, 'Inter');
  });

  test('existing themes keep their 20px radius and shadows', () {
    expect(AppColorTokens.cosmic.cornerRadius, 20);
    expect(AppColorTokens.light.flatSurfaces, isFalse);
  });

  test('persists by name so older rows still load', () {
    expect(AppThemeModeOption.values.byName('mushaf'), AppThemeModeOption.mushaf);
    expect(AppThemeModeOption.values.byName('dark'), AppThemeModeOption.dark);
  });
}
