// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of prayer_cubit.dart to keep it under the project's
// line-count convention: a pure check, no cubit/state dependency.

bool isValidCoordinate(double latitude, double longitude) =>
    latitude.abs() <= 90 && longitude.abs() <= 180;

const String invalidCoordinateMessage =
    'Enter a latitude between -90 and 90, and a longitude between -180 and 180.';

const String manualEntryPromptMessage =
    'Enter your coordinates below to see prayer times.';
