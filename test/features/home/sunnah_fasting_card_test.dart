// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/home/presentation/widgets/sunnah_fasting_card.dart';

void main() {
  group('isSunnahFastingWeekday', () {
    test('true for Monday and Thursday, false otherwise', () {
      expect(isSunnahFastingWeekday(DateTime(2026, 8, 24)), isTrue); // Monday
      expect(isSunnahFastingWeekday(DateTime(2026, 8, 27)), isTrue); // Thursday
      expect(isSunnahFastingWeekday(DateTime(2026, 8, 25)), isFalse); // Tuesday
    });
  });

  group('isHijriWhiteDay', () {
    test('true only for the 13th, 14th, and 15th', () {
      expect(isHijriWhiteDay(12), isFalse);
      expect(isHijriWhiteDay(13), isTrue);
      expect(isHijriWhiteDay(14), isTrue);
      expect(isHijriWhiteDay(15), isTrue);
      expect(isHijriWhiteDay(16), isFalse);
    });
  });
}
