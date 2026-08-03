// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/sensors/magnetic_declination.dart';

void main() {
  group('MagneticDeclination.estimate', () {
    test('returns a value within a plausible declination range', () {
      // Real-world declination rarely exceeds ~30° outside the polar
      // regions; this is a sanity bound on the dipole approximation,
      // not a precision claim.
      final declination = MagneticDeclination.estimate(51.5074, -0.1278);
      expect(declination.abs(), lessThan(30));
    });

    test('is deterministic for the same inputs', () {
      final first = MagneticDeclination.estimate(40.7128, -74.0060);
      final second = MagneticDeclination.estimate(40.7128, -74.0060);
      expect(first, equals(second));
    });

    test('is signed (can be east or west of true north)', () {
      // Cities roughly symmetric east/west of the geomagnetic pole's
      // longitude should skew in opposite declination directions.
      final west = MagneticDeclination.estimate(45, -90);
      final east = MagneticDeclination.estimate(45, 140);
      expect(west.sign, isNot(equals(east.sign)));
    });
  });
}
