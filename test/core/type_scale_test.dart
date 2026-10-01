// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One type scale. Fails if a numeric fontSize sneaks in outside the
// typography file, and checks that titles and section headings have
// identical sizes in all four themes (only the Mushaf typeface differs).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/constants/app_typography.dart';
import 'package:noor/core/presentation/widgets/glow_hero_title.dart';
import 'package:noor/core/presentation/widgets/section_header.dart';

import '../helpers/theme_harness.dart';

void main() {
  test('no numeric fontSize literal anywhere in lib/ outside app_typography.dart', () {
    final offenders = <String>[];
    final literal = RegExp(r'fontSize:\s*\(?\s*\d|fontSize\s*\?\?\s*\d');
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path.replaceAll('\\', '/');
      if (path.endsWith('core/constants/app_typography.dart') || path.contains('/generated/')) continue;
      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].trimLeft().startsWith('//')) continue;
        if (literal.hasMatch(lines[i])) offenders.add('$path:${i + 1}: ${lines[i].trim()}');
      }
    }
    expect(offenders, isEmpty, reason: 'use AppTypography sizes:\n${offenders.join('\n')}');
  });

  test('the scale is ordered and uses the agreed sizes', () {
    expect(AppTypography.displaySize, 44);
    expect(AppTypography.titleSize, 28);
    expect(AppTypography.timeLargeSize, 22);
    expect(AppTypography.timeSmallSize, 16);
    expect(AppTypography.bodySize, 15);
    expect(AppTypography.sectionSize, 13);
    expect(AppTypography.captionSize, 12);
    expect(AppTypography.displaySize, greaterThan(AppTypography.titleSize));
    expect(AppTypography.titleSize, greaterThan(AppTypography.timeLargeSize));
    expect(AppTypography.timeLargeSize, greaterThan(AppTypography.timeSmallSize));
    expect(AppTypography.timeSmallSize, greaterThan(AppTypography.bodySize));
    expect(AppTypography.bodySize, greaterThan(AppTypography.sectionSize));
    expect(AppTypography.sectionSize, greaterThan(AppTypography.captionSize));
  });

  test('prayer time rows use one style: timeSmall everywhere', () {
    final style = AppTypography.timeSmall(Colors.black);
    expect(style.fontSize, AppTypography.timeSmallSize);
    expect(AppTypography.time(Colors.black).fontSize, style.fontSize, reason: 'old name is the same style');
  });

  for (final theme in allThemes.entries) {
    testWidgets('${theme.key}: app bar title, big title and section heading sizes are identical', (tester) async {
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            appBar: AppBar(title: const Text('Title')),
            body: const Column(
              children: [
                GlowHeroTitle('Big title', color: Colors.amber),
                SectionHeader('Heading'),
              ],
            ),
          ),
          theme.value(),
        ),
      );
      await tester.pump();

      final appBarStyle = tester.widget<DefaultTextStyle>(
        find.ancestor(of: find.text('Title'), matching: find.byType(DefaultTextStyle)).first,
      ).style;
      final bigTitle = tester.widget<Text>(find.text('Big title')).style!;
      final section = tester.widget<Text>(find.text('HEADING')).style!;

      expect(appBarStyle.fontSize, AppTypography.titleSize);
      expect(bigTitle.fontSize, AppTypography.titleSize);
      expect(section.fontSize, AppTypography.sectionSize);

      final heading = theme.key == 'Mushaf' ? 'Cormorant Garamond' : null;
      expect(bigTitle.fontFamily, heading);
      expect(section.fontFamily, heading);
    });
  }
}
