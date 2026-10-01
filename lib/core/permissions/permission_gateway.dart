// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The three first-run permissions behind one small interface, so the
// welcome flow can be tested without a phone. The device version uses
// the same plugins the rest of the app already uses.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../location/location_service.dart';

abstract class PermissionGateway {
  /// Shows the system location prompt if needed. True when granted.
  Future<bool> requestLocation();

  /// Shows the system notification prompt if needed. True when granted.
  Future<bool> requestNotifications();

  /// Opens "Alarms & reminders" only when the phone needs it. Returns
  /// null when the phone does not need (or cannot report) the grant.
  Future<bool?> requestExactAlarm();
}

class DevicePermissionGateway implements PermissionGateway {
  const DevicePermissionGateway({this.locationService = const LocationService()});

  final LocationService locationService;

  AndroidFlutterLocalNotificationsPlugin? get _android => FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  @override
  Future<bool> requestLocation() async {
    final fix = await locationService.getCurrentCoordinates();
    return fix != null || await locationService.hasPermission();
  }

  @override
  Future<bool> requestNotifications() async {
    try {
      return await _android?.requestNotificationsPermission() ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool?> requestExactAlarm() async {
    try {
      final android = _android;
      if (android == null) return null;
      final can = await android.canScheduleExactNotifications();
      if (can != false) return null;
      await android.requestExactAlarmsPermission();
      return await android.canScheduleExactNotifications();
    } catch (_) {
      return null;
    }
  }
}
