// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../../core/sensors/compass_reading.dart';
import '../../../core/utils/angle_math.dart';

class QiblaCompassState extends Equatable {
  const QiblaCompassState({
    this.loading = true,
    this.bearing,
    this.distanceKm,
    this.heading,
    this.accuracy = CompassAccuracy.unavailable,
    this.sensorUnavailable = false,
    this.approximateLocation = false,
  });

  final bool loading;

  /// Qibla bearing in degrees clockwise from true north.
  final double? bearing;
  final double? distanceKm;

  /// Smoothed device heading, degrees from true north. Null until the
  /// first sensor reading, and always null without a compass sensor.
  final double? heading;
  final CompassAccuracy accuracy;

  /// True when the phone has no usable compass (or it never answered).
  final bool sensorUnavailable;

  /// True when no location was available and a default is in use.
  final bool approximateLocation;

  bool get hasHeading => heading != null && !sensorUnavailable;

  /// The needle's angle relative to the top of the phone.
  double? get needleAngle {
    final b = bearing;
    if (b == null) return null;
    final h = hasHeading ? heading! : 0.0;
    return AngleMath.normalise(b - h);
  }

  /// Facing the Qibla to within 3 degrees.
  bool get aligned {
    final b = bearing;
    final h = heading;
    if (b == null || h == null || sensorUnavailable) return false;
    return AngleMath.difference(b, h).abs() <= 3;
  }

  /// Compass accuracy is poor enough to suggest the figure-8 movement.
  bool get needsCalibration =>
      hasHeading && (accuracy == CompassAccuracy.low || accuracy == CompassAccuracy.uncalibrated);

  QiblaCompassState copyWith({
    bool? loading,
    double? bearing,
    double? distanceKm,
    double? heading,
    CompassAccuracy? accuracy,
    bool? sensorUnavailable,
    bool? approximateLocation,
  }) {
    return QiblaCompassState(
      loading: loading ?? this.loading,
      bearing: bearing ?? this.bearing,
      distanceKm: distanceKm ?? this.distanceKm,
      heading: heading ?? this.heading,
      accuracy: accuracy ?? this.accuracy,
      sensorUnavailable: sensorUnavailable ?? this.sensorUnavailable,
      approximateLocation: approximateLocation ?? this.approximateLocation,
    );
  }

  @override
  List<Object?> get props =>
      [loading, bearing, distanceKm, heading, accuracy, sensorUnavailable, approximateLocation];
}
