// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file touches the `adhan` package. A pure function of
// (coordinates, date, settings) to prayer times — no I/O, no clock
// reads beyond the caller-supplied [date].

import 'package:adhan/adhan.dart' as adhan;
// `adhan`'s public API silently substitutes a night-fraction "safe"
// Fajr/Isha whenever the true sun-angle has no solution, with no way
// to tell from the outside whether a substitution happened. Reaching
// into its internal solar-position math (still `pub`-installed under
// this same package, just not part of its stable public surface) is
// the only way to ask "did the real angle actually occur tonight?"
// before trusting a computed time as genuine.
import 'package:adhan/src/internal/solar_time.dart' show SolarTime;

import '../../../core/location/location_service.dart';
import 'prayer_settings.dart';
import 'prayer_times_result.dart';

/// Computes prayer times, refusing to surface a fabricated Isha/Fajr
/// at latitudes where the true sun angle never occurs that day.
class PrayerRepository {
  const PrayerRepository();

  /// Pure calculation: same inputs always produce the same result.
  PrayerTimesResult calculate({
    required Coordinates coordinates,
    required DateTime date,
    required PrayerSettings settings,
  }) {
    final adhanCoordinates = adhan.Coordinates(
      coordinates.latitude,
      coordinates.longitude,
    );
    final params = settings.method.toAdhan().getParameters()
      ..madhab = settings.madhab.toAdhan();

    if (!_anglesReachable(adhanCoordinates, date, params)) {
      return const HighLatitudeUnresolved();
    }

    try {
      final times = adhan.PrayerTimes(
        adhanCoordinates,
        adhan.DateComponents.from(date),
        params,
      );
      return PrayerTimesComputed(
        fajr: times.fajr,
        sunrise: times.sunrise,
        dhuhr: times.dhuhr,
        asr: times.asr,
        maghrib: times.maghrib,
        isha: times.isha,
      );
    } on ArgumentError {
      // No true sunrise/sunset at all this day (full polar day/night).
      return const HighLatitudeUnresolved();
    }
  }

  /// Whether the sun genuinely reaches [params]'s Fajr angle, and its
  /// Isha angle (when isha is angle-based rather than a fixed interval
  /// after Maghrib), on this date/coordinate — the same hour-angle
  /// solve `adhan` itself uses to decide whether to fall back to a
  /// safe, non-astronomical time.
  bool _anglesReachable(
    adhan.Coordinates coordinates,
    DateTime date,
    adhan.CalculationParameters params,
  ) {
    final solarTime = SolarTime(date, coordinates);

    final fajrHourAngle = solarTime.hourAngle(-params.fajrAngle, false);
    if (!fajrHourAngle.isFinite) return false;

    final ishaAngle = params.ishaAngle;
    if (ishaAngle != null) {
      final ishaHourAngle = solarTime.hourAngle(-ishaAngle, true);
      if (!ishaHourAngle.isFinite) return false;
    }
    return true;
  }
}

extension on PrayerCalculationMethod {
  adhan.CalculationMethod toAdhan() {
    switch (this) {
      case PrayerCalculationMethod.muslimWorldLeague:
        return adhan.CalculationMethod.muslim_world_league;
      case PrayerCalculationMethod.ummAlQura:
        return adhan.CalculationMethod.umm_al_qura;
      case PrayerCalculationMethod.egyptian:
        return adhan.CalculationMethod.egyptian;
      case PrayerCalculationMethod.karachi:
        return adhan.CalculationMethod.karachi;
      case PrayerCalculationMethod.isna:
        return adhan.CalculationMethod.north_america;
      case PrayerCalculationMethod.dubai:
        return adhan.CalculationMethod.dubai;
      case PrayerCalculationMethod.qatar:
        return adhan.CalculationMethod.qatar;
      case PrayerCalculationMethod.kuwait:
        return adhan.CalculationMethod.kuwait;
      case PrayerCalculationMethod.singapore:
        return adhan.CalculationMethod.singapore;
      case PrayerCalculationMethod.turkey:
        return adhan.CalculationMethod.turkey;
      case PrayerCalculationMethod.tehran:
        return adhan.CalculationMethod.tehran;
    }
  }
}

extension on PrayerMadhab {
  adhan.Madhab toAdhan() {
    switch (this) {
      case PrayerMadhab.shafi:
        return adhan.Madhab.shafi;
      case PrayerMadhab.hanafi:
        return adhan.Madhab.hanafi;
    }
  }
}
