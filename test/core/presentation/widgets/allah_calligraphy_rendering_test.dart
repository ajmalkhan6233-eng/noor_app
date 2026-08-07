// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pumps the actual widget and inspects the real, resolved TextStyle
// Flutter's element tree built at runtime — not a source-code read of
// allah_calligraphy.dart. Confirms the engraved effect the design doc
// specifies (docs/05_UI_UX_AND_3D_DESIGN_SYSTEM.md §4: "dark shadow
// offset up-left, soft light highlight offset down-right") is
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

    final darkShadow = shadows![0];
    final highlight = shadows[1];

    // Shadow: darker than the gold glyph, offset up-left — as if
    // light isn't reaching that edge.
    expect(darkShadow.offset.dx, lessThan(0));
    expect(darkShadow.offset.dy, lessThan(0));
    expect(darkShadow.color.a, greaterThan(0));
    expect(darkShadow.color.r + darkShadow.color.g + darkShadow.color.b, lessThan(1.0));

    // Highlight: lighter, offset down-right — the opposite corner,
    // which is what makes this read as pressed in rather than just
    // blurry.
    expect(highlight.offset.dx, greaterThan(0));
    expect(highlight.offset.dy, greaterThan(0));
    expect(highlight.color.a, greaterThan(0));
    expect(highlight.color.r + highlight.color.g + highlight.color.b, greaterThan(2.5));

    // Neither shadow is degenerate (zero blur AND zero alpha would be
    // invisible regardless of offset).
    expect(highlight.color.a > 0 || highlight.blurRadius > 0, isTrue);
    expect(darkShadow.color.a > 0 || darkShadow.blurRadius > 0, isTrue);
  });
}
