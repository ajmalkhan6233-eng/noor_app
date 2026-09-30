// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file touches `sensors_plus` for heading data
// (`tilt_service.dart` is the only other file touching `sensors_plus`,
// for the unrelated accelerometer-only bezel-tilt effect). Replaces the
// prior `flutter_compass`-backed implementation: `sensors_plus` has no
// platform-computed heading of its own, only raw accelerometer/
// magnetometer/gyroscope axes, so the sensor fusion that used to happen
// inside the OS (flutter_compass read `TYPE_ROTATION_VECTOR`, a
// gyroscope-stabilized platform fusion) now happens here.
//
// Two layers:
// 1. A tilt-compensated heading from accelerometer + magnetometer alone
//    — the same rotation-matrix approach Android's own
//    SensorManager.getRotationMatrix/getOrientation uses internally
//    (H = magnetometer × gravity gives the East vector, N = gravity × H
//    gives the tilt-compensated North vector, heading = atan2(H.y, N.y)).
//    This alone is what shipped first — real device testing (2026-09-03)
//    showed it flickers and jumps under real handheld motion, because
//    every reading depends on the *instantaneous* accelerometer sample,
//    and any hand tremor or vibration corrupts that instant's "which way
//    is gravity" estimate.
// 2. Gyroscope fusion (a complementary filter) on top: between
//    magnetometer updates, the heading is integrated forward from the
//    gyroscope's angular velocity instead of being re-derived from a
//    single noisy accelerometer/magnetometer sample each time. The
//    magnetometer reading still runs continuously and gently pulls the
//    fused heading back toward the raw tilt-compensated value (via the
//    same `smoothingFactor`/`AngleMath.smooth` used before), which stops
//    long-run gyroscope drift from accumulating. This is the standard
//    "complementary filter" technique — cheap, no matrix/quaternion
//    state, and it degrades gracefully to the old accel+mag-only
//    behavior if this device or platform exposes no gyroscope.
//
// The yaw-rate sign (`yawRateDegPerSec` below) is derived, not guessed —
// see the doc comment on `_yawRateDegPerSec` for the derivation and the
// flat-device sanity check backing `compass_service_gyro_test.dart`.
// Real physical device rotation still needs live confirmation (this
// couldn't be simulated in a unit test the way the static formula
// could) — see CLAUDE.md's 2026-09-03 log for that result.

import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

import '../utils/angle_math.dart';
import 'compass_math.dart';
import 'compass_reading.dart';

/// Wraps the device accelerometer + magnetometer + gyroscope as a stream
/// of smoothed, classified [CompassReading]s.
class CompassService {
  CompassService({
    this.smoothingFactor = 0.06,
    this.lowAccuracyThresholdDegrees = 15,
    Stream<AccelerometerEvent>? Function()? accelerometerProvider,
    Stream<MagnetometerEvent>? Function()? magnetometerProvider,
    Stream<GyroscopeEvent>? Function()? gyroscopeProvider,
  }) : _accelerometerProvider =
           accelerometerProvider ?? (() => accelerometerEventStream()),
       _magnetometerProvider =
           magnetometerProvider ?? (() => magnetometerEventStream()),
       _gyroscopeProvider =
           gyroscopeProvider ?? (() => gyroscopeEventStream());

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
  final Stream<GyroscopeEvent>? Function() _gyroscopeProvider;

  double? _smoothedHeading;
  AccelerometerEvent? _lastAccel;
  CompassAccuracy _lastAccuracy = CompassAccuracy.unavailable;
  DateTime? _lastGyroTimestamp;

  /// Stream of smoothed readings. Emits a single
  /// [CompassAccuracy.unavailable] reading and nothing further when this
  /// device/platform exposes no accelerometer or no magnetometer. A
  /// missing gyroscope is not fatal — [readings] falls back to the plain
  /// accelerometer+magnetometer heading exactly as before.
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
    final gyroEvents = _gyroscopeProvider();

    late final StreamController<CompassReading> controller;
    StreamSubscription<AccelerometerEvent>? accelSub;
    StreamSubscription<MagnetometerEvent>? magSub;
    StreamSubscription<GyroscopeEvent>? gyroSub;

    controller = StreamController<CompassReading>(
      onListen: () {
        accelSub = accelEvents.listen(
          (event) => _lastAccel = event,
          onError: controller.addError,
        );
        magSub = magEvents.listen(
          (event) => controller.add(_correctFromMagnetometer(event)),
          onError: controller.addError,
        );
        if (gyroEvents != null) {
          gyroSub = gyroEvents.listen(
            (event) {
              final reading = _integrateGyroscope(event);
              if (reading != null) controller.add(reading);
            },
            onError: controller.addError,
          );
        }
      },
      onCancel: () async {
        await accelSub?.cancel();
        await magSub?.cancel();
        await gyroSub?.cancel();
      },
    );
    return controller.stream;
  }

  CompassReading _correctFromMagnetometer(MagnetometerEvent event) {
    final accel = _lastAccel;
    final rawHeading = accel == null
        ? null
        : tiltCompensatedHeadingDegrees(accel, event);

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

    // A gentle pull toward the raw reading — this is the "complementary"
    // half of the filter, correcting whatever drift the gyroscope
    // integration below accumulated between magnetometer updates. With
    // no gyroscope ever active, this is the *only* correction applied,
    // reproducing the original accel+mag-only smoothing exactly.
    _smoothedHeading = _smoothedHeading == null
        ? AngleMath.normalise(rawHeading)
        : AngleMath.smooth(_smoothedHeading!, rawHeading, smoothingFactor);
    _lastAccuracy = classifyCompassAccuracy(event);

    return CompassReading(
      headingDegrees: _smoothedHeading,
      accuracy: _lastAccuracy,
    );
  }

  /// Advances the fused heading using the gyroscope's angular velocity,
  /// rather than waiting for the next noisy magnetometer sample — this is
  /// what actually smooths out real handheld jitter, since a hand tremor
  /// shows up as a real (if brief) rotation the gyroscope tracks
  /// correctly, rather than as corrupted accelerometer/magnetometer axes.
  /// Returns `null` when there's nothing to integrate from yet (no prior
  /// heading, or no accelerometer sample to establish "which way is up").
  CompassReading? _integrateGyroscope(GyroscopeEvent event) {
    final accel = _lastAccel;
    final previousHeading = _smoothedHeading;
    final lastTimestamp = _lastGyroTimestamp;
    _lastGyroTimestamp = event.timestamp;

    if (accel == null || previousHeading == null || lastTimestamp == null) {
      return null;
    }

    final dtSeconds =
        event.timestamp.difference(lastTimestamp).inMicroseconds / 1e6;
    // A stream gap (app backgrounded, sensor hiccup) would otherwise
    // integrate a huge, meaningless jump — clamp to a sane single-frame
    // duration instead of trusting an arbitrarily large dt.
    if (dtSeconds <= 0 || dtSeconds > 0.5) return null;

    final yawRateDegPerSec = yawRateFromGyro(accel, event);
    _smoothedHeading = AngleMath.normalise(
      previousHeading + yawRateDegPerSec * dtSeconds,
    );

    return CompassReading(
      headingDegrees: _smoothedHeading,
      accuracy: _lastAccuracy,
    );
  }
}
