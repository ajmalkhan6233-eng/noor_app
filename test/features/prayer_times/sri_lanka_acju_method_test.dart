// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Checks the "Sri Lanka (ACJU timetable match)" method against values
// published in the official ACJU timetables (acju.lk):
//  - Zone 01 (Colombo, Gampaha, Kalutara), February
//  - Zone 13 (Hambantota), July
// Tolerance: 2 minutes (a zone table vs one point inside the zone).

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/features/prayer_times/data/prayer_repository.dart';
import 'package:noor/features/prayer_times/data/prayer_settings.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';

int _minutes(String hhmm) {
  final parts = hhmm.split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}

int _sriLankaMinutes(DateTime t) {
  final local = t.toUtc().add(const Duration(hours: 5, minutes: 30));
  return local.hour * 60 + local.minute;
}

void _check(Coordinates at, DateTime day, List<String> acju) {
  final result = const PrayerRepository().calculate(
    coordinates: at,
    date: day,
    settings: const PrayerSettings(),
  ) as PrayerTimesComputed;
  final ours = [result.fajr, result.sunrise, result.dhuhr, result.asr, result.maghrib, result.isha];
  const names = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  for (var i = 0; i < 6; i++) {
    final diff = _sriLankaMinutes(ours[i]) - _minutes(acju[i]);
    expect(diff.abs(), lessThanOrEqualTo(2),
        reason: '${names[i]} on $day: ours ${_sriLankaMinutes(ours[i])} vs ACJU ${acju[i]}');
  }
}

void main() {
  test('default method is the Sri Lanka ACJU match', () {
    expect(const PrayerSettings().method, PrayerCalculationMethod.sriLankaAcju);
  });

  test('Colombo matches ACJU Zone 01, February', () {
    const colombo = Coordinates(latitude: 6.9271, longitude: 79.8612);
    _check(colombo, DateTime(2026, 2, 1), ['05:10', '06:30', '12:26', '15:47', '18:20', '19:32']);
    _check(colombo, DateTime(2026, 2, 5), ['05:10', '06:30', '12:26', '15:48', '18:21', '19:33']);
    _check(colombo, DateTime(2026, 2, 10), ['05:10', '06:29', '12:26', '15:48', '18:22', '19:33']);
  });

  test('Hambantota matches ACJU Zone 13, July', () {
    const hambantota = Coordinates(latitude: 6.1241, longitude: 81.1185);
    _check(hambantota, DateTime(2026, 7, 1), ['04:32', '05:57', '12:12', '15:39', '18:26', '19:42']);
    _check(hambantota, DateTime(2026, 7, 9), ['04:35', '05:59', '12:13', '15:40', '18:27', '19:42']);
  });

  test('old default (MWL) was far off ACJU for Fajr and Isha', () {
    final mwl = const PrayerRepository().calculate(
      coordinates: const Coordinates(latitude: 6.9271, longitude: 79.8612),
      date: DateTime(2026, 2, 1),
      settings: const PrayerSettings(method: PrayerCalculationMethod.muslimWorldLeague),
    ) as PrayerTimesComputed;
    expect(_sriLankaMinutes(mwl.fajr) - _minutes('05:10'), greaterThanOrEqualTo(5));
    expect(_minutes('19:32') - _sriLankaMinutes(mwl.isha), greaterThanOrEqualTo(3));
  });
}
