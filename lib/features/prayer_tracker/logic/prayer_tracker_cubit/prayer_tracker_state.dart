// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

class PrayerTrackerState extends Equatable {
  PrayerTrackerState({
    this.completedPrayers = const {},
    this.fastingToday = false,
    this.prayerStreak = 0,
    this.fastingStreak = 0,
    DateTime? viewedDate,
  }) : viewedDate = viewedDate ?? _today();

  final Set<String> completedPrayers;
  final bool fastingToday;
  final int prayerStreak;
  final int fastingStreak;

  /// The calendar day the checklist is currently showing/editing —
  /// defaults to today. Marking a prayer done on a day other than
  /// today is for catching up on the last couple of days only (see
  /// PrayerTrackerCubit's clamp); there is no reason to ever view a
  /// future day here.
  final DateTime viewedDate;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool get isViewingToday => viewedDate == _today();

  PrayerTrackerState copyWith({
    Set<String>? completedPrayers,
    bool? fastingToday,
    int? prayerStreak,
    int? fastingStreak,
    DateTime? viewedDate,
  }) {
    return PrayerTrackerState(
      completedPrayers: completedPrayers ?? this.completedPrayers,
      fastingToday: fastingToday ?? this.fastingToday,
      prayerStreak: prayerStreak ?? this.prayerStreak,
      fastingStreak: fastingStreak ?? this.fastingStreak,
      viewedDate: viewedDate ?? this.viewedDate,
    );
  }

  @override
  List<Object?> get props => [
    completedPrayers,
    fastingToday,
    prayerStreak,
    fastingStreak,
    viewedDate,
  ];
}
