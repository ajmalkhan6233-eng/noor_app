// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Magnetic declination (the angle between magnetic north and true
// north) from Android's own GeomagneticField, which implements the
// World Magnetic Model. Replaces the old "bearing to the magnetic
// pole" estimate, which was about 6 degrees wrong in Sri Lanka
// (estimate +3.5 E, real value about 2.4 W in Colombo) and up to ~9
// degrees wrong elsewhere — enough to point a person at the wrong
// wall. Offline: GeomagneticField is a formula built into Android, no
// network.

import 'package:flutter/services.dart';

/// Declination in degrees, positive = east of true north. `null` when
/// unavailable (non-Android, or the platform call failed).
typedef DeclinationLookup = Future<double?> Function(double latitude, double longitude);

const MethodChannel _channel = MethodChannel('com.noorapp.noorprayer/geomagnetic');

/// Default [DeclinationLookup], backed by MainActivity.kt.
Future<double?> platformDeclination(double latitude, double longitude) async {
  try {
    final value = await _channel.invokeMethod<double>(
      'declination',
      {'latitude': latitude, 'longitude': longitude},
    );
    if (value == null || !value.isFinite || value.abs() > 90) return null;
    return value;
  } catch (_) {
    return null;
  }
}
