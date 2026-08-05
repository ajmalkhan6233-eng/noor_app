// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../../../core/sensors/compass_reading.dart';
import '../../../../core/utils/angle_math.dart';

/// How close the needle must sit to dead-on before the compass counts
/// as "locked" onto the qibla direction.
const double kQiblaLockThresholdDegrees = 3;

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
    this.tiltX = 0,
    this.tiltY = 0,
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

  /// Device tilt from the accelerometer, -1..1 per axis — purely a
  /// visual cue for the compass's light-sweep effect.
  final double tiltX;
  final double tiltY;

  bool get hasLocation => latitude != null && longitude != null;

  /// Angle to rotate a north-up needle so it points at the Kaaba
  /// relative to the device's current facing — `null` until both a
  /// bearing and a live heading are available.
  double? get needleRotationDegrees {
    if (bearingDegrees == null || headingDegrees == null) return null;
    return AngleMath.normalise(bearingDegrees! - headingDegrees!);
  }

  /// True once the device is facing the qibla closely enough, with a
  /// compass reading trustworthy enough to believe it — the moment a
  /// confirmation burst should fire.
  bool get isLocked {
    final rotation = needleRotationDegrees;
    if (rotation == null || compassAccuracy != CompassAccuracy.good) {
      return false;
    }
    return AngleMath.difference(rotation, 0).abs() <=
        kQiblaLockThresholdDegrees;
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
    double? tiltX,
    double? tiltY,
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
      tiltX: tiltX ?? this.tiltX,
      tiltY: tiltY ?? this.tiltY,
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
    tiltX,
    tiltY,
  ];
}
