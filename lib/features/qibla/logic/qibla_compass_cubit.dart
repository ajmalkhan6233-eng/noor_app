// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Drives the Qibla screen: a location (device fix, else a quiet
// default), the unchanged bearing/distance maths, and a smoothed live
// heading. Without a compass the state says so and the screen shows a
// static arrow — never an error screen.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/haptics/haptic_service.dart';
import '../../../core/location/location_service.dart';
import '../../../core/sensors/compass_reading.dart';
import '../../../core/sensors/compass_service.dart';
import '../../../core/sensors/magnetic_declination.dart';
import '../../../core/utils/angle_math.dart';
import '../../prayer_times/data/coordinate_bounds.dart';
import '../data/qibla_calculator.dart';
import 'heading_filter.dart';
import 'qibla_compass_state.dart';

class QiblaCompassCubit extends Cubit<QiblaCompassState> {
  QiblaCompassCubit({
    LocationService? locationService,
    CompassService? compassService,
    HapticService? hapticService,
    HeadingFilter? filter,
    this.noSensorTimeout = const Duration(seconds: 4),
  }) : _location = locationService ?? const LocationService(),
       _compass = compassService ?? CompassService(),
       _haptics = hapticService ?? const HapticService(),
       _filter = filter ?? HeadingFilter(),
       super(const QiblaCompassState());

  final LocationService _location;
  final CompassService _compass;
  final HapticService _haptics;
  final HeadingFilter _filter;

  /// How long to wait for a first compass reading before treating the
  /// compass as missing.
  final Duration noSensorTimeout;

  StreamSubscription<CompassReading>? _subscription;
  Timer? _timeout;
  double _declination = 0;

  Future<void> start() async {
    emit(state.copyWith(loading: true));
    Coordinates? coordinates;
    try {
      coordinates = await _location.autoFetchCoordinates();
    } catch (_) {}
    if (isClosed) return;
    _applyLocation(
      coordinates?.latitude ?? colomboFallbackLatitude,
      coordinates?.longitude ?? colomboFallbackLongitude,
      approximate: coordinates == null,
    );
    _listen();
  }

  /// The "Allow location" button: asks once, then recomputes.
  Future<void> useRealLocation() async {
    Coordinates? coordinates;
    try {
      coordinates = await _location.getCurrentCoordinates();
    } catch (_) {}
    if (coordinates == null || isClosed) return;
    _applyLocation(coordinates.latitude, coordinates.longitude, approximate: false);
  }

  void _applyLocation(double latitude, double longitude, {required bool approximate}) {
    _declination = MagneticDeclination.estimate(latitude, longitude);
    emit(
      state.copyWith(
        loading: false,
        bearing: QiblaCalculator.bearingToKaaba(latitude, longitude),
        distanceKm: QiblaCalculator.distanceToKaabaKm(latitude, longitude),
        approximateLocation: approximate,
      ),
    );
  }

  void _listen() {
    _subscription?.cancel();
    _timeout?.cancel();
    _timeout = Timer(noSensorTimeout, _markNoSensor);
    try {
      _subscription = _compass.readings.listen(_onReading, onError: (_) => _markNoSensor());
    } catch (_) {
      _markNoSensor();
    }
  }

  void _onReading(CompassReading reading) {
    if (isClosed) return;
    final magnetic = reading.headingDegrees;
    if (magnetic == null || reading.accuracy == CompassAccuracy.unavailable) {
      _markNoSensor();
      return;
    }
    _timeout?.cancel();
    final heading = _filter.update(AngleMath.normalise(magnetic + _declination));
    final wasAligned = state.aligned;
    if (state.heading != null &&
        !state.sensorUnavailable &&
        state.accuracy == reading.accuracy &&
        AngleMath.difference(heading, state.heading!).abs() < 0.3) {
      return; // too small to redraw
    }
    emit(state.copyWith(heading: heading, accuracy: reading.accuracy, sensorUnavailable: false));
    if (!wasAligned && state.aligned) _haptics.tap();
  }

  void _markNoSensor() {
    if (isClosed || state.hasHeading) return;
    _timeout?.cancel();
    emit(state.copyWith(sensorUnavailable: true));
  }

  @override
  Future<void> close() {
    _timeout?.cancel();
    _subscription?.cancel();
    return super.close();
  }
}
