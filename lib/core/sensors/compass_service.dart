// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file touches `flutter_compass`. Raw magnetometer headings
// are jittery frame to frame — every reading is smoothed with
// `AngleMath.smooth` before it ever reaches a cubit or widget.

import 'package:flutter_compass/flutter_compass.dart';

import '../utils/angle_math.dart';
import 'compass_reading.dart';

/// Wraps the device magnetometer as a stream of smoothed, classified
/// [CompassReading]s.
class CompassService {
  CompassService({
    this.smoothingFactor = 0.12,
    this.lowAccuracyThresholdDegrees = 15,
    Stream<CompassEvent>? Function()? eventsProvider,
  }) : _eventsProvider = eventsProvider ?? (() => FlutterCompass.events);

  /// Fraction (`0`–`1`) moved toward each new raw heading per event —
  /// lower is smoother but slower to respond. 0.12 trades a little lag
  /// for enough damping that raw magnetometer noise (visible as needle
  /// jitter at the previous, more reactive 0.25) doesn't show through.
  final double smoothingFactor;

  /// Reported deviation (degrees) above which a reading counts as
  /// [CompassAccuracy.low] rather than [CompassAccuracy.good].
  final double lowAccuracyThresholdDegrees;

  /// Defaults to `FlutterCompass.events`; overridable in tests so raw
  /// magnetometer events never need a real platform channel.
  final Stream<CompassEvent>? Function() _eventsProvider;

  double? _smoothedHeading;

  /// Stream of smoothed readings. Emits a single
  /// [CompassAccuracy.unavailable] reading and nothing further when
  /// this device/platform exposes no magnetometer.
  Stream<CompassReading> get readings {
    final events = _eventsProvider();
    if (events == null) {
      return Stream.value(
        const CompassReading(
          headingDegrees: null,
          accuracy: CompassAccuracy.unavailable,
        ),
      );
    }
    return events.map(_toReading);
  }

  CompassReading _toReading(CompassEvent event) {
    final rawHeading = event.heading;
    if (rawHeading == null) {
      return const CompassReading(
        headingDegrees: null,
        accuracy: CompassAccuracy.unavailable,
      );
    }

    _smoothedHeading = _smoothedHeading == null
        ? AngleMath.normalise(rawHeading)
        : AngleMath.smooth(_smoothedHeading!, rawHeading, smoothingFactor);

    return CompassReading(
      headingDegrees: _smoothedHeading,
      accuracy: _classifyAccuracy(event.accuracy),
    );
  }

  CompassAccuracy _classifyAccuracy(double? accuracyDegrees) {
    if (accuracyDegrees == null) return CompassAccuracy.uncalibrated;
    if (accuracyDegrees.abs() > lowAccuracyThresholdDegrees) {
      return CompassAccuracy.low;
    }
    return CompassAccuracy.good;
  }
}
