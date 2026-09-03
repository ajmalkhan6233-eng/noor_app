// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for a real crash risk (2026-08-29): flutter_compass
// and sensors_plus can emit a genuine stream ERROR — not just a null
// reading — when the platform channel itself fails to set up a
// sensor, e.g. on a cloud emulator (Appetize and similar) with no
// simulated magnetometer/accelerometer. Both subscriptions previously
// had no `onError`, and main.dart has no global zone guard, so this
// was a genuinely unhandled exception, not just missing data.

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/core/sensors/compass_reading.dart';
import 'package:noor/core/sensors/compass_service.dart';
import 'package:noor/core/sensors/tilt_service.dart';
import 'package:noor/features/qibla/logic/qibla_cubit/qibla_cubit.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';
import 'package:sensors_plus/sensors_plus.dart';

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

const _riyadh = Coordinates(latitude: 6.9271, longitude: 79.8612);

void main() {
  test(
    'a compass stream error degrades to unavailable instead of throwing',
    () {
      fakeAsync((async) {
        final accelController = StreamController<AccelerometerEvent>();
        final magController = StreamController<MagnetometerEvent>();
        final cubit = QiblaCubit(
          locationService: const _FakeLocationService(_riyadh),
          settingsRepository: _FakeSettingsRepository(const AppSettings()),
          compassService: CompassService(
        gyroscopeProvider: () => null,
            accelerometerProvider: () => accelController.stream,
            magnetometerProvider: () => magController.stream,
          ),
          tiltService: TiltService(eventsProvider: () => null),
        );

        unawaited(cubit.start());
        async.elapse(Duration.zero);

        // Simulate a cloud-emulator platform channel failure — this
        // must not surface as an unhandled exception.
        magController.addError(PlatformException(code: 'no-sensor'));
        async.elapse(Duration.zero);

        expect(cubit.state.compassAccuracy, CompassAccuracy.unavailable);
        expect(cubit.state.displayAccuracy, CompassAccuracy.unavailable);
        expect(cubit.state.compassStalled, isTrue);

        cubit.close();
        accelController.close();
        magController.close();
      });
    },
  );

  test('a tilt stream error settles tilt back to centered instead of throwing', () {
    fakeAsync((async) {
      final controller = StreamController<AccelerometerEvent>();
      final cubit = QiblaCubit(
        locationService: const _FakeLocationService(_riyadh),
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
        compassService: CompassService(
        gyroscopeProvider: () => null,
          accelerometerProvider: () => null,
          magnetometerProvider: () => null,
        ),
        tiltService: TiltService(eventsProvider: () => controller.stream),
      );

      unawaited(cubit.start());
      async.elapse(Duration.zero);

      controller.addError(PlatformException(code: 'no-sensor'));
      async.elapse(Duration.zero);

      expect(cubit.state.tiltX, 0);
      expect(cubit.state.tiltY, 0);

      cubit.close();
      controller.close();
    });
  });
}
