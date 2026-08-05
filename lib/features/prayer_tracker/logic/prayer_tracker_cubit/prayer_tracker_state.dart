// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

class PrayerTrackerState extends Equatable {
  const PrayerTrackerState({
    this.completedPrayers = const {},
    this.fastingToday = false,
    this.prayerStreak = 0,
    this.fastingStreak = 0,
  });

  final Set<String> completedPrayers;
  final bool fastingToday;
  final int prayerStreak;
  final int fastingStreak;

  PrayerTrackerState copyWith({
    Set<String>? completedPrayers,
    bool? fastingToday,
    int? prayerStreak,
    int? fastingStreak,
  }) {
    return PrayerTrackerState(
      completedPrayers: completedPrayers ?? this.completedPrayers,
      fastingToday: fastingToday ?? this.fastingToday,
      prayerStreak: prayerStreak ?? this.prayerStreak,
      fastingStreak: fastingStreak ?? this.fastingStreak,
    );
  }

  @override
  List<Object?> get props => [
    completedPrayers,
    fastingToday,
    prayerStreak,
    fastingStreak,
  ];
}
