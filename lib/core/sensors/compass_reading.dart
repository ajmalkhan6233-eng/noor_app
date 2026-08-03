// Bismillahir Rahmanir Raheem — watermark: ALLAH

/// How much a heading reading can be trusted right now.
enum CompassAccuracy {
  /// No magnetometer stream at all on this device/platform.
  unavailable,

  /// A reading exists but the platform reports no confidence value —
  /// typically means the sensor has not been calibrated this session.
  uncalibrated,

  /// A reading exists with a reported deviation too large to trust.
  low,

  /// A reading exists with acceptable reported deviation.
  good,
}

/// One smoothed compass reading and the confidence behind it.
class CompassReading {
  const CompassReading({required this.headingDegrees, required this.accuracy});

  /// Smoothed magnetic heading in degrees (`0`–`360`, `0` = magnetic
  /// north), or `null` when [accuracy] is [CompassAccuracy.unavailable].
  final double? headingDegrees;

  final CompassAccuracy accuracy;
}
