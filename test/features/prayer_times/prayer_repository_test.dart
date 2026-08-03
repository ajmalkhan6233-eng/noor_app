// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/features/prayer_times/data/prayer_repository.dart';
import 'package:noor/features/prayer_times/data/prayer_settings.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';

void main() {
  const repository = PrayerRepository();
  // A fixed date avoids the test suite's result depending on today.
  final date = DateTime(2026, 3, 20);

  group('PrayerRepository.calculate at ordinary latitudes', () {
    const settings = PrayerSettings(
      method: PrayerCalculationMethod.muslimWorldLeague,
      madhab: PrayerMadhab.shafi,
    );

    test('returns a full, chronologically-ordered set of times', () {
      final result = repository.calculate(
        coordinates: const Coordinates(latitude: 21.4225, longitude: 39.8262),
        date: date,
        settings: settings,
      );

      expect(result, isA<PrayerTimesComputed>());
      final computed = result as PrayerTimesComputed;
      expect(computed.fajr.isBefore(computed.sunrise), isTrue);
      expect(computed.sunrise.isBefore(computed.dhuhr), isTrue);
      expect(computed.dhuhr.isBefore(computed.asr), isTrue);
      expect(computed.asr.isBefore(computed.maghrib), isTrue);
      expect(computed.maghrib.isBefore(computed.isha), isTrue);
    });

    test('is a pure function: same inputs give identical times', () {
      const coordinates = Coordinates(latitude: 51.5074, longitude: -0.1278);
      final first = repository.calculate(
        coordinates: coordinates,
        date: date,
        settings: settings,
      );
      final second = repository.calculate(
        coordinates: coordinates,
        date: date,
        settings: settings,
      );
      expect(first, equals(second));
    });

    test('Hanafi Asr is never earlier than Shafi Asr', () {
      const coordinates = Coordinates(latitude: 40.7128, longitude: -74.0060);
      final shafi =
          repository.calculate(
                coordinates: coordinates,
                date: date,
                settings: settings,
              )
              as PrayerTimesComputed;
      final hanafi =
          repository.calculate(
                coordinates: coordinates,
                date: date,
                settings: settings.copyWith(madhab: PrayerMadhab.hanafi),
              )
              as PrayerTimesComputed;
      expect(
        hanafi.asr.isAfter(shafi.asr) ||
            hanafi.asr.isAtSameMomentAs(shafi.asr),
        isTrue,
      );
    });
  });

  group('PrayerRepository.calculate at high latitudes', () {
    test(
      'returns HighLatitudeUnresolved rather than a fabricated Isha '
      'inside the polar circle during local summer',
      () {
        // Tromsø, Norway, near the summer solstice: the midnight sun
        // means the sky never reaches Isha/Fajr twilight depth.
        final result = repository.calculate(
          coordinates: const Coordinates(latitude: 69.6492, longitude: 18.9553),
          date: DateTime(2026, 6, 21),
          settings: const PrayerSettings(),
        );

        expect(result, isA<HighLatitudeUnresolved>());
      },
    );

    test(
      'resolves normally at the same high-latitude city in a mild season',
      () {
        final result = repository.calculate(
          coordinates: const Coordinates(latitude: 69.6492, longitude: 18.9553),
          date: DateTime(2026, 3, 20),
          settings: const PrayerSettings(),
        );

        expect(result, isA<PrayerTimesComputed>());
      },
    );
  });
}
