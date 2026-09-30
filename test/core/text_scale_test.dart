// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/utils/text_scale.dart';

void main() {
  test('default scale is boosted by 15%', () {
    expect(boostedTextScaler(TextScaler.noScaling).scale(1.0), closeTo(1.15, 1e-9));
  });

  test('a 200% OS scale is capped at 2.0 instead of 2.3', () {
    expect(boostedTextScaler(const TextScaler.linear(2.0)).scale(1.0), 2.0);
  });

  test('never drops below 1.0', () {
    expect(boostedTextScaler(const TextScaler.linear(0.5)).scale(1.0), 1.0);
  });
}
