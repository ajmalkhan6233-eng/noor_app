// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../data/prayer_times_result.dart';

/// One computed day in the monthly timetable.
class MonthlyTimetableDay extends Equatable {
  const MonthlyTimetableDay({required this.date, required this.result});

  final DateTime date;
  final PrayerTimesResult result;

  @override
  List<Object?> get props => [date, result];
}

/// Immutable state for the monthly-timetable feature: every day of the
/// requested Gregorian month, computed once up front (pure, offline
/// math — cheap even for 31 days).
class MonthlyTimetableState extends Equatable {
  const MonthlyTimetableState({this.days = const []});

  final List<MonthlyTimetableDay> days;

  @override
  List<Object?> get props => [days];
}
