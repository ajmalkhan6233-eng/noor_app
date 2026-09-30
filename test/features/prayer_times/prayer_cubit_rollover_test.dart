// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_times/logic/prayer_cubit/prayer_cubit.dart';

void main() {
  test('refreshIfDayChanged does nothing on the same day', () {
    var now = DateTime(2026, 9, 30, 10);
    final cubit = PrayerCubit(clock: () => now);
    now = DateTime(2026, 9, 30, 23, 59);

    expect(cubit.refreshIfDayChanged(), isFalse);
    expect(cubit.state.date.day, 30);
  });

  test('refreshIfDayChanged moves the cubit to the new day after midnight', () {
    var now = DateTime(2026, 9, 30, 22);
    final cubit = PrayerCubit(clock: () => now);
    now = DateTime(2026, 10, 1, 0, 5);

    expect(cubit.refreshIfDayChanged(), isTrue);
    expect(cubit.state.date.month, 10);
    expect(cubit.state.date.day, 1);
    // A second call on the same new day is a no-op.
    expect(cubit.refreshIfDayChanged(), isFalse);
  });
}
