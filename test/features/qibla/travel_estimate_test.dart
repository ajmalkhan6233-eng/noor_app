// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/qibla/data/travel_estimate.dart';

void main() {
  test('flyingHours divides distance by 850 km/h', () {
    expect(TravelEstimate.flyingHours(6800), closeTo(8.0, 0.01));
  });

  test('camelDays divides distance by 40 km/day', () {
    expect(TravelEstimate.camelDays(6800), closeTo(170.0, 0.01));
  });

  test('footMonths divides distance by 25 km/day then by 30 days/month', () {
    expect(TravelEstimate.footMonths(6750), closeTo(9.0, 0.01));
  });

  test('zero distance gives zero for every mode', () {
    expect(TravelEstimate.flyingHours(0), 0);
    expect(TravelEstimate.camelDays(0), 0);
    expect(TravelEstimate.footMonths(0), 0);
  });
}
