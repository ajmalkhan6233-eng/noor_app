// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

class PrayerTrackerState extends Equatable {
  const PrayerTrackerState({
    this.completedPrayers = const {},
    this.fastingToday = false,
    this.prayerStreak = 0,
    this.fastingStreak = 0,
    this.daysBack = 0,
  });

  final Set<String> completedPrayers;
  final bool fastingToday;
  final int prayerStreak;
  final int fastingStreak;

  /// How many days back from *today* the checklist is showing/editing
  /// — 0 is today, 1 is yesterday, etc. Stored as an offset rather than
  /// an absolute date so a cubit instance that outlives midnight (this
  /// one is shared across Home and Prayer Times for the app's whole
  /// lifetime) keeps tracking the real "today" instead of freezing on
  /// whatever date it happened to be constructed on — a stored absolute
  /// date used to go stale across a midnight rollover and log a
  /// still-open Isha completion against the wrong day.
  final int daysBack;

  /// Overridable only from tests, to simulate a midnight rollover
  /// without a real clock wait — never reassigned in app code. Not
  /// `@visibleForTesting`-restricted since PrayerTrackerCubit (a
  /// different file) also needs to read the same clock.
  static DateTime Function() debugNowOverride = DateTime.now;

  static DateTime _today() {
    final now = debugNowOverride();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get viewedDate => _today().subtract(Duration(days: daysBack));

  bool get isViewingToday => daysBack == 0;

  PrayerTrackerState copyWith({
    Set<String>? completedPrayers,
    bool? fastingToday,
    int? prayerStreak,
    int? fastingStreak,
    int? daysBack,
  }) {
    return PrayerTrackerState(
      completedPrayers: completedPrayers ?? this.completedPrayers,
      fastingToday: fastingToday ?? this.fastingToday,
      prayerStreak: prayerStreak ?? this.prayerStreak,
      fastingStreak: fastingStreak ?? this.fastingStreak,
      daysBack: daysBack ?? this.daysBack,
    );
  }

  @override
  List<Object?> get props => [
    completedPrayers,
    fastingToday,
    prayerStreak,
    fastingStreak,
    daysBack,
  ];
}
