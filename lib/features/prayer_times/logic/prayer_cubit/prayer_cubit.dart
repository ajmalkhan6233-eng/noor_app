// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Presentation only dispatches (`useGps`, `setManualLocation`) and
// reads state — GPS calls and prayer math both stay out of the widget
// tree. Calculation method/madhab/adjustments are never set here —
// they're read once from Settings on load; change them in Settings.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location/location_service.dart';
import '../../../settings/data/settings_repository.dart';
import '../../data/prayer_repository.dart';
import 'prayer_state.dart';

class PrayerCubit extends Cubit<PrayerState> {
  PrayerCubit({
    PrayerRepository? repository,
    LocationService? locationService,
    SettingsRepository? settingsRepository,
  }) : _repository = repository ?? const PrayerRepository(),
       _locationService = locationService ?? const LocationService(),
       _settingsRepository = settingsRepository ?? SettingsRepository(),
       super(PrayerState(date: DateTime.now()));

  final PrayerRepository _repository;
  final LocationService _locationService;
  final SettingsRepository _settingsRepository;

  /// Reads the persisted calculation settings — always the single
  /// source of truth — before anything is calculated.
  Future<void> loadSettings() async {
    final appSettings = await _settingsRepository.load();
    emit(state.copyWith(settings: appSettings.prayerSettings));
    _recalculate();
  }

  /// Resolves the device's GPS location. Never called automatically —
  /// only in response to an explicit user action — and manual entry
  /// remains fully usable whether or not this succeeds.
  Future<void> useGps() async {
    emit(state.copyWith(isResolvingLocation: true, locationError: null));
    final coordinates = await _locationService.getCurrentCoordinates();
    if (coordinates == null) {
      emit(
        state.copyWith(
          isResolvingLocation: false,
          locationError: 'Enter your coordinates below to see prayer times.',
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
        usingGps: true,
        isResolvingLocation: false,
        locationError: null,
      ),
    );
    _recalculate();
  }

  /// Sets coordinates directly — fully sufficient on its own, with no
  /// GPS permission ever required.
  void setManualLocation(double latitude, double longitude) {
    if (latitude.abs() > 90 || longitude.abs() > 180) {
      emit(
        state.copyWith(
          locationError:
              'Enter a latitude between -90 and 90, and a longitude '
              'between -180 and 180.',
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        latitude: latitude,
        longitude: longitude,
        usingGps: false,
        locationError: null,
      ),
    );
    _recalculate();
  }

  void _recalculate() {
    if (!state.hasCoordinates) return;
    final result = _repository.calculate(
      coordinates: Coordinates(
        latitude: state.latitude!,
        longitude: state.longitude!,
      ),
      date: state.date,
      settings: state.settings,
    );
    emit(state.copyWith(result: result));
  }
}
