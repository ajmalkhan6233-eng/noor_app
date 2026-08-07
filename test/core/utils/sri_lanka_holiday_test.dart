// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Confirms the fixed-date civic holidays recur every year, the 2026
// movable dates are scoped to 2026 only, and an ordinary day has none.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/utils/sri_lanka_holiday.dart';

void main() {
  test('New Year\'s Day recurs every year', () {
    expect(sriLankaHolidaysOn(DateTime(2026, 1, 1)), isNotEmpty);
    expect(sriLankaHolidaysOn(DateTime(2030, 1, 1)), isNotEmpty);
  });

  test('Vesak Full Moon Poya Day is only asserted for 2026', () {
    final vesak2026 = sriLankaHolidaysOn(DateTime(2026, 5, 30));
    expect(vesak2026, isNotEmpty);
    expect(vesak2026.first.isPoya, isTrue);

    // A different year's May 30 isn't claimed as Vesak — Poya dates
    // are lunar and shift yearly; this app doesn't guess them.
    expect(sriLankaHolidaysOn(DateTime(2027, 5, 30)), isEmpty);
  });

  test('an ordinary day has no holidays', () {
    expect(sriLankaHolidaysOn(DateTime(2026, 7, 15)), isEmpty);
  });
}
