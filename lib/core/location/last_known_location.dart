// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The last location a real fix produced, kept on the device only, so
// prayer times quietly keep using it when a later fix is not available
// (location off, indoors, permission withdrawn).

import 'package:shared_preferences/shared_preferences.dart';

import 'location_service.dart';

class LastKnownLocationStore {
  const LastKnownLocationStore();

  static const _latKey = 'last_known_latitude';
  static const _lonKey = 'last_known_longitude';

  Future<void> save(Coordinates coordinates) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_latKey, coordinates.latitude);
      await prefs.setDouble(_lonKey, coordinates.longitude);
    } catch (_) {}
  }

  Future<Coordinates?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble(_latKey);
      final lon = prefs.getDouble(_lonKey);
      if (lat == null || lon == null) return null;
      return Coordinates(latitude: lat, longitude: lon);
    } catch (_) {
      return null;
    }
  }
}
