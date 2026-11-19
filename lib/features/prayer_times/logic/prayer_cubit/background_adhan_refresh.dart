// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// What the daily background job does (2026-11-19): re-schedule the
// adhan horizon from saved settings and the last known location, with
// no screen and no network. Without it, a person who never opens the
// app stopped getting the adhan once the scheduled days ran out.
// Silent Mode windows are left to the app itself (their native channel
// lives on the screen's engine); notifications are what matter here.

import '../../../../core/location/last_known_location.dart';
import '../../../../core/location/location_service.dart';
import '../../../settings/data/settings_repository.dart';
import '../../data/coordinate_bounds.dart';
import '../../data/notification_service.dart';
import '../../data/prayer_notification_coordinator.dart';
import '../../data/prayer_repository.dart';
import 'notification_horizon_scheduler.dart';
import 'prayer_state.dart';

Future<void> refreshAdhanHorizonInBackground({
  SettingsRepository? settingsRepository,
  LastKnownLocationStore lastKnownLocation = const LastKnownLocationStore(),
  PrayerRepository repository = const PrayerRepository(),
  PrayerNotificationCoordinator? notificationCoordinator,
  DateTime Function() clock = DateTime.now,
}) async {
  NotificationService.promptForPermission = false;
  final settings = await (settingsRepository ?? SettingsRepository()).load();
  final last = await lastKnownLocation.load();
  final coordinates = Coordinates(
    latitude: last?.latitude ?? colomboFallbackLatitude,
    longitude: last?.longitude ?? colomboFallbackLongitude,
  );
  final today = clock();
  final state = PrayerState(
    date: today,
    latitude: coordinates.latitude,
    longitude: coordinates.longitude,
    settings: settings.prayerSettings,
    result: repository.calculate(
      coordinates: coordinates,
      date: today,
      settings: settings.prayerSettings,
    ),
    notifications: settings.notifications,
    iqamathOffsets: settings.iqamathOffsets,
    silentMode: settings.silentMode,
    preReminderEnabled: settings.preReminderEnabled,
    preReminderMinutes: settings.preReminderMinutes,
    adhanReciter: settings.adhanReciter,
  );
  await scheduleNotificationHorizon(
    repository: repository,
    notificationCoordinator: notificationCoordinator ?? PrayerNotificationCoordinator(),
    state: state,
    coordinates: coordinates,
  );
}
