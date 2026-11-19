// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/last_known_location.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/features/prayer_times/data/adhan_reciter.dart';
import 'package:noor/features/prayer_times/data/notification_service.dart';
import 'package:noor/features/prayer_times/data/notification_slots.dart';
import 'package:noor/features/prayer_times/data/prayer_notification_coordinator.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';
import 'package:noor/features/prayer_times/logic/prayer_cubit/background_adhan_refresh.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';

class _Settings extends SettingsRepository {
  @override
  Future<AppSettings> load() async => const AppSettings();
}

class _Location extends LastKnownLocationStore {
  const _Location(this.fix);
  final Coordinates? fix;
  @override
  Future<Coordinates?> load() async => fix;
}

class _Recorder extends PrayerNotificationCoordinator {
  final List<int> days = [];
  @override
  Future<void> scheduleForDay({
    required PrayerTimesComputed times,
    required dynamic notifications,
    required dynamic iqamathOffsets,
    required dynamic silentMode,
    bool preReminderEnabled = false,
    int preReminderMinutes = 10,
    int dayOffset = 0,
    AdhanReciter reciter = AdhanReciter.doha,
  }) async {
    days.add(dayOffset);
  }
}

void main() {
  tearDown(() => NotificationService.promptForPermission = true);

  test('background refresh schedules the full 14-day horizon, no permission prompt', () async {
    final recorder = _Recorder();
    await refreshAdhanHorizonInBackground(
      settingsRepository: _Settings(),
      lastKnownLocation: const _Location(Coordinates(latitude: 7.29, longitude: 80.63)),
      notificationCoordinator: recorder,
      clock: () => DateTime(2026, 11, 19, 3),
    );
    expect(notificationSchedulingHorizonDays, 14);
    expect(recorder.days, List.generate(14, (i) => i));
    expect(NotificationService.promptForPermission, isFalse);
  });

  test('no saved location falls back to Colombo, still schedules', () async {
    final recorder = _Recorder();
    await refreshAdhanHorizonInBackground(
      settingsRepository: _Settings(),
      lastKnownLocation: const _Location(null),
      notificationCoordinator: recorder,
      clock: () => DateTime(2026, 11, 19, 3),
    );
    expect(recorder.days.length, 14);
  });
}
