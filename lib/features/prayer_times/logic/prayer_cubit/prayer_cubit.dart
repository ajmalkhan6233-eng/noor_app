// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Presentation only dispatches and reads state — GPS calls and prayer
// math stay out of the widget tree. Calculation settings are read
// once from Settings on load; change them there, not here.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location/location_service.dart';
import '../../../settings/data/settings_repository.dart';
import '../../data/prayer_notification_coordinator.dart';
import '../../data/prayer_repository.dart';
import '../../data/prayer_times_result.dart';
import '../../data/sri_lanka_district.dart';
import 'prayer_state.dart';

class PrayerCubit extends Cubit<PrayerState> {
  PrayerCubit({
    PrayerRepository? repository,
    LocationService? locationService,
    SettingsRepository? settingsRepository,
    PrayerNotificationCoordinator? notificationCoordinator,
  }) : _repository = repository ?? const PrayerRepository(),
       _locationService = locationService ?? const LocationService(),
       _settingsRepository = settingsRepository ?? SettingsRepository(),
       _notificationCoordinator =
           notificationCoordinator ?? PrayerNotificationCoordinator(),
       super(PrayerState(date: DateTime.now()));

  final PrayerRepository _repository;
  final LocationService _locationService;
  final SettingsRepository _settingsRepository;
  final PrayerNotificationCoordinator _notificationCoordinator;

  /// Re-applies a previously chosen district, if any — sticky, never
  /// silently overridden by GPS later. Otherwise auto-fetches GPS
  /// (bounded, see [_autoFetchLocation]) instead of waiting for a tap.
  Future<void> loadSettings() async {
    final appSettings = await _settingsRepository.load();
    emit(
      state.copyWith(
        settings: appSettings.prayerSettings,
        notifications: appSettings.notifications,
        iqamathOffsets: appSettings.iqamathOffsets,
        silentMode: appSettings.silentMode,
      ),
    );
    final district = findSriLankaDistrict(appSettings.selectedDistrict);
    if (district != null) {
      emit(
        state.copyWith(
          latitude: district.latitude,
          longitude: district.longitude,
          usingGps: false,
        ),
      );
    }
    if (state.hasCoordinates) {
      _recalculate();
    } else {
      await _autoFetchLocation();
    }
  }

  /// Explicit tap — forces a fresh reading, bypassing the auto cache.
  Future<void> useGps() => _resolveLocation(forceFresh: true);

  /// On first open: cached fix if known, else a bounded GPS attempt
  /// (see [LocationService]) that never hangs — the always-visible
  /// manual/district selectors are the fallback on failure.
  Future<void> _autoFetchLocation() => _resolveLocation(forceFresh: false);

  Future<void> _resolveLocation({required bool forceFresh}) async {
    emit(state.copyWith(isResolvingLocation: true, locationError: null));
    final coordinates = forceFresh
        ? await _locationService.getCurrentCoordinates()
        : await _locationService.autoFetchCoordinates();
    if (coordinates == null) {
      // Auto-fetch fails silently into the selectors below; only a
      // manual tap gets an explicit message, as a direct response.
      emit(
        state.copyWith(
          isResolvingLocation: false,
          locationError: forceFresh
              ? 'Enter your coordinates below to see prayer times.'
              : null,
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

  /// Fully sufficient on its own — no GPS permission ever required.
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
    // Fire-and-forget: never blocks display or crashes the cubit.
    if (result is PrayerTimesComputed) {
      unawaited(
        _notificationCoordinator
            .scheduleForDay(
              times: result,
              notifications: state.notifications,
              iqamathOffsets: state.iqamathOffsets,
              silentMode: state.silentMode,
            )
            .catchError((_) {}),
      );
    }
  }
}
