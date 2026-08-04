// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Computes a full Gregorian month of prayer times up front for a fixed
// coordinate/settings pair — reuses PrayerRepository's pure calculation
// so the monthly view never duplicates prayer-time math.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location/location_service.dart';
import '../../data/prayer_repository.dart';
import '../../data/prayer_settings.dart';
import 'monthly_timetable_state.dart';

class MonthlyTimetableCubit extends Cubit<MonthlyTimetableState> {
  MonthlyTimetableCubit({
    required this.coordinates,
    required this.settings,
    required DateTime month,
    PrayerRepository? repository,
  }) : _repository = repository ?? const PrayerRepository(),
       _month = month,
       super(const MonthlyTimetableState()) {
    _computeMonth();
  }

  final Coordinates coordinates;
  final PrayerSettings settings;
  final PrayerRepository _repository;
  final DateTime _month;

  void _computeMonth() {
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final days = [
      for (var day = 1; day <= daysInMonth; day++)
        _computeDay(DateTime(_month.year, _month.month, day)),
    ];
    emit(MonthlyTimetableState(days: days));
  }

  MonthlyTimetableDay _computeDay(DateTime date) {
    final result = _repository.calculate(
      coordinates: coordinates,
      date: date,
      settings: settings,
    );
    return MonthlyTimetableDay(date: date, result: result);
  }
}
