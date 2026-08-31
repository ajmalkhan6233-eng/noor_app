// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Presentation only dispatches `start()`/`setManualLocation()` and
// reads state. Sensor-stream wiring lives in qibla_sensor_binder.dart.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/sensors/compass_reading.dart';
import '../../../../core/sensors/compass_service.dart';
import '../../../../core/sensors/magnetic_declination.dart';
import '../../../../core/sensors/tilt_service.dart';
import '../../../prayer_times/data/sri_lanka_district.dart';
import '../../../settings/data/settings_repository.dart';
import '../../data/qibla_calculator.dart';
import 'qibla_accuracy_debouncer.dart';
import 'qibla_sensor_binder.dart';
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
  QiblaSensorSubscriptions? _sensorSubscriptions;
  Timer? _compassStallTimer;

  /// If flutter_compass genuinely never delivers a first event (seen
  /// live: the needle stayed on an infinite loading spinner
  /// indefinitely) there's no other signal anything is wrong —
  /// [CompassAccuracy.unavailable] only covers "no magnetometer at
  /// all", not "has one, but the stream just isn't producing".
  static const _compassStallTimeout = Duration(seconds: 5);

  final _debouncer = QiblaAccuracyDebouncer();

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
      _applyLocation(district.latitude, district.longitude, originLabel: district.name);
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
  void setManualLocation(double latitude, double longitude, {String? originLabel}) {
    _applyLocation(latitude, longitude, originLabel: originLabel);
  }

  void _applyLocation(double latitude, double longitude, {String? originLabel}) {
    final declination = MagneticDeclination.estimate(latitude, longitude);
    emit(
      state.copyWith(
        latitude: latitude,
        longitude: longitude,
        bearingDegrees: QiblaCalculator.bearingToKaaba(latitude, longitude),
        distanceKm: QiblaCalculator.distanceToKaabaKm(latitude, longitude),
        isResolvingLocation: false,
        locationError: null,
        originLabel: originLabel,
      ),
    );
    _listen(declination);
  }

  void _listen(double declination) {
    _sensorSubscriptions?.cancel();
    _compassStallTimer?.cancel();
    _compassStallTimer = Timer(_compassStallTimeout, () {
      if (!isClosed) emit(state.copyWith(compassStalled: true));
    });

    _sensorSubscriptions = bindQiblaSensors(
      compassService: _compassService,
      tiltService: _tiltService,
      debouncer: _debouncer,
      declination: declination,
      state: () => state,
      emit: emit,
      onFirstCompassReading: () => _compassStallTimer?.cancel(),
      onCompassError: _handleCompassError,
    );
  }

  /// A platform channel throwing instead of returning a null/degraded
  /// reading — seen on cloud emulators (Appetize and similar) that
  /// don't simulate a real magnetometer, where the sensor plugin's
  /// channel setup itself fails rather than just reporting "no
  /// heading". Degrades to the same [CompassAccuracy.unavailable]
  /// state the service itself already uses for "no magnetometer at
  /// all", so the UI (the existing "compass sensor isn't responding"
  /// message) needs no separate handling for this.
  void _handleCompassError() {
    if (isClosed) return;
    _compassStallTimer?.cancel();
    emit(
      state.copyWith(
        compassAccuracy: CompassAccuracy.unavailable,
        displayAccuracy: _debouncer(CompassAccuracy.unavailable),
        compassStalled: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _sensorSubscriptions?.cancel();
    _compassStallTimer?.cancel();
    return super.close();
  }
}
