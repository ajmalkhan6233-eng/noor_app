// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/utils/hijri_date.dart';

void main() {
  group('HijriDate.fromGregorian', () {
    test('19 July 2023 is 1 Muharram 1445 AH', () {
      final h = HijriDate.fromGregorian(DateTime(2023, 7, 19));
      expect(h.year, 1445);
      expect(h.month, 1);
      expect(h.day, 1);
    });

    test('11 September 2001 is 22 Jumada al-Thani 1422 AH', () {
      final h = HijriDate.fromGregorian(DateTime(2001, 9, 11));
      expect(h.year, 1422);
      expect(h.month, 6);
      expect(h.day, 22);
    });

    test('offsetDays shifts the result by whole days', () {
      final base = HijriDate.fromGregorian(DateTime(2024, 1, 1));
      final shifted = HijriDate.fromGregorian(
        DateTime(2024, 1, 1),
        offsetDays: 1,
      );
      expect(shifted.day, base.day + 1);
    });
  });
}
