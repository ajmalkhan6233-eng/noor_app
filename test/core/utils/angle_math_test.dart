// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/utils/angle_math.dart';

void main() {
  group('AngleMath.normalise', () {
    test('leaves in-range angles unchanged', () {
      expect(AngleMath.normalise(45), closeTo(45, 1e-9));
    });

    test('wraps angles above 360', () {
      expect(AngleMath.normalise(370), closeTo(10, 1e-9));
    });

    test('wraps negative angles', () {
      expect(AngleMath.normalise(-30), closeTo(330, 1e-9));
    });
  });

  group('AngleMath.difference', () {
    test('is zero for equal angles', () {
      expect(AngleMath.difference(90, 90), closeTo(0, 1e-9));
    });

    test('takes the shorter path across the 0/360 wrap', () {
      expect(AngleMath.difference(1, 359), closeTo(2, 1e-9));
      expect(AngleMath.difference(359, 1), closeTo(-2, 1e-9));
    });

    test('handles a simple non-wrapping case', () {
      expect(AngleMath.difference(100, 40), closeTo(60, 1e-9));
    });
  });

  group('AngleMath.circularMean', () {
    test('averages angles as unit vectors, not scalars', () {
      // A scalar mean of 359 and 1 is 180 — wrong. The circular mean
      // must be 0, since both angles sit 1 degree from north.
      expect(AngleMath.circularMean([359, 1]), closeTo(0, 1e-6));
    });

    test('matches the arithmetic mean when angles do not wrap', () {
      expect(AngleMath.circularMean([10, 20, 30]), closeTo(20, 1e-6));
    });

    test('throws on an empty list', () {
      expect(() => AngleMath.circularMean([]), throwsArgumentError);
    });
  });

  group('AngleMath.smooth', () {
    test('factor 0 leaves the previous value unchanged', () {
      expect(AngleMath.smooth(10, 90, 0), closeTo(10, 1e-9));
    });

    test('factor 1 jumps straight to the target', () {
      expect(AngleMath.smooth(10, 90, 1), closeTo(90, 1e-9));
    });

    test('takes the shorter way around the wrap', () {
      // From 350 toward 10 (i.e. through 0), halfway should be 0.
      expect(AngleMath.smooth(350, 10, 0.5), closeTo(0, 1e-9));
    });
  });
}
