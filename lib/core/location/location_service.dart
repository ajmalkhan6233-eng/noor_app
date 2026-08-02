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

  /// Returns the current position, or `null` if permission was denied
  /// or location services are disabled. Callers should fall back to a
  /// manually-set city/coordinates stored locally in that case.
  Future<Coordinates?> getCurrentCoordinates() async {
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
    );
    return Coordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
