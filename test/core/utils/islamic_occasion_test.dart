// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/utils/hijri_date.dart';
import 'package:noor/core/utils/islamic_occasion.dart';

void main() {
  group('occasionsOn', () {
    test('every day of month 9 is Ramadan', () {
      expect(
        occasionsOn(const HijriDate(year: 1445, month: 9, day: 1)),
        contains(IslamicOccasion.ramadan),
      );
      expect(
        occasionsOn(const HijriDate(year: 1445, month: 9, day: 29)),
        contains(IslamicOccasion.ramadan),
      );
    });

    test('1 Shawwal is Eid al-Fitr', () {
      expect(
        occasionsOn(const HijriDate(year: 1445, month: 10, day: 1)),
        [IslamicOccasion.eidAlFitr],
      );
    });

    test('10 Dhu al-Hijjah is Eid al-Adha', () {
      expect(
        occasionsOn(const HijriDate(year: 1445, month: 12, day: 10)),
        [IslamicOccasion.eidAlAdha],
      );
    });

    test('10 Muharram is Ashura', () {
      expect(
        occasionsOn(const HijriDate(year: 1445, month: 1, day: 10)),
        [IslamicOccasion.ashura],
      );
    });

    test('13-15 of any month are White Days', () {
      for (final day in [13, 14, 15]) {
        expect(
          occasionsOn(HijriDate(year: 1445, month: 3, day: day)),
          contains(IslamicOccasion.whiteDays),
        );
      }
      expect(
        occasionsOn(const HijriDate(year: 1445, month: 3, day: 16)),
        isNot(contains(IslamicOccasion.whiteDays)),
      );
    });

    test('an ordinary day has no occasions', () {
      expect(
        occasionsOn(const HijriDate(year: 1445, month: 2, day: 5)),
        isEmpty,
      );
    });
  });
}
