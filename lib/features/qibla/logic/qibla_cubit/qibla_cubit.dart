// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Presentation only dispatches `start()`/`setManualLocation()` and
// reads state — location, compass, tilt, and qibla math all stay out
// of the widget tree.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/sensors/compass_reading.dart';
import '../../../../core/sensors/compass_service.dart';
import '../../../../core/sensors/magnetic_declination.dart';
import '../../../../core/sensors/tilt_service.dart';
import '../../../../core/utils/angle_math.dart';
import '../../../prayer_times/data/sri_lanka_district.dart';
import '../../../settings/data/settings_repository.dart';
import '../../data/qibla_calculator.dart';
import 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({
    LocationService? locationService,
    CompassService? compassService,
    TiltService? tiltService,
    SettingsRepository? settingsRepository,
  }) : _locationService = locationService ?? const LocationService(),
       _compassService = compassService ?? CompassService(),
       _tiltService = tiltService ?? TiltService(),
       _settingsRepository = settingsRepository ?? SettingsRepository(),
       super(const QiblaState());

  final LocationService _locationService;
  final CompassService _compassService;
  final TiltService _tiltService;
  final SettingsRepository _settingsRepository;
  StreamSubscription<CompassReading>? _compassSubscription;
  StreamSubscription<TiltReading>? _tiltSubscription;

  /// Resolves a location automatically — a cached or bounded GPS fix
  /// first, then a previously chosen Sri Lankan district — so this
  /// always settles within a few seconds rather than hanging on GPS
  /// indefinitely. Only if neither is available does it surface an
  /// error, for the district-picker fallback UI to resolve.
  Future<void> start() async {
    emit(state.copyWith(isResolvingLocation: true, locationError: null));

    final coordinates = await _locationService.autoFetchCoordinates();
    if (coordinates != null) {
      _applyLocation(coordinates.latitude, coordinates.longitude);
      return;
    }

    final appSettings = await _settingsRepository.load();
    final district = findSriLankaDistrict(appSettings.selectedDistrict);
    if (district != null) {
      _applyLocation(district.latitude, district.longitude);
      return;
    }

    emit(
      state.copyWith(
        isResolvingLocation: false,
        locationError:
            'Enable location, or choose a district below, to see the '
            'qibla direction.',
      ),
    );
  }

  /// Lets the district-picker fallback set a location directly when
  /// GPS was unavailable and no district was already known.
  void setManualLocation(double latitude, double longitude) {
    _applyLocation(latitude, longitude);
  }

  void _applyLocation(double latitude, double longitude) {
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
    _listen(declination);
  }

  void _listen(double declination) {
    _compassSubscription?.cancel();
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

    _tiltSubscription?.cancel();
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
