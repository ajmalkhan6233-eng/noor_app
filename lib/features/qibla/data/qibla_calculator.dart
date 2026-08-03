// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Great-circle qibla bearing and distance to the Kaaba. Pure math, no
// I/O, no dependencies — device coordinates come in, a bearing and a
// distance come out.

import 'dart:math' as math;

import '../../../core/utils/angle_math.dart';

/// Static great-circle calculations toward the Kaaba, Makkah.
abstract final class QiblaCalculator {
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  /// Mean Earth radius in kilometres, used for great-circle distance.
  static const double _earthRadiusKm = 6371.0;

  /// Initial great-circle bearing from ([latitude], [longitude]) to
  /// the Kaaba, in degrees clockwise from true north, `[0, 360)`.
  static double bearingToKaaba(double latitude, double longitude) {
    final phi1 = _toRadians(latitude);
    final phi2 = _toRadians(kaabaLatitude);
    final deltaLambda = _toRadians(kaabaLongitude - longitude);

    final y = math.sin(deltaLambda) * math.cos(phi2);
    final x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);

    final bearingRadians = math.atan2(y, x);
    return AngleMath.normalise(bearingRadians * 180 / math.pi);
  }

  /// Great-circle distance from ([latitude], [longitude]) to the
  /// Kaaba, in kilometres, via the haversine formula.
  static double distanceToKaabaKm(double latitude, double longitude) {
    final phi1 = _toRadians(latitude);
    final phi2 = _toRadians(kaabaLatitude);
    final deltaPhi = _toRadians(kaabaLatitude - latitude);
    final deltaLambda = _toRadians(kaabaLongitude - longitude);

    final sinDeltaPhi = math.sin(deltaPhi / 2);
    final sinDeltaLambda = math.sin(deltaLambda / 2);
    final a = sinDeltaPhi * sinDeltaPhi +
        math.cos(phi1) * math.cos(phi2) * sinDeltaLambda * sinDeltaLambda;
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return _earthRadiusKm * c;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;
}
