// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/qibla/data/qibla_calculator.dart';

void main() {
  group('QiblaCalculator.bearingToKaaba', () {
    const cases = <String, (double lat, double lng, double expectedBearing)>{
      'London': (51.5074, -0.1278, 118.99),
      'New York': (40.7128, -74.0060, 58.48),
      'Jakarta': (-6.2088, 106.8456, 295.15),
      'Cairo': (30.0444, 31.2357, 136.14),
      'Istanbul': (41.0082, 28.9784, 151.62),
      'Delhi': (28.7041, 77.1025, 266.60),
      'Sydney': (-33.8688, 151.2093, 277.50),
      'Cape Town': (-33.9249, 18.4241, 23.35),
      'Kuala Lumpur': (3.1390, 101.6869, 292.54),
    };

    for (final entry in cases.entries) {
      final (lat, lng, expected) = entry.value;
      test(entry.key, () {
        final bearing = QiblaCalculator.bearingToKaaba(lat, lng);
        expect(bearing, closeTo(expected, 0.5));
      });
    }
  });

  group('QiblaCalculator.distanceToKaabaKm', () {
    test('is zero at the Kaaba itself', () {
      final distance = QiblaCalculator.distanceToKaabaKm(
        QiblaCalculator.kaabaLatitude,
        QiblaCalculator.kaabaLongitude,
      );
      expect(distance, closeTo(0, 0.001));
    });

    test('is positive and plausible for a distant city (London)', () {
      final distance = QiblaCalculator.distanceToKaabaKm(51.5074, -0.1278);
      // London to Makkah is roughly 4700-4900 km great-circle.
      expect(distance, greaterThan(4500));
      expect(distance, lessThan(5000));
    });
  });
}
