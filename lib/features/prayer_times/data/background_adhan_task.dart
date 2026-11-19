// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Android WorkManager plumbing for the once-a-day adhan refresh (see
// background_adhan_refresh.dart). Runs on the phone only; no network
// constraint, no foreground service.

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:workmanager/workmanager.dart';

import '../logic/prayer_cubit/background_adhan_refresh.dart';

const String dailyAdhanRefreshTask = 'noor-daily-adhan-refresh';

/// Entry point WorkManager starts in a background isolate.
@pragma('vm:entry-point')
void noorBackgroundDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await refreshAdhanHorizonInBackground();
    } catch (_) {
      // Never let a failure retry-loop; the app refreshes on next open.
    }
    return true;
  });
}

/// Registers the daily job once (KEEP: re-registering on every launch
/// does not reset its timer). Safe to call every start.
Future<void> registerDailyAdhanRefresh() async {
  if (kIsWeb || !Platform.isAndroid) return;
  try {
    await Workmanager().initialize(noorBackgroundDispatcher);
    await Workmanager().registerPeriodicTask(
      dailyAdhanRefreshTask,
      dailyAdhanRefreshTask,
      frequency: const Duration(hours: 24),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  } catch (_) {}
}
