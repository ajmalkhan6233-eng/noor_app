// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/last_known_location.dart';
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
    bool promptIfNeeded = true,
  }) async => result;

  @override
  Future<Coordinates?> autoFetchCoordinates({
    Duration timeout = const Duration(seconds: 10),
  }) async => result;
}

class _FakeLastKnown extends LastKnownLocationStore {
  const _FakeLastKnown(this.value);
  final Coordinates? value;

  @override
  Future<Coordinates?> load() async => value;

  @override
  Future<void> save(Coordinates coordinates) async {}
}

class _SwitchableLocationService extends LocationService {
  _SwitchableLocationService();
  Coordinates? fix;
  int calls = 0;

  @override
  Future<Coordinates?> autoFetchCoordinates({Duration timeout = const Duration(seconds: 10)}) async {
    calls++;
    return fix;
  }
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

    test('falls back to Colombo silently (no error text) when GPS fails and nothing is known', () async {
      final cubit = PrayerCubit(
        locationService: const _FakeLocationService(null),
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
        lastKnownLocation: const _FakeLastKnown(null),
      );
      await cubit.loadSettings();

      expect(cubit.state.isResolvingLocation, isFalse);
      expect(cubit.state.hasCoordinates, isTrue);
      expect(cubit.state.usingGps, isFalse);
      expect(cubit.state.latitude, 6.9271);
      expect(cubit.state.longitude, 79.8612);
      expect(cubit.state.locationError, isNull, reason: 'no big error text on Prayer Times');
      expect(cubit.state.result, isA<PrayerTimesComputed>());
    });

    test('prefers the last known real location over Colombo when GPS fails', () async {
      final cubit = PrayerCubit(
        locationService: const _FakeLocationService(null),
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
        lastKnownLocation: const _FakeLastKnown(Coordinates(latitude: 51.5074, longitude: -0.1278)),
      );
      await cubit.loadSettings();

      expect(cubit.state.usingGps, isFalse);
      expect(cubit.state.latitude, 51.5074);
      expect(cubit.state.locationError, isNull);
    });

    test('resuming the app retries and picks up a location enabled later', () async {
      final location = _SwitchableLocationService();
      final cubit = PrayerCubit(
        locationService: location,
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
        lastKnownLocation: const _FakeLastKnown(null),
      );
      await cubit.loadSettings();
      expect(cubit.state.usingGps, isFalse);

      // The user turns location on in the phone's settings, then returns.
      location.fix = const Coordinates(latitude: 3.139, longitude: 101.6869);
      await cubit.retryLocationIfFallback();

      expect(cubit.state.usingGps, isTrue);
      expect(cubit.state.latitude, 3.139);
    });

    test('resuming does nothing (no GPS call) when a real fix is already in use', () async {
      final location = _SwitchableLocationService()..fix = const Coordinates(latitude: 1, longitude: 2);
      final cubit = PrayerCubit(
        locationService: location,
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
        lastKnownLocation: const _FakeLastKnown(null),
      );
      await cubit.loadSettings();
      final calls = location.calls;
      await cubit.retryLocationIfFallback();
      expect(location.calls, calls);
    });
  });
}
