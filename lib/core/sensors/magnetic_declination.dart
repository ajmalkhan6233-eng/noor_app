// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Offline, dependency-free estimate of magnetic declination — the
// angle between magnetic north and true north — so a compass heading
// can be corrected without ever calling a remote geomagnetic-model
// service. This is a simple dipole approximation (bearing toward the
// geomagnetic north pole), not the full WMM: good enough to correct a
// hand-held compass, not survey-grade.

import 'dart:math' as math;

abstract final class MagneticDeclination {
  /// Approximate geomagnetic north pole location (~2025 epoch). Drifts
  /// a fraction of a degree per year; not worth updating more than
  /// occasionally for this app's purposes.
  static const double _poleLatitude = 86.5;
  static const double _poleLongitude = 164.04;

  /// Estimated declination in degrees at [latitude]/[longitude]:
  /// positive means magnetic north reads east of true north.
  static double estimate(double latitude, double longitude) {
    final bearingToPole = _bearingTo(
      latitude,
      longitude,
      _poleLatitude,
      _poleLongitude,
    );
    // Fold the 0-360 bearing into a signed (-180, 180] deviation from
    // true north (0°).
    final signed = bearingToPole > 180 ? bearingToPole - 360 : bearingToPole;
    return signed;
  }

  static double _bearingTo(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final phi1 = lat1 * math.pi / 180;
    final phi2 = lat2 * math.pi / 180;
    final deltaLambda = (lon2 - lon1) * math.pi / 180;

    final y = math.sin(deltaLambda) * math.cos(phi2);
    final x =
        math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);

    final bearingRadians = math.atan2(y, x);
    final bearingDegrees = bearingRadians * 180 / math.pi;
    return bearingDegrees < 0 ? bearingDegrees + 360 : bearingDegrees;
  }
}
