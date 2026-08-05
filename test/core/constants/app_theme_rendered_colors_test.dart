// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Dumps the ACTUAL live theme values Flutter resolves at runtime for
// a real pumped widget tree — not the AppColors source constants read
// directly. Material 3's ColorScheme/surfaceTint machinery is exactly
// the kind of thing that can silently shift a rendered colour away
// from its source value, so this goes through Theme.of(context) and
// the real Scaffold/Card/AppBar objects Flutter actually built.
// (A true pixel-level dump via RenderRepaintBoundary.toImage() was
// tried first, but hangs indefinitely in this sandbox's headless
// flutter_tester — software-rendering GPU readback appears
// unsupported here.)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/constants/app_theme.dart';

String _hex(Color c) =>
    '#${(c.a * 255).round().toRadixString(16).padLeft(2, '0')}'
    '${(c.r * 255).round().toRadixString(16).padLeft(2, '0')}'
    '${(c.g * 255).round().toRadixString(16).padLeft(2, '0')}'
    '${(c.b * 255).round().toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();

void main() {
  testWidgets('live theme resolves scaffold background to exactly #FFF2EFE7', (
    tester,
  ) async {
    late Color resolved;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Builder(
          builder: (context) {
            resolved = Theme.of(context).scaffoldBackgroundColor;
            return const Scaffold();
          },
        ),
      ),
    );

    expect(_hex(resolved), '#FFF2EFE7');
  });

  testWidgets('live theme resolves card colour to exactly #FFFFFFFF, no tint', (
    tester,
  ) async {
    late Color cardColor;
    late Color surfaceTint;
    late Color colorSchemeSurface;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Builder(
          builder: (context) {
            final theme = Theme.of(context);
            cardColor = theme.cardColor;
            surfaceTint = theme.colorScheme.surfaceTint;
            colorSchemeSurface = theme.colorScheme.surface;
            return const Scaffold();
          },
        ),
      ),
    );

    expect(_hex(cardColor), '#FFFFFFFF');
    expect(_hex(colorSchemeSurface), '#FFFFFFFF');
    expect(surfaceTint, Colors.transparent, reason: 'M3 must not auto-tint cards green');
  });

  testWidgets('live theme resolves primary text colour to exactly #FF16211C', (
    tester,
  ) async {
    late Color inkColor;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Builder(
          builder: (context) {
            inkColor = Theme.of(context).textTheme.bodyMedium!.color!;
            return const Scaffold();
          },
        ),
      ),
    );

    expect(_hex(inkColor), '#FF16211C');
  });
}
