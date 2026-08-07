// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Confirms ParallaxLayer actually shifts its child as the paired
// ScrollController's offset changes, and that reduced motion
// collapses the shift to zero.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/presentation/widgets/parallax_layer.dart';

Widget _harness(ScrollController controller, {bool disableAnimations = false}) {
  return MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: MaterialApp(
      home: Scaffold(
        body: ListView(
          controller: controller,
          children: [
            ParallaxLayer(
              controller: controller,
              child: const SizedBox(height: 100, child: Text('header')),
            ),
            for (var i = 0; i < 40; i++) SizedBox(height: 60, child: Text('item $i')),
          ],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shifts the child as the list scrolls', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_harness(controller));
    await tester.pump();

    Offset positionOf() => tester.getTopLeft(find.text('header'));
    final before = positionOf();

    controller.jumpTo(40);
    await tester.pump();

    final after = positionOf();
    // The header should have moved by less than the raw scroll delta
    // (it lags behind) but still moved in the same direction.
    expect(after.dy, lessThan(before.dy));
    expect(after.dy, greaterThan(before.dy - 40));
  });

  testWidgets('reduced motion collapses the shift to zero', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_harness(controller, disableAnimations: true));
    await tester.pump();

    final before = tester.getTopLeft(find.text('header'));
    controller.jumpTo(40);
    await tester.pump();
    final after = tester.getTopLeft(find.text('header'));

    // With reduced motion, the only movement is the ordinary scroll
    // itself (the ListView moved it up 40), no extra parallax shift.
    expect(after.dy, closeTo(before.dy - 40, 0.5));
  });
}
