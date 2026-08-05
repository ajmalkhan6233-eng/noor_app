// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pumps the actual widget and inspects the real, resolved TextStyle
// Flutter's element tree built at runtime — not a source-code read of
// allah_calligraphy.dart. Confirms the emboss effect the design doc
// specifies (docs/05_UI_UX_AND_3D_DESIGN_SYSTEM.md §4: "light
// highlight offset up-left, soft dark shadow offset down-right") is
// actually present on the live widget, not just written in a comment.
// (RenderRepaintBoundary.toImage() was tried first for a true pixel
// dump, but hangs indefinitely in this sandbox's headless
// flutter_tester — software-rendering GPU readback appears
// unsupported here, so this inspects the real Text widget's resolved
// style instead, which needs no rasterizer.)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/presentation/widgets/allah_calligraphy.dart';

void main() {
  testWidgets('renders with a genuine two-shadow emboss, not flat text', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AllahCalligraphy())),
    );

    final text = tester.widget<Text>(find.text('الله'));
    final shadows = text.style?.shadows;

    expect(shadows, isNotNull);
    expect(shadows, hasLength(2));

    final highlight = shadows![0];
    final darkShadow = shadows[1];

    // Highlight: lighter than the gold glyph, offset up-left.
    expect(highlight.offset.dx, lessThan(0));
    expect(highlight.offset.dy, lessThan(0));
    expect(highlight.color.a, greaterThan(0));
    expect(highlight.color.r + highlight.color.g + highlight.color.b, greaterThan(2.5));

    // Shadow: darker, offset down-right — the opposite corner, which
    // is what makes this read as raised rather than just blurry.
    expect(darkShadow.offset.dx, greaterThan(0));
    expect(darkShadow.offset.dy, greaterThan(0));
    expect(darkShadow.color.a, greaterThan(0));
    expect(darkShadow.color.r + darkShadow.color.g + darkShadow.color.b, lessThan(1.0));

    // Neither shadow is degenerate (zero blur AND zero alpha would be
    // invisible regardless of offset).
    expect(highlight.color.a > 0 || highlight.blurRadius > 0, isTrue);
    expect(darkShadow.color.a > 0 || darkShadow.blurRadius > 0, isTrue);
  });
}
