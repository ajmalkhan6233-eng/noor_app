// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Presentation only dispatches `start()` and reads state — location,
// compass, tilt, and qibla math all stay out of the widget tree.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/sensors/compass_reading.dart';
import '../../../../core/sensors/compass_service.dart';
import '../../../../core/sensors/magnetic_declination.dart';
import '../../../../core/sensors/tilt_service.dart';
import '../../../../core/utils/angle_math.dart';
import '../../data/qibla_calculator.dart';
import 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({
    LocationService? locationService,
    CompassService? compassService,
    TiltService? tiltService,
  }) : _locationService = locationService ?? const LocationService(),
       _compassService = compassService ?? CompassService(),
       _tiltService = tiltService ?? TiltService(),
       super(const QiblaState());

  final LocationService _locationService;
  final CompassService _compassService;
  final TiltService _tiltService;
  StreamSubscription<CompassReading>? _compassSubscription;
  StreamSubscription<TiltReading>? _tiltSubscription;

  /// Resolves the device location, computes the static bearing and
  /// distance to the Kaaba, then starts listening to the compass and
  /// the accelerometer (for the compass's tilt effect).
  Future<void> start() async {
    emit(state.copyWith(isResolvingLocation: true, locationError: null));
    final coordinates = await _locationService.getCurrentCoordinates();
    if (coordinates == null) {
      emit(
        state.copyWith(
          isResolvingLocation: false,
          locationError: 'Enable location to see the qibla direction.',
        ),
      );
      return;
    }

    final latitude = coordinates.latitude;
    final longitude = coordinates.longitude;
    final declination = MagneticDeclination.estimate(latitude, longitude);

    emit(
      state.copyWith(
        latitude: latitude,
        longitude: longitude,
        bearingDegrees: QiblaCalculator.bearingToKaaba(latitude, longitude),
        distanceKm: QiblaCalculator.distanceToKaabaKm(latitude, longitude),
        isResolvingLocation: false,
        locationError: null,
      ),
    );

    await _compassSubscription?.cancel();
    _compassSubscription = _compassService.readings.listen((reading) {
      final trueHeading = reading.headingDegrees == null
          ? null
          : AngleMath.normalise(reading.headingDegrees! + declination);
      emit(
        state.copyWith(
          headingDegrees: trueHeading,
          compassAccuracy: reading.accuracy,
        ),
      );
    });

    await _tiltSubscription?.cancel();
    _tiltSubscription = _tiltService.readings.listen((reading) {
      emit(state.copyWith(tiltX: reading.x, tiltY: reading.y));
    });
  }

  @override
  Future<void> close() {
    _compassSubscription?.cancel();
    _tiltSubscription?.cancel();
    return super.close();
  }
}
