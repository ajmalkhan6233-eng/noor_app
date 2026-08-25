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
      super(PrayerTrackerState());

  final PrayerTrackerRepository _repository;

  /// Catching up on a missed day is reasonable; browsing indefinitely
  /// into the past isn't what this checklist is for (2026-08-24
  /// live-device review: "maximum one to two days behind").
  static const _maxDaysBack = 2;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> load() async {
    final today = _today();
    final completed = await _repository.completedPrayersOn(state.viewedDate);
    final fasting = await _repository.isFastingDay(state.viewedDate);
    // Streaks are always "as of today", independent of which day the
    // checklist happens to be showing right now.
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

  Future<void> goToPreviousDay() async {
    final earliest = _today().subtract(const Duration(days: _maxDaysBack));
    if (!state.viewedDate.isAfter(earliest)) return;
    emit(state.copyWith(viewedDate: state.viewedDate.subtract(const Duration(days: 1))));
    await load();
  }

  Future<void> goToNextDay() async {
    if (state.isViewingToday) return;
    emit(state.copyWith(viewedDate: state.viewedDate.add(const Duration(days: 1))));
    await load();
  }

  Future<void> togglePrayer(String prayer) async {
    final nowCompleted = !state.completedPrayers.contains(prayer);
    await _repository.setPrayerCompleted(state.viewedDate, prayer, completed: nowCompleted);
    await load();
  }

  Future<void> toggleFasting() async {
    final nowFasting = !state.fastingToday;
    await _repository.setFastingDay(state.viewedDate, fasted: nowFasting);
    await load();
  }
}
