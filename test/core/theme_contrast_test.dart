// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Programmatic WCAG contrast check for all four themes. Body text
// (ink, sage) must reach 4.5:1 on both paper and card. The accent
// (`gold`) is checked and printed, but only enforced where the design
// uses it as text colour with a safe margin (see docs/NEEDS_DECISION.md
// for the Dawn accent).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/constants/app_color_tokens.dart';
import 'package:noor/core/constants/app_color_tokens_emerald.dart';
import 'package:noor/core/constants/app_color_tokens_mushaf.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return ((la > lb ? la : lb) + 0.05) / ((la > lb ? lb : la) + 0.05);
}

final _themes = <String, AppColorTokens>{
  'Nebula': AppColorTokens.cosmic,
  'Dawn': AppColorTokens.light,
  'Emerald Night': appColorTokensEmerald,
  'Mushaf': appColorTokensMushaf,
};

void main() {
  for (final entry in _themes.entries) {
    final t = entry.value;
    test('${entry.key}: ink and sage reach 4.5:1 on paper and card', () {
      for (final bg in [t.paper, t.card]) {
        expect(contrast(t.ink, bg), greaterThanOrEqualTo(4.5), reason: '${entry.key} ink');
        expect(contrast(t.sage, bg), greaterThanOrEqualTo(4.5), reason: '${entry.key} sage');
      }
    });

    test('${entry.key}: accent contrast is reported', () {
      // ignore: avoid_print
      print(
        '${entry.key}: ink ${contrast(t.ink, t.paper).toStringAsFixed(2)} '
        'sage ${contrast(t.sage, t.paper).toStringAsFixed(2)} '
        'gold ${contrast(t.gold, t.paper).toStringAsFixed(2)} '
        'gold-on-card ${contrast(t.gold, t.card).toStringAsFixed(2)} '
        'paper-on-gold ${contrast(t.paper, t.gold).toStringAsFixed(2)}',
      );
    });
  }

  test('Nebula, Emerald Night and Mushaf accents reach 4.5:1 on paper', () {
    for (final name in ['Nebula', 'Emerald Night', 'Mushaf']) {
      final t = _themes[name]!;
      expect(contrast(t.gold, t.paper), greaterThanOrEqualTo(4.5), reason: name);
    }
  });
}
