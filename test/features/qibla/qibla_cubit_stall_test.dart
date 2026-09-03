// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for a live-device bug (2026-08-25): a device whose
// magnetometer stream keeps delivering events with a null heading
// (seen on a real Xiaomi/MIUI phone) got stuck on an infinite
// CircularProgressIndicator forever — the compassStalled timeout never
// fired because the cubit treated "any event, even a null-heading
// one" as proof the compass was working.

import 'dart:async';
import 'dart:math' as math;

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/core/sensors/compass_service.dart';
import 'package:noor/core/sensors/tilt_service.dart';
import 'package:noor/features/qibla/logic/qibla_cubit/qibla_cubit.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';
import 'package:sensors_plus/sensors_plus.dart';

TiltService _noTilt() => TiltService(eventsProvider: () => null);

// A device held flat, screen up — reduces CompassService's tilt-
// compensation math to `atan2(-mx, my)`, so a magnetometer x/y pair can
// be picked directly for any desired raw heading (see
// compass_service_test.dart for the same construction, verified there).
AccelerometerEvent _flatAccel() =>
    AccelerometerEvent(0, 0, 9.8, DateTime(2026));

MagnetometerEvent _magFor(double headingDegrees) {
  final theta = headingDegrees * math.pi / 180;
  return MagnetometerEvent(
    -45 * math.sin(theta),
    45 * math.cos(theta),
    0,
    DateTime(2026),
  );
}

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
  test(
    'compassStalled fires when every event has a null heading, not just '
    'when no event ever arrives',
    () {
      fakeAsync((async) {
        final accelController = StreamController<AccelerometerEvent>();
        final magController = StreamController<MagnetometerEvent>();
        final cubit = QiblaCubit(
          locationService: const _FakeLocationService(
            Coordinates(latitude: 6.9271, longitude: 79.8612),
          ),
          settingsRepository: _FakeSettingsRepository(const AppSettings()),
          compassService: CompassService(
        gyroscopeProvider: () => null,
            accelerometerProvider: () => accelController.stream,
            magnetometerProvider: () => magController.stream,
          ),
          tiltService: _noTilt(),
        );

        unawaited(cubit.start());
        async.elapse(Duration.zero);

        // Simulate the real device: the stream is alive and keeps
        // delivering magnetometer events, but no accelerometer sample is
        // ever paired with them, so no heading can ever be resolved —
        // the same "stream alive, no usable heading" condition the
        // original flutter_compass-era null-heading events represented.
        magController.add(_magFor(0));
        async.elapse(const Duration(seconds: 1));
        magController.add(_magFor(0));
        async.elapse(const Duration(seconds: 6));

        expect(cubit.state.headingDegrees, isNull);
        expect(
          cubit.state.compassStalled,
          isTrue,
          reason:
              'null-heading events must not silently disarm the stall '
              'timer — the UI would be stuck on a spinner forever',
        );

        cubit.close();
        accelController.close();
        magController.close();
      });
    },
  );

  test('a genuine heading clears compassStalled even after it was set', () {
    fakeAsync((async) {
      final accelController = StreamController<AccelerometerEvent>();
      final magController = StreamController<MagnetometerEvent>();
      final cubit = QiblaCubit(
        locationService: const _FakeLocationService(
          Coordinates(latitude: 6.9271, longitude: 79.8612),
        ),
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
        compassService: CompassService(
        gyroscopeProvider: () => null,
          accelerometerProvider: () => accelController.stream,
          magnetometerProvider: () => magController.stream,
        ),
        tiltService: _noTilt(),
      );

      unawaited(cubit.start());
      async.elapse(Duration.zero);
      async.elapse(const Duration(seconds: 6));
      expect(cubit.state.compassStalled, isTrue);

      accelController.add(_flatAccel());
      magController.add(_magFor(90));
      async.elapse(Duration.zero);

      expect(cubit.state.compassStalled, isFalse);
      expect(cubit.state.headingDegrees, isNotNull);

      cubit.close();
      accelController.close();
      magController.close();
    });
  });
}
