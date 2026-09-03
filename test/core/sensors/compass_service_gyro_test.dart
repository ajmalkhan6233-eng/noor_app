// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Verifies the gyroscope-integration sign/magnitude the only way
// possible without real hardware: cross-checked against the already-
// validated static tilt-compensated heading formula (compass_service_
// test.dart), rather than trusted on its own. `_magFor(heading)` is
// known (from that file's passing tests, themselves checked against
// Android's own SensorManager algorithm) to produce a raw magnetometer
// reading whose computed azimuth is exactly `heading`. So: seed the
// fused heading from one such reading, then — WITHOUT any further
// magnetometer correction — integrate a matching gyroscope reading for
// exactly one second and confirm the result lands on the heading a real
// rotation by that amount would produce. If the sign or the up-axis
// projection in CompassService's yaw-rate derivation is wrong, this
// mismatches; it can't pass by accident the way eyeballing a live
// device can't easily rule out a systematic sign flip.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/sensors/compass_reading.dart';
import 'package:noor/core/sensors/compass_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

AccelerometerEvent _flatAccel(DateTime t) => AccelerometerEvent(0, 0, 9.8, t);

MagnetometerEvent _magFor(double headingDegrees, DateTime t) {
  final theta = headingDegrees * math.pi / 180;
  return MagnetometerEvent(-45 * math.sin(theta), 45 * math.cos(theta), 0, t);
}

/// The gyroscope reading (rad/s, purely about the device's own z-axis,
/// matching the flat-device orientation `_flatAccel` describes) that —
/// integrated for exactly [dtSeconds] — should move the compass heading
/// by [targetDeltaDegrees]. `dtSeconds` must stay well under
/// CompassService's own 0.5s stream-gap clamp, the same way real
/// gyroscope samples (tens of milliseconds apart) always would.
GyroscopeEvent _gyroForHeadingDelta(
  double targetDeltaDegrees,
  DateTime t, {
  double dtSeconds = 0.1,
}) {
  final targetRateDegPerSec = targetDeltaDegrees / dtSeconds;
  final targetRateRadPerSec = targetRateDegPerSec * math.pi / 180;
  return GyroscopeEvent(0, 0, -targetRateRadPerSec, t);
}

void main() {
  group('CompassService gyroscope fusion', () {
    test(
      'integrating the gyroscope for 1s matches the equivalent magnetometer-only heading change (+30deg)',
      () async {
        final t0 = DateTime(2026);
        final accelController = StreamController<AccelerometerEvent>();
        final magController = StreamController<MagnetometerEvent>();
        final gyroController = StreamController<GyroscopeEvent>();
        final service = CompassService(
          accelerometerProvider: () => accelController.stream,
          magnetometerProvider: () => magController.stream,
          gyroscopeProvider: () => gyroController.stream,
        );

        final readings = <CompassReading>[];
        final subscription = service.readings.listen(readings.add);

        accelController.add(_flatAccel(t0));
        magController.add(_magFor(0, t0)); // seeds heading at exactly 0
        await Future<void>.delayed(Duration.zero);
        expect(readings.last.headingDegrees, closeTo(0, 1e-6));

        // Seed gyro timestamp (first-ever gyro event integrates nothing —
        // there's no prior gyro timestamp to compute dt against).
        gyroController.add(_gyroForHeadingDelta(0, t0));
        await Future<void>.delayed(Duration.zero);

        // No further magnetometer events from here — isolates the
        // gyroscope's own contribution.
        gyroController.add(
          _gyroForHeadingDelta(
            30,
            t0.add(const Duration(milliseconds: 100)),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(readings.last.headingDegrees, closeTo(30, 0.5));

        await subscription.cancel();
        await accelController.close();
        await magController.close();
        await gyroController.close();
      },
    );

    test(
      'integrating the gyroscope for 1s matches the equivalent magnetometer-only heading change (-45deg, wrapping through 0)',
      () async {
        final t0 = DateTime(2026);
        final accelController = StreamController<AccelerometerEvent>();
        final magController = StreamController<MagnetometerEvent>();
        final gyroController = StreamController<GyroscopeEvent>();
        final service = CompassService(
          accelerometerProvider: () => accelController.stream,
          magnetometerProvider: () => magController.stream,
          gyroscopeProvider: () => gyroController.stream,
        );

        final readings = <CompassReading>[];
        final subscription = service.readings.listen(readings.add);

        accelController.add(_flatAccel(t0));
        magController.add(_magFor(10, t0));
        await Future<void>.delayed(Duration.zero);
        expect(readings.last.headingDegrees, closeTo(10, 1e-6));

        gyroController.add(_gyroForHeadingDelta(0, t0));
        await Future<void>.delayed(Duration.zero);

        gyroController.add(
          _gyroForHeadingDelta(
            -45,
            t0.add(const Duration(milliseconds: 100)),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        // 10 - 45 = -35 -> normalises to 325.
        expect(readings.last.headingDegrees, closeTo(325, 0.5));

        await subscription.cancel();
        await accelController.close();
        await magController.close();
        await gyroController.close();
      },
    );

    test('a stream gap longer than half a second is not integrated', () async {
      final t0 = DateTime(2026);
      final accelController = StreamController<AccelerometerEvent>();
      final magController = StreamController<MagnetometerEvent>();
      final gyroController = StreamController<GyroscopeEvent>();
      final service = CompassService(
        accelerometerProvider: () => accelController.stream,
        magnetometerProvider: () => magController.stream,
        gyroscopeProvider: () => gyroController.stream,
      );

      final readings = <CompassReading>[];
      final subscription = service.readings.listen(readings.add);

      accelController.add(_flatAccel(t0));
      magController.add(_magFor(0, t0));
      await Future<void>.delayed(Duration.zero);

      gyroController.add(_gyroForHeadingDelta(0, t0));
      await Future<void>.delayed(Duration.zero);
      final readingCountBeforeGap = readings.length;

      // A 10-second gap (app backgrounded, sensor hiccup) with a large
      // angular velocity — if this were integrated naively it would spin
      // the heading wildly. It must be dropped instead.
      gyroController.add(
        _gyroForHeadingDelta(900, t0.add(const Duration(seconds: 10))),
      );
      await Future<void>.delayed(Duration.zero);

      expect(readings.length, readingCountBeforeGap);

      await subscription.cancel();
      await accelController.close();
      await magController.close();
      await gyroController.close();
    });

    test('with no gyroscope stream, behavior is unchanged from accel+mag only', () async {
      final accelController = StreamController<AccelerometerEvent>();
      final magController = StreamController<MagnetometerEvent>();
      final service = CompassService(
        smoothingFactor: 0.5,
        accelerometerProvider: () => accelController.stream,
        magnetometerProvider: () => magController.stream,
        gyroscopeProvider: () => null,
      );

      final readings = <CompassReading>[];
      final subscription = service.readings.listen(readings.add);

      final t0 = DateTime(2026);
      accelController.add(_flatAccel(t0));
      magController.add(_magFor(0, t0));
      magController.add(_magFor(100, t0));
      await Future<void>.delayed(Duration.zero);

      expect(readings[0].headingDegrees, closeTo(0, 1e-6));
      // Halfway (factor 0.5), exactly as compass_service_test.dart's
      // equivalent no-gyro case already verifies.
      expect(readings[1].headingDegrees, closeTo(50, 1e-6));

      await subscription.cancel();
      await accelController.close();
      await magController.close();
    });
  });
}
