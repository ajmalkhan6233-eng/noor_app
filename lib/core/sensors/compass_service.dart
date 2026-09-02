// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file touches `sensors_plus` for heading data
// (`tilt_service.dart` is the only other file touching `sensors_plus`,
// for the unrelated accelerometer-only bezel-tilt effect). Replaces the
// prior `flutter_compass`-backed implementation: `sensors_plus` has no
// platform-computed heading of its own, only raw accelerometer/
// magnetometer axes, so the tilt-compensation that used to happen inside
// the OS now happens here — the same rotation-matrix approach Android's
// own SensorManager.getRotationMatrix/getOrientation uses internally
// (H = magnetometer × gravity gives the East vector, N = gravity × H
// gives the tilt-compensated North vector, heading = atan2(H.y, N.y)).
// Raw headings are still jittery frame to frame — every reading is
// smoothed with `AngleMath.smooth` before it ever reaches a cubit or
// widget, exactly as before.

import 'dart:async';
import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';

import '../utils/angle_math.dart';
import 'compass_reading.dart';

/// Wraps the device accelerometer + magnetometer as a stream of smoothed,
/// classified [CompassReading]s.
class CompassService {
  CompassService({
    this.smoothingFactor = 0.06,
    this.lowAccuracyThresholdDegrees = 15,
    Stream<AccelerometerEvent>? Function()? accelerometerProvider,
    Stream<MagnetometerEvent>? Function()? magnetometerProvider,
  }) : _accelerometerProvider =
           accelerometerProvider ?? (() => accelerometerEventStream()),
       _magnetometerProvider =
           magnetometerProvider ?? (() => magnetometerEventStream());

  /// Fraction (`0`–`1`) moved toward each new raw heading per event —
  /// lower is smoother but slower to respond. See `compass_service.dart`
  /// history: 0.06 trades more lag for enough damping that raw
  /// magnetometer noise doesn't show through, verified via
  /// `angle_math_test.dart`'s coverage of the underlying smoothing math.
  final double smoothingFactor;

  /// Reported field-magnitude deviation (in the same "degrees-equivalent"
  /// unit space the rest of the app already tunes against) above which a
  /// reading counts as [CompassAccuracy.low] rather than
  /// [CompassAccuracy.good]. Kept as a constructor parameter for parity
  /// with the previous implementation even though the current magnitude-
  /// based classifier doesn't consume it directly — a future accuracy
  /// model plugged in here can.
  final double lowAccuracyThresholdDegrees;

  final Stream<AccelerometerEvent>? Function() _accelerometerProvider;
  final Stream<MagnetometerEvent>? Function() _magnetometerProvider;

  double? _smoothedHeading;
  AccelerometerEvent? _lastAccel;

  /// Stream of smoothed readings. Emits a single
  /// [CompassAccuracy.unavailable] reading and nothing further when this
  /// device/platform exposes no accelerometer or no magnetometer.
  Stream<CompassReading> get readings {
    final accelEvents = _accelerometerProvider();
    final magEvents = _magnetometerProvider();
    if (accelEvents == null || magEvents == null) {
      return Stream.value(
        const CompassReading(
          headingDegrees: null,
          accuracy: CompassAccuracy.unavailable,
        ),
      );
    }

    late final StreamController<CompassReading> controller;
    StreamSubscription<AccelerometerEvent>? accelSub;
    StreamSubscription<MagnetometerEvent>? magSub;

    controller = StreamController<CompassReading>(
      onListen: () {
        accelSub = accelEvents.listen(
          (event) => _lastAccel = event,
          onError: controller.addError,
        );
        magSub = magEvents.listen(
          (event) => controller.add(_toReading(event)),
          onError: controller.addError,
        );
      },
      onCancel: () async {
        await accelSub?.cancel();
        await magSub?.cancel();
      },
    );
    return controller.stream;
  }

  CompassReading _toReading(MagnetometerEvent event) {
    final accel = _lastAccel;
    final rawHeading = accel == null
        ? null
        : _tiltCompensatedHeadingDegrees(accel, event);

    if (rawHeading == null) {
      // No paired accelerometer sample yet, or a momentarily degenerate
      // orientation (device held near-flat along the wrong axis) — a
      // transient gap, not "no compass". Hold the last known heading
      // exactly as the flutter_compass-era null-heading handling did, so
      // the needle doesn't blank out on a single bad frame.
      final held = _smoothedHeading;
      if (held != null) {
        return CompassReading(
          headingDegrees: held,
          accuracy: CompassAccuracy.uncalibrated,
        );
      }
      return const CompassReading(
        headingDegrees: null,
        accuracy: CompassAccuracy.unavailable,
      );
    }

    _smoothedHeading = _smoothedHeading == null
        ? AngleMath.normalise(rawHeading)
        : AngleMath.smooth(_smoothedHeading!, rawHeading, smoothingFactor);

    return CompassReading(
      headingDegrees: _smoothedHeading,
      accuracy: _classifyAccuracy(event),
    );
  }

  /// Tilt-compensated heading in degrees (`0`–`360`, `0` = magnetic
  /// north), or `null` when the current accelerometer/magnetometer pair
  /// makes the rotation-matrix math degenerate (near-zero cross product
  /// or near-zero gravity vector — e.g. the device is in freefall or the
  /// magnetometer reading is all but zero).
  double? _tiltCompensatedHeadingDegrees(
    AccelerometerEvent accel,
    MagnetometerEvent mag,
  ) {
    final ax = accel.x, ay = accel.y, az = accel.z;
    final mx = mag.x, my = mag.y, mz = mag.z;

    // East vector: magnetometer × gravity.
    var hx = my * az - mz * ay;
    var hy = mz * ax - mx * az;
    final hz = mx * ay - my * ax;
    final normH = math.sqrt(hx * hx + hy * hy + hz * hz);
    if (normH < 0.1) return null;
    hx /= normH;
    hy /= normH;

    final normA = math.sqrt(ax * ax + ay * ay + az * az);
    if (normA < 0.1) return null;
    final gx = ax / normA, gz = az / normA;

    // North vector's y-component (gravity × East), tilt-compensated —
    // the same rotation-matrix rows Android's own
    // SensorManager.getOrientation() uses (azimuth = atan2(R[1], R[4])
    // in its row-major layout, i.e. atan2(East.y, North.y) here).
    final northY = gz * hx - gx * hz;

    final headingRad = math.atan2(hy, northY);
    return AngleMath.normalise(headingRad * 180 / math.pi);
  }

  /// `sensors_plus` reports no platform accuracy alongside a magnetometer
  /// sample, unlike `flutter_compass`'s native heading. Approximated
  /// instead from how far the raw field magnitude sits from Earth's
  /// typical 25–65 microtesla range — a magnitude far outside that band
  /// means nearby magnetic interference or an uncalibrated sensor, the
  /// same real-world condition the old platform accuracy-degrees value
  /// was meant to flag.
  CompassAccuracy _classifyAccuracy(MagnetometerEvent event) {
    final magnitude = math.sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    if (magnitude < 15 || magnitude > 90) return CompassAccuracy.uncalibrated;
    if (magnitude < 25 || magnitude > 65) return CompassAccuracy.low;
    return CompassAccuracy.good;
  }
}
