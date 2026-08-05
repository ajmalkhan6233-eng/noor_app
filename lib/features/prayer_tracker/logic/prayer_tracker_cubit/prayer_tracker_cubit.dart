// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// UI never touches PrayerTrackerRepository directly — every read/write
// goes through here, same as every other feature's cubit.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/prayer_tracker_repository.dart';
import 'prayer_tracker_state.dart';

class PrayerTrackerCubit extends Cubit<PrayerTrackerState> {
  PrayerTrackerCubit({PrayerTrackerRepository? repository})
    : _repository = repository ?? PrayerTrackerRepository(),
      super(const PrayerTrackerState());

  final PrayerTrackerRepository _repository;

  Future<void> load() async {
    final today = DateTime.now();
    final completed = await _repository.completedPrayersOn(today);
    final fasting = await _repository.isFastingDay(today);
    final prayerStreak = await _repository.currentPrayerStreak(today);
    final fastingStreak = await _repository.currentFastingStreak(today);
    emit(
      state.copyWith(
        completedPrayers: completed,
        fastingToday: fasting,
        prayerStreak: prayerStreak,
        fastingStreak: fastingStreak,
      ),
    );
  }

  Future<void> togglePrayer(String prayer) async {
    final today = DateTime.now();
    final nowCompleted = !state.completedPrayers.contains(prayer);
    await _repository.setPrayerCompleted(today, prayer, completed: nowCompleted);
    await load();
  }

  Future<void> toggleFasting() async {
    final today = DateTime.now();
    final nowFasting = !state.fastingToday;
    await _repository.setFastingDay(today, fasted: nowFasting);
    await load();
  }
}
