// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Presentation only dispatches and reads state — GPS calls and prayer
// math stay out of the widget tree. Calculation settings are read
// once from Settings on load; change them there, not here.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location/location_service.dart';
import '../../../settings/data/settings_repository.dart';
import '../../data/coordinate_bounds.dart';
import '../../data/prayer_notification_coordinator.dart';
import '../../data/prayer_repository.dart';
import 'notification_horizon_scheduler.dart';
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
       _notificationCoordinator = notificationCoordinator ?? PrayerNotificationCoordinator(),
       super(PrayerState(date: DateTime.now()));

  final PrayerRepository _repository;
  final LocationService _locationService;
  final SettingsRepository _settingsRepository;
  final PrayerNotificationCoordinator _notificationCoordinator;

  /// Re-reads every setting from the DB and re-resolves location —
  /// called on first load (HomeDashboard mount) and every time the
  /// Settings screen closes, since Settings is the only place location
  /// is ever changed now and doesn't share this cubit. Always re-runs
  /// resolution (not just when coordinates are still unknown) so a
  /// fresh GPS fix made in Settings takes effect immediately rather
  /// than waiting for the next app launch. GPS-only: no district
  /// override any more (2026-09-13, district picker removed) —
  /// [_autoFetchLocation] is cheap to call even when a fix is already
  /// known, since it returns the cached one instead of touching GPS
  /// again.
  Future<void> loadSettings() async {
    final appSettings = await _settingsRepository.load();
    emit(
      state.copyWith(
        settings: appSettings.prayerSettings,
        notifications: appSettings.notifications,
        iqamathOffsets: appSettings.iqamathOffsets,
        silentMode: appSettings.silentMode,
        preReminderEnabled: appSettings.preReminderEnabled,
        preReminderMinutes: appSettings.preReminderMinutes,
        adhanReciter: appSettings.adhanReciter,
      ),
    );
    await _autoFetchLocation();
  }

  /// Explicit tap — forces a fresh reading, bypassing the auto cache.
  Future<void> useGps() => _resolveLocation(forceFresh: true);

  /// On first open: cached fix if known, else a bounded GPS attempt
  /// that never hangs — the Colombo fallback below covers the rest.
  Future<void> _autoFetchLocation() => _resolveLocation(forceFresh: false);

  /// GPS-only (2026-09-13, district picker removed). When GPS genuinely
  /// fails or permission is denied, falls back to Colombo's coordinates
  /// rather than leaving the screen blank — [gpsFailedFallbackMessage]
  /// tells the user why and invites them to check permissions.
  Future<void> _resolveLocation({required bool forceFresh}) async {
    emit(state.copyWith(isResolvingLocation: true, locationError: null));
    final coordinates = forceFresh
        ? await _locationService.getCurrentCoordinates()
        : await _locationService.autoFetchCoordinates();
    if (coordinates == null) {
      emit(
        state.copyWith(
          latitude: colomboFallbackLatitude,
          longitude: colomboFallbackLongitude,
          usingGps: false,
          isResolvingLocation: false,
          locationError: gpsFailedFallbackMessage,
        ),
      );
      _recalculate();
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
    if (!isValidCoordinate(latitude, longitude)) {
      emit(state.copyWith(locationError: invalidCoordinateMessage));
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
    final coordinates = Coordinates(
      latitude: state.latitude!,
      longitude: state.longitude!,
    );
    final result = _repository.calculate(
      coordinates: coordinates,
      date: state.date,
      settings: state.settings,
    );
    // locationError passed through explicitly: copyWith resets it to
    // null when omitted (by design, so a fresh resolve attempt clears
    // a stale error), but that would otherwise wipe out the Colombo-
    // fallback message the moment this recalculates the result right
    // after setting it.
    emit(state.copyWith(result: result, locationError: state.locationError));
    // Fire-and-forget; see notification_horizon_scheduler.dart.
    unawaited(
      scheduleNotificationHorizon(
        repository: _repository,
        notificationCoordinator: _notificationCoordinator,
        state: state,
        coordinates: coordinates,
      ),
    );
  }
}
