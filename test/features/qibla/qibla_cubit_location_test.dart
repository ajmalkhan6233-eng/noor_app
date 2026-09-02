// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/core/sensors/compass_service.dart';
import 'package:noor/core/sensors/tilt_service.dart';
import 'package:noor/features/qibla/logic/qibla_cubit/qibla_cubit.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';

// No real magnetometer/accelerometer platform channel in a unit test —
// both services already support an injectable, empty event source.
CompassService _noCompass() => CompassService(
  accelerometerProvider: () => null,
  magnetometerProvider: () => null,
);
TiltService _noTilt() => TiltService(eventsProvider: () => null);

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

class _FakeSettingsRepository extends SettingsRepository {
  _FakeSettingsRepository(this._settings);
  final AppSettings _settings;

  @override
  Future<AppSettings> load() async => _settings;
}

void main() {
  group('QiblaCubit.start location resolution', () {
    test('uses GPS immediately when it succeeds', () async {
      final cubit = QiblaCubit(
        locationService: const _FakeLocationService(
          Coordinates(latitude: 6.9271, longitude: 79.8612),
        ),
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
        compassService: _noCompass(),
        tiltService: _noTilt(),
      );
      await cubit.start();

      expect(cubit.state.latitude, 6.9271);
      expect(cubit.state.locationError, isNull);
      expect(cubit.state.isResolvingLocation, isFalse);
      await cubit.close();
    });

    test('falls back to a previously chosen district when GPS fails', () async {
      final cubit = QiblaCubit(
        locationService: const _FakeLocationService(null),
        settingsRepository: _FakeSettingsRepository(
          const AppSettings(selectedDistrict: 'Kandy'),
        ),
        compassService: _noCompass(),
        tiltService: _noTilt(),
      );
      await cubit.start();

      expect(cubit.state.latitude, 7.2906);
      expect(cubit.state.longitude, 80.6337);
      expect(cubit.state.locationError, isNull);
      expect(cubit.state.isResolvingLocation, isFalse);
      await cubit.close();
    });

    test(
      'surfaces a resolvable error (not an indefinite hang) when GPS '
      'fails and no district is known',
      () async {
        final cubit = QiblaCubit(
          locationService: const _FakeLocationService(null),
          settingsRepository: _FakeSettingsRepository(const AppSettings()),
        );
        await cubit.start();

        expect(cubit.state.isResolvingLocation, isFalse);
        expect(cubit.state.locationError, isNotNull);
        expect(cubit.state.bearingDegrees, isNull);
        await cubit.close();
      },
    );

    test('setManualLocation resolves the fallback district picker', () async {
      final cubit = QiblaCubit(
        locationService: const _FakeLocationService(null),
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
        compassService: _noCompass(),
        tiltService: _noTilt(),
      );
      await cubit.start();
      expect(cubit.state.locationError, isNotNull);

      cubit.setManualLocation(6.0535, 80.2210);

      expect(cubit.state.locationError, isNull);
      expect(cubit.state.latitude, 6.0535);
      expect(cubit.state.bearingDegrees, isNotNull);
      await cubit.close();
    });
  });
}
