// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Device-local GPS only. This service never calls a geocoding API or
// any remote endpoint — it returns raw coordinates for the `adhan`
// package to do offline prayer-time math against.

import 'package:geolocator/geolocator.dart';

/// Simple coordinate pair, decoupled from the `geolocator` package type
/// so `logic/` layers don't need to depend on it directly.
class Coordinates {
  const Coordinates({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
}

/// Resolves the device's current coordinates using on-device GPS only.
class LocationService {
  const LocationService();

  /// Session-wide cache of the last successful fix — shared across
  /// every [LocationService] instance (each screen builds its own),
  /// so an automatic fetch on screen-open never re-queries GPS if one
  /// already succeeded this session. Explicit "Use my location" taps
  /// go through [getCurrentCoordinates] directly, bypassing this.
  static Coordinates? _cachedCoordinates;

  /// Returns the current position, or `null` if permission was denied,
  /// location services are disabled, the fix failed, or it didn't
  /// arrive within [timeout]. Never hangs indefinitely — callers
  /// should fall back to a manually-set city/coordinates in that case.
  Future<Coordinates?> getCurrentCoordinates({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(timeout);
      final coordinates = Coordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      _cachedCoordinates = coordinates;
      return coordinates;
    } catch (_) {
      // Timeout, permission race, service disabled mid-call, or any
      // other platform failure — all fall back the same way: null.
      return null;
    }
  }

  /// For automatic (not user-initiated) fetches, e.g. on screen open:
  /// returns an already-known fix immediately without touching GPS
  /// again, otherwise performs the same bounded fetch as
  /// [getCurrentCoordinates] and caches a successful result.
  Future<Coordinates?> autoFetchCoordinates({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final cached = _cachedCoordinates;
    if (cached != null) return cached;
    return getCurrentCoordinates(timeout: timeout);
  }
}
