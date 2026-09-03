// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/sensors/compass_reading.dart';
import 'package:noor/core/sensors/compass_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

final _now = DateTime(2026);

/// A device held flat, screen up (gravity entirely along +z), which
/// reduces the rotation-matrix heading math to `atan2(-mx, my)` — lets
/// tests pick a magnetometer x/y pair for any desired raw heading without
/// needing to reason about the full 3D tilt-compensation formula.
AccelerometerEvent _flatAccel() => AccelerometerEvent(0, 0, 9.8, _now);

MagnetometerEvent _magFor(double headingDegrees, {double magnitude = 45}) {
  final theta = headingDegrees * math.pi / 180;
  return MagnetometerEvent(
    -magnitude * math.sin(theta),
    magnitude * math.cos(theta),
    0,
    _now,
  );
}

void main() {
  group('CompassService.readings', () {
    test('reports unavailable when there is no accelerometer stream at all', () async {
      final service = CompassService(
        gyroscopeProvider: () => null,
        accelerometerProvider: () => null,
        magnetometerProvider: () => Stream.value(_magFor(0)),
      );
      final reading = await service.readings.first;
      expect(reading.accuracy, CompassAccuracy.unavailable);
      expect(reading.headingDegrees, isNull);
    });

    test('reports unavailable when there is no magnetometer stream at all', () async {
      final service = CompassService(
        gyroscopeProvider: () => null,
        accelerometerProvider: () => Stream.value(_flatAccel()),
        magnetometerProvider: () => null,
      );
      final reading = await service.readings.first;
      expect(reading.accuracy, CompassAccuracy.unavailable);
      expect(reading.headingDegrees, isNull);
    });

    test(
      'reports unavailable when a magnetometer event arrives before any '
      'accelerometer sample has ever been paired with it',
      () async {
        final service = CompassService(
        gyroscopeProvider: () => null,
          accelerometerProvider: () => const Stream.empty(),
          magnetometerProvider: () => Stream.value(_magFor(90)),
        );
        final reading = await service.readings.first;
        expect(reading.accuracy, CompassAccuracy.unavailable);
        expect(reading.headingDegrees, isNull);
      },
    );

    test('holds the last known heading through a transient missing-accel gap', () async {
      final accelController = StreamController<AccelerometerEvent>();
      final magController = StreamController<MagnetometerEvent>();
      final service = CompassService(
        gyroscopeProvider: () => null,
        accelerometerProvider: () => accelController.stream,
        magnetometerProvider: () => magController.stream,
      );

      final readings = <CompassReading>[];
      final subscription = service.readings.listen(readings.add);

      accelController.add(_flatAccel());
      magController.add(_magFor(120));
      await Future<void>.delayed(Duration.zero);
      // A second reading with no accelerometer sample paired at all would
      // never happen once one has arrived (accel keeps its last value),
      // so simulate the real "hiccup" case: a wildly degenerate
      // magnetometer sample (near-zero field, e.g. sensor glitch) makes
      // the tilt-compensation math itself degenerate for one frame.
      magController.add(MagnetometerEvent(0, 0, 0, _now));
      magController.add(_magFor(121));
      await Future<void>.delayed(Duration.zero);

      expect(readings[0].headingDegrees, closeTo(120, 1e-6));
      // Must NOT be null — that's what made the needle vanish/reappear
      // (flicker) on every transient hiccup. Held at the last value.
      expect(readings[1].headingDegrees, closeTo(120, 1e-6));
      expect(readings[1].accuracy, CompassAccuracy.uncalibrated);
      // Smoothing resumes normally once real readings continue.
      expect(readings[2].headingDegrees, isNotNull);

      await subscription.cancel();
      await accelController.close();
      await magController.close();
    });

    test('a typical Earth-range field magnitude classifies as good', () async {
      final service = CompassService(
        gyroscopeProvider: () => null,
        accelerometerProvider: () => Stream.value(_flatAccel()),
        magnetometerProvider: () => Stream.value(_magFor(90, magnitude: 45)),
      );
      final reading = await service.readings.first;
      expect(reading.accuracy, CompassAccuracy.good);
      expect(reading.headingDegrees, closeTo(90, 1e-6));
    });

    test('a field magnitude just outside the typical range classifies as low', () async {
      final service = CompassService(
        gyroscopeProvider: () => null,
        accelerometerProvider: () => Stream.value(_flatAccel()),
        magnetometerProvider: () => Stream.value(_magFor(90, magnitude: 75)),
      );
      final reading = await service.readings.first;
      expect(reading.accuracy, CompassAccuracy.low);
    });

    test('a far-outside-range field magnitude classifies as uncalibrated', () async {
      final service = CompassService(
        gyroscopeProvider: () => null,
        accelerometerProvider: () => Stream.value(_flatAccel()),
        magnetometerProvider: () => Stream.value(_magFor(90, magnitude: 5)),
      );
      final reading = await service.readings.first;
      expect(reading.accuracy, CompassAccuracy.uncalibrated);
    });

    test('smooths successive headings rather than jumping instantly', () async {
      final accelController = StreamController<AccelerometerEvent>();
      final magController = StreamController<MagnetometerEvent>();
      final service = CompassService(
        gyroscopeProvider: () => null,
        smoothingFactor: 0.5,
        accelerometerProvider: () => accelController.stream,
        magnetometerProvider: () => magController.stream,
      );

      final readings = <CompassReading>[];
      final subscription = service.readings.listen(readings.add);

      accelController.add(_flatAccel());
      magController.add(_magFor(0));
      magController.add(_magFor(100));
      await Future<void>.delayed(Duration.zero);

      expect(readings[0].headingDegrees, closeTo(0, 1e-6));
      // Halfway (factor 0.5) from 0 toward 100 is 50 — not an instant
      // jump to the new raw reading.
      expect(readings[1].headingDegrees, closeTo(50, 1e-6));

      await subscription.cancel();
      await accelController.close();
      await magController.close();
    });

    test('default smoothing factor damps noise more than a single reading', () async {
      final accelController = StreamController<AccelerometerEvent>();
      final magController = StreamController<MagnetometerEvent>();
      final service = CompassService(
        gyroscopeProvider: () => null,
        accelerometerProvider: () => accelController.stream,
        magnetometerProvider: () => magController.stream,
      );
      expect(service.smoothingFactor, 0.06);

      final readings = <CompassReading>[];
      final subscription = service.readings.listen(readings.add);

      accelController.add(_flatAccel());
      magController.add(_magFor(0));
      magController.add(_magFor(100));
      await Future<void>.delayed(Duration.zero);

      // Moves only 6% of the way toward a sudden 100-degree jump — real
      // magnetometer noise (a few degrees of jitter) is damped to a
      // fraction of a degree per event, not visible as a twitch.
      expect(readings[1].headingDegrees, closeTo(6, 1e-6));

      await subscription.cancel();
      await accelController.close();
      await magController.close();
    });
  });
}
