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

  test('Vesak and Adhi Poson remain distinct official dates', () {
    final vesak2026 = sriLankaHolidaysOn(DateTime(2026, 5, 1));
    expect(vesak2026, isNotEmpty);
    expect(vesak2026.any((h) => h.isPoya), isTrue);
    expect(
      sriLankaHolidaysOn(DateTime(2026, 5, 30))
          .any((h) => h.name == 'Adhi Poson Full Moon Poya Day'),
      isTrue,
    );

    // A different year's May 1 isn't claimed as Vesak — Poya dates
    // are lunar and shift yearly; this app doesn't guess them. (May
    // Day itself still fires every year, so this checks for the
    // absence of the Poya entry specifically, not an empty list.)
    expect(
      sriLankaHolidaysOn(DateTime(2027, 5, 1)).any((h) => h.isPoya),
      isFalse,
    );
  });

  test('late-year official holidays are included', () {
    expect(sriLankaHolidaysOn(DateTime(2026, 10, 25)).single.isPoya, isTrue);
    expect(sriLankaHolidaysOn(DateTime(2026, 11, 8)).single.name, 'Deepavali Festival Day');
    expect(sriLankaHolidaysOn(DateTime(2026, 11, 24)).single.isPoya, isTrue);
    expect(sriLankaHolidaysOn(DateTime(2026, 12, 23)).single.isPoya, isTrue);
  });

  test('an ordinary day has no holidays', () {
    expect(sriLankaHolidaysOn(DateTime(2026, 7, 15)), isEmpty);
  });
}
