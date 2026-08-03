// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Presentation only dispatches (`useGps`, `setManualLocation`,
// `setMethod`, `setMadhab`) and reads state — GPS calls and prayer
// math both stay out of the widget tree.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location/location_service.dart';
import '../../data/prayer_repository.dart';
import '../../data/prayer_settings.dart';
import 'prayer_state.dart';

class PrayerCubit extends Cubit<PrayerState> {
  PrayerCubit({PrayerRepository? repository, LocationService? locationService})
    : _repository = repository ?? const PrayerRepository(),
      _locationService = locationService ?? const LocationService(),
      super(PrayerState(date: DateTime.now()));

  final PrayerRepository _repository;
  final LocationService _locationService;

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
          locationError:
              'Location unavailable — check permissions, or enter '
              'coordinates manually below.',
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
          locationError: 'Latitude must be within ±90, longitude within '
              '±180.',
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

  void setMethod(PrayerCalculationMethod method) {
    emit(state.copyWith(settings: state.settings.copyWith(method: method)));
    _recalculate();
  }

  void setMadhab(PrayerMadhab madhab) {
    emit(state.copyWith(settings: state.settings.copyWith(madhab: madhab)));
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
