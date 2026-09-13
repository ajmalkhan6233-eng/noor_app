// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of prayer_cubit.dart to keep it under the project's
// line-count convention: a pure check, no cubit/state dependency.

bool isValidCoordinate(double latitude, double longitude) =>
    latitude.abs() <= 90 && longitude.abs() <= 180;

const String invalidCoordinateMessage =
    'Enter a latitude between -90 and 90, and a longitude between -180 and 180.';

/// Shown when GPS fails or permission is denied and prayer times fall
/// back to [colomboFallbackLatitude]/[colomboFallbackLongitude] so the
/// app never shows a blank screen — see PrayerCubit._resolveLocation.
const String gpsFailedFallbackMessage =
    "Couldn't get your location, so prayer times below are for Colombo. "
    'Check location permission in your phone settings, then try again.';

const double colomboFallbackLatitude = 6.9271;
const double colomboFallbackLongitude = 79.8612;
