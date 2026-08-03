// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../data/prayer_settings.dart';
import '../../data/prayer_times_result.dart';

/// Immutable state for the prayer-times feature.
///
/// Coordinates are stored as plain `latitude`/`longitude` doubles —
/// never a package-specific type — and may come from GPS or from
/// fully-sufficient manual entry; neither is ever assumed.
class PrayerState extends Equatable {
  const PrayerState({
    this.latitude,
    this.longitude,
    this.usingGps = false,
    this.settings = const PrayerSettings(),
    required this.date,
    this.result,
    this.isResolvingLocation = false,
    this.locationError,
  });

  final double? latitude;
  final double? longitude;

  /// True if the current coordinates came from GPS rather than manual
  /// entry — shown in the UI so the source is never ambiguous.
  final bool usingGps;

  final PrayerSettings settings;
  final DateTime date;
  final PrayerTimesResult? result;
  final bool isResolvingLocation;
  final String? locationError;

  bool get hasCoordinates => latitude != null && longitude != null;

  PrayerState copyWith({
    double? latitude,
    double? longitude,
    bool? usingGps,
    PrayerSettings? settings,
    DateTime? date,
    PrayerTimesResult? result,
    bool? isResolvingLocation,
    String? locationError,
  }) {
    return PrayerState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      usingGps: usingGps ?? this.usingGps,
      settings: settings ?? this.settings,
      date: date ?? this.date,
      result: result ?? this.result,
      isResolvingLocation: isResolvingLocation ?? false,
      locationError: locationError,
    );
  }

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    usingGps,
    settings.method,
    settings.madhab,
    date,
    result,
    isResolvingLocation,
    locationError,
  ];
}
