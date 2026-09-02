// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The lock/particle-burst precondition (QiblaState.isLocked) must not
// only be correct in isolation (see qibla_state_lock_test.dart) but
// must actually be reachable through QiblaCubit's real state flow when
// the bearing comes from a district rather than GPS — this drives it
// through the cubit exactly as the district fallback UI would.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/core/sensors/compass_service.dart';
import 'package:noor/core/sensors/magnetic_declination.dart';
import 'package:noor/core/sensors/tilt_service.dart';
import 'package:noor/features/qibla/data/qibla_calculator.dart';
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

/// A paired accelerometer/magnetometer controller set producing a raw
/// heading chosen so that, once QiblaCubit applies magnetic declination
/// the same way CompassService/_listen do, the resulting true heading
/// lands exactly on [bearing] — i.e. dead-on qibla.
({StreamController<AccelerometerEvent> accel, StreamController<MagnetometerEvent> mag})
_headingControllersFor(double latitude, double longitude, double bearing) {
  final declination = MagneticDeclination.estimate(latitude, longitude);
  final accelController = StreamController<AccelerometerEvent>();
  final magController = StreamController<MagnetometerEvent>();
  accelController.add(_flatAccel());
  magController.add(_magFor(bearing - declination));
  return (accel: accelController, mag: magController);
}

void main() {
  group('Qibla lock reachable via the district path (not just GPS)', () {
    test('locks when GPS fails and a previously chosen district supplies the bearing', () async {
      const lat = 7.2906; // Kandy
      const lng = 80.6337;
      final bearing = QiblaCalculator.bearingToKaaba(lat, lng);
      final controllers = _headingControllersFor(lat, lng, bearing);

      final cubit = QiblaCubit(
        locationService: const _FakeLocationService(null),
        settingsRepository: _FakeSettingsRepository(
          const AppSettings(selectedDistrict: 'Kandy'),
        ),
        compassService: CompassService(
          accelerometerProvider: () => controllers.accel.stream,
          magnetometerProvider: () => controllers.mag.stream,
        ),
        tiltService: _noTilt(),
      );

      await cubit.start();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.latitude, lat);
      expect(cubit.state.isLocked, isTrue);

      await cubit.close();
      await controllers.accel.close();
      await controllers.mag.close();
    });

    test('locks when the district fallback picker sets the location manually', () async {
      const lat = 6.9271; // Colombo
      const lng = 79.8612;
      final bearing = QiblaCalculator.bearingToKaaba(lat, lng);
      final controllers = _headingControllersFor(lat, lng, bearing);

      final cubit = QiblaCubit(
        locationService: const _FakeLocationService(null),
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
        compassService: CompassService(
          accelerometerProvider: () => controllers.accel.stream,
          magnetometerProvider: () => controllers.mag.stream,
        ),
        tiltService: _noTilt(),
      );

      await cubit.start();
      expect(cubit.state.locationError, isNotNull); // nothing to fall back to yet

      cubit.setManualLocation(lat, lng);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.isLocked, isTrue);

      await cubit.close();
      await controllers.accel.close();
      await controllers.mag.close();
    });

    test('does not lock while off-bearing, via the same district path', () async {
      const lat = 7.2906;
      const lng = 80.6337;
      final bearing = QiblaCalculator.bearingToKaaba(lat, lng);
      final declination = MagneticDeclination.estimate(lat, lng);
      final accelController = StreamController<AccelerometerEvent>();
      final magController = StreamController<MagnetometerEvent>();

      final cubit = QiblaCubit(
        locationService: const _FakeLocationService(null),
        settingsRepository: _FakeSettingsRepository(
          const AppSettings(selectedDistrict: 'Kandy'),
        ),
        compassService: CompassService(
          accelerometerProvider: () => accelController.stream,
          magnetometerProvider: () => magController.stream,
        ),
        tiltService: _noTilt(),
      );

      await cubit.start();
      // 40 degrees off qibla — well outside the lock threshold.
      accelController.add(_flatAccel());
      magController.add(_magFor(bearing - declination + 40));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.isLocked, isFalse);

      await cubit.close();
      await accelController.close();
      await magController.close();
    });
  });
}
