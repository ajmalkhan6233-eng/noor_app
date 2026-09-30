// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/constants/app_color_tokens.dart';
import 'package:noor/core/constants/app_color_tokens_emerald.dart';
import 'package:noor/core/constants/app_theme_emerald.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return ((la > lb ? la : lb) + 0.05) / ((la > lb ? lb : la) + 0.05);
}

void main() {
  const t = appColorTokensEmerald;

  test('locked palette values', () {
    expect(t.paper, const Color(0xFF0A1912));
    expect(t.card, const Color(0xFF132A20));
    expect(t.gold, const Color(0xFFD4AF37));
    expect(t.brightness, Brightness.dark);
  });

  test('text and accent meet WCAG AA on paper and card', () {
    for (final bg in [t.paper, t.card]) {
      expect(_contrast(t.ink, bg), greaterThanOrEqualTo(4.5));
      expect(_contrast(t.sage, bg), greaterThanOrEqualTo(4.5));
      expect(_contrast(t.gold, bg), greaterThanOrEqualTo(4.5));
    }
  });

  test('theme carries the emerald tokens and is dark', () {
    final theme = buildEmeraldTheme();
    expect(theme.extension<AppColorTokens>(), t);
    expect(theme.brightness, Brightness.dark);
  });
}
