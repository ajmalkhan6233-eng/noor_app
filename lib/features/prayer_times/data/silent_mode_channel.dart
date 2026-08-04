// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Clean Dart face on the native `com.noorapp.noor/silent_mode`
// MethodChannel — the only file that knows the channel name or its
// method/argument shapes. See `android/.../MainActivity.kt` and
// `SilentModeReceiver.kt` for the platform side. This cannot be
// exercised in this offline dev environment (no device/emulator);
// the API shape mirrors standard `AudioManager`/`AlarmManager` usage.

import 'package:flutter/services.dart';

/// Wraps the native ringer-mode scheduling used for Silent Mode
/// (silencing the phone from adhan until iqamath + a grace period).
class SilentModeChannel {
  const SilentModeChannel();

  static const MethodChannel _channel = MethodChannel(
    'com.noorapp.noor/silent_mode',
  );

  /// Whether Do Not Disturb / notification-policy access has been
  /// granted — required on Android 6+ to change ringer mode.
  Future<bool> hasNotificationPolicyAccess() async {
    final result = await _channel.invokeMethod<bool>(
      'hasNotificationPolicyAccess',
    );
    return result ?? false;
  }

  /// Opens the system settings screen where the user grants
  /// notification-policy access.
  Future<void> requestNotificationPolicyAccess() async {
    await _channel.invokeMethod<void>('requestNotificationPolicyAccess');
  }

  /// Schedules the phone to go silent at [start] and return to normal
  /// ringer volume at [end]. [requestCode] must be stable per prayer
  /// per day so re-scheduling replaces rather than stacks alarms.
  Future<void> scheduleSilentWindow({
    required DateTime start,
    required DateTime end,
    required int requestCode,
  }) async {
    await _channel.invokeMethod<void>('scheduleSilentWindow', {
      'startEpochMillis': start.millisecondsSinceEpoch,
      'endEpochMillis': end.millisecondsSinceEpoch,
      'requestCode': requestCode,
    });
  }

  /// Cancels a previously scheduled silent window, if any.
  Future<void> cancelSilentWindow(int requestCode) async {
    await _channel.invokeMethod<void>('cancelSilentWindow', {
      'requestCode': requestCode,
    });
  }
}
