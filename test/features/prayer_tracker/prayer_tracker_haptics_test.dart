// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_tracker/data/prayer_tracker_repository.dart';
import 'package:noor/features/prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';

import '../../helpers/silent_haptics.dart';

class _MemoryRepository extends PrayerTrackerRepository {
  final Set<String> done = {};
  bool fasting = false;

  @override
  Future<void> setPrayerCompleted(DateTime date, String prayer, {required bool completed}) async {
    completed ? done.add(prayer) : done.remove(prayer);
  }

  @override
  Future<Set<String>> completedPrayersOn(DateTime date) async => {...done};

  @override
  Future<void> setFastingDay(DateTime date, {required bool fasted}) async => fasting = fasted;

  @override
  Future<bool> isFastingDay(DateTime date) async => fasting;

  @override
  Future<int> currentPrayerStreak(DateTime date) async => 0;

  @override
  Future<int> currentFastingStreak(DateTime date) async => 0;
}

void main() {
  test('ticking a prayer taps; the fifth tick also fires the milestone pulse once', () async {
    final haptics = SilentHaptics();
    final cubit = PrayerTrackerCubit(repository: _MemoryRepository(), hapticService: haptics);

    for (final prayer in trackedPrayers.take(4)) {
      await cubit.togglePrayer(prayer);
    }
    expect(haptics.taps, 4);
    expect(haptics.pulses, 0);

    await cubit.togglePrayer(trackedPrayers.last);
    expect(haptics.taps, 5);
    expect(haptics.pulses, 1);
    await cubit.close();
  });

  test('unticking a prayer is silent; fasting toggles tap', () async {
    final haptics = SilentHaptics();
    final cubit = PrayerTrackerCubit(repository: _MemoryRepository(), hapticService: haptics);

    await cubit.togglePrayer('Fajr');
    await cubit.togglePrayer('Fajr');
    expect(haptics.taps, 1);

    await cubit.toggleFasting();
    expect(haptics.taps, 2);
    await cubit.close();
  });
}
