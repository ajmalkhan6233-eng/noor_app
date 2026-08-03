// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../../../core/sensors/compass_reading.dart';
import '../../../../core/utils/angle_math.dart';

/// Immutable state for the qibla-compass feature.
class QiblaState extends Equatable {
  const QiblaState({
    this.latitude,
    this.longitude,
    this.bearingDegrees,
    this.distanceKm,
    this.isResolvingLocation = false,
    this.locationError,
    this.headingDegrees,
    this.compassAccuracy = CompassAccuracy.unavailable,
  });

  final double? latitude;
  final double? longitude;

  /// True great-circle bearing to the Kaaba from the current
  /// location, in degrees — static once resolved, independent of the
  /// device's current facing direction.
  final double? bearingDegrees;
  final double? distanceKm;

  final bool isResolvingLocation;
  final String? locationError;

  /// Smoothed, declination-corrected true heading of the device, or
  /// `null` while no compass reading has arrived yet (or none ever
  /// will, on a device with no magnetometer).
  final double? headingDegrees;
  final CompassAccuracy compassAccuracy;

  bool get hasLocation => latitude != null && longitude != null;

  /// Angle to rotate a north-up needle so it points at the Kaaba
  /// relative to the device's current facing — `null` until both a
  /// bearing and a live heading are available.
  double? get needleRotationDegrees {
    if (bearingDegrees == null || headingDegrees == null) return null;
    return AngleMath.normalise(bearingDegrees! - headingDegrees!);
  }

  QiblaState copyWith({
    double? latitude,
    double? longitude,
    double? bearingDegrees,
    double? distanceKm,
    bool? isResolvingLocation,
    String? locationError,
    double? headingDegrees,
    CompassAccuracy? compassAccuracy,
  }) {
    return QiblaState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      bearingDegrees: bearingDegrees ?? this.bearingDegrees,
      distanceKm: distanceKm ?? this.distanceKm,
      isResolvingLocation: isResolvingLocation ?? false,
      locationError: locationError,
      headingDegrees: headingDegrees,
      compassAccuracy: compassAccuracy ?? this.compassAccuracy,
    );
  }

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    bearingDegrees,
    distanceKm,
    isResolvingLocation,
    locationError,
    headingDegrees,
    compassAccuracy,
  ];
}
