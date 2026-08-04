// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file touches `sensors_plus`. Exposes the device's tilt
// (from the accelerometer) as a smoothed, normalised (-1..1) x/y pair
// — purely a visual cue (light sweeping across the compass bezel as
// the phone tilts), never used for any calculation.

import 'package:sensors_plus/sensors_plus.dart';

class TiltReading {
  const TiltReading(this.x, this.y);

  /// Normalised tilt, roughly -1..1 on each axis.
  final double x;
  final double y;
}

class TiltService {
  TiltService({
    this.smoothingFactor = 0.15,
    Stream<AccelerometerEvent>? Function()? eventsProvider,
  }) : _eventsProvider =
           eventsProvider ?? (() => accelerometerEventStream());

  final double smoothingFactor;
  final Stream<AccelerometerEvent>? Function() _eventsProvider;

  double _smoothedX = 0;
  double _smoothedY = 0;

  Stream<TiltReading> get readings {
    final events = _eventsProvider();
    if (events == null) return const Stream.empty();
    return events.map(_toReading);
  }

  TiltReading _toReading(AccelerometerEvent event) {
    // Gravity is ~9.8 m/s^2; clamp to a plausible tilt range and
    // normalise to -1..1 so callers never need to know the unit.
    final rawX = (event.x / 9.8).clamp(-1.0, 1.0);
    final rawY = (event.y / 9.8).clamp(-1.0, 1.0);
    _smoothedX += (rawX - _smoothedX) * smoothingFactor;
    _smoothedY += (rawY - _smoothedY) * smoothingFactor;
    return TiltReading(_smoothedX, _smoothedY);
  }
}
