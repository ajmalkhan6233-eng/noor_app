// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The one-time permission run behind the welcome screen's single
// button: location, then notifications, then (only if the phone needs
// it) exact alarms, back to back. A "no" never stops the next step and
// is remembered, so the app asks once and never nags.

import 'package:shared_preferences/shared_preferences.dart';

import 'permission_gateway.dart';

class PermissionResults {
  const PermissionResults({
    required this.location,
    required this.notifications,
    required this.exactAlarm,
  });

  final bool location;
  final bool notifications;

  /// Null when the phone did not need the grant.
  final bool? exactAlarm;
}

class PermissionOnboarding {
  PermissionOnboarding({PermissionGateway? gateway})
    : _gateway = gateway ?? const DevicePermissionGateway();

  final PermissionGateway _gateway;

  static const _locationKey = 'perm_location_granted';
  static const _notificationsKey = 'perm_notifications_granted';
  static const _exactAlarmKey = 'perm_exact_alarm_granted';

  /// Runs the three requests in order and remembers the answers.
  Future<PermissionResults> run() async {
    final location = await _safe(_gateway.requestLocation) ?? false;
    final notifications = await _safe(_gateway.requestNotifications) ?? false;
    final exact = await _safe(_gateway.requestExactAlarm);
    final results = PermissionResults(
      location: location,
      notifications: notifications,
      exactAlarm: exact,
    );
    await remember(results);
    return results;
  }

  Future<T?> _safe<T>(Future<T> Function() step) async {
    try {
      return await step();
    } catch (_) {
      return null; // a failing prompt must not block the next one
    }
  }

  static Future<void> remember(PermissionResults results) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationKey, results.location);
    await prefs.setBool(_notificationsKey, results.notifications);
    if (results.exactAlarm != null) {
      await prefs.setBool(_exactAlarmKey, results.exactAlarm!);
    }
  }

  /// The remembered answers, or null before the first run.
  static Future<PermissionResults?> recall() async {
    final prefs = await SharedPreferences.getInstance();
    final location = prefs.getBool(_locationKey);
    final notifications = prefs.getBool(_notificationsKey);
    if (location == null || notifications == null) return null;
    return PermissionResults(
      location: location,
      notifications: notifications,
      exactAlarm: prefs.getBool(_exactAlarmKey),
    );
  }
}
