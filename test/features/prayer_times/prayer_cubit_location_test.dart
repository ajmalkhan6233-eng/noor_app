// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';
import 'package:noor/features/prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';

class _FakeLocationService extends LocationService {
  const _FakeLocationService(this.result);
  final Coordinates? result;

  @override
  Future<Coordinates?> getCurrentCoordinates({
    Duration timeout = const Duration(seconds: 10),
  }) async => result;

  @override
  Future<Coordinates?> autoFetchCoordinates({
    Duration timeout = const Duration(seconds: 10),
  }) async => result;
}

class _FakeSettingsRepository extends SettingsRepository {
  _FakeSettingsRepository(this._settings);
  final AppSettings _settings;

  @override
  Future<AppSettings> load() async => _settings;
}

void main() {
  group('PrayerCubit.loadSettings automatic location', () {
    test('auto-fetches GPS when no district or coordinates are known', () async {
      final cubit = PrayerCubit(
        locationService: const _FakeLocationService(
          Coordinates(latitude: 6.9271, longitude: 79.8612),
        ),
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
      );
      await cubit.loadSettings();

      expect(cubit.state.usingGps, isTrue);
      expect(cubit.state.latitude, 6.9271);
      expect(cubit.state.isResolvingLocation, isFalse);
      expect(cubit.state.result, isA<PrayerTimesComputed>());
    });

    test('leaves coordinates unset (no hang) when GPS fails', () async {
      final cubit = PrayerCubit(
        locationService: const _FakeLocationService(null),
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
      );
      await cubit.loadSettings();

      expect(cubit.state.isResolvingLocation, isFalse);
      expect(cubit.state.hasCoordinates, isFalse);
    });

    test('a persisted district is sticky and is not overridden by GPS', () async {
      final cubit = PrayerCubit(
        locationService: const _FakeLocationService(
          Coordinates(latitude: 6.9271, longitude: 79.8612),
        ),
        settingsRepository: _FakeSettingsRepository(
          const AppSettings(selectedDistrict: 'Kandy'),
        ),
      );
      await cubit.loadSettings();

      expect(cubit.state.usingGps, isFalse);
      expect(cubit.state.latitude, 7.2906);
      expect(cubit.state.longitude, 80.6337);
    });
  });
}
