// Bismillahir Rahmanir Raheem — watermark: ALLAH

// Pure sensor maths used by CompassService (no state, no I/O), moved
// out unchanged to keep compass_service.dart short.

import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';

import '../utils/angle_math.dart';
import 'compass_reading.dart';

/// Rotation rate of the compass heading (degrees/second, positive =
/// turning clockwise as seen from above — the same sense the heading
/// formula below uses), derived from the gyroscope's angular velocity
/// projected onto the device's current "up" axis (the normalised
/// gravity/accelerometer vector), so it stays correct regardless of
/// how the phone is tilted, not just when held flat.
///
/// Derivation (checked against the flat-device case, where the
/// gravity axis is simply the device's own +z): a positive gyroscope
/// reading around +z is, by the right-hand rule, a *counter*-clockwise
/// device rotation as seen by someone looking down at the screen —
/// but compass heading increases *clockwise*. So a positive angular
/// velocity around the up axis must *decrease* the heading, giving
/// `yawRate = -(gyro · up)`. `compass_service_gyro_test.dart` verifies
/// this by an independent route: rotating a raw magnetometer reading
/// by a known angle (reusing the already-verified static heading
/// formula) must match integrating the equivalent gyroscope reading
/// over time by this same amount.
double yawRateFromGyro(AccelerometerEvent accel, GyroscopeEvent gyro) {
  final normA = math.sqrt(
    accel.x * accel.x + accel.y * accel.y + accel.z * accel.z,
  );
  if (normA < 0.1) return 0;
  final gx = accel.x / normA, gy = accel.y / normA, gz = accel.z / normA;
  final upComponent = gyro.x * gx + gyro.y * gy + gyro.z * gz;
  return -upComponent * 180 / math.pi;
}

/// Tilt-compensated heading in degrees (`0`–`360`, `0` = magnetic
/// north), or `null` when the current accelerometer/magnetometer pair
/// makes the rotation-matrix math degenerate (near-zero cross product
/// or near-zero gravity vector — e.g. the device is in freefall or the
/// magnetometer reading is all but zero).
double? tiltCompensatedHeadingDegrees(
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
CompassAccuracy classifyCompassAccuracy(MagnetometerEvent event) {
  final magnitude = math.sqrt(
    event.x * event.x + event.y * event.y + event.z * event.z,
  );
  if (magnitude < 15 || magnitude > 90) return CompassAccuracy.uncalibrated;
  if (magnitude < 25 || magnitude > 65) return CompassAccuracy.low;
  return CompassAccuracy.good;
}
