// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../../settings/data/notification_settings.dart';
import '../../data/iqamath_offsets.dart';
import '../../data/prayer_settings.dart';
import '../../data/prayer_times_result.dart';
import '../../data/silent_mode_settings.dart';

/// Immutable state for the prayer-times feature.
///
/// Coordinates are stored as plain `latitude`/`longitude` doubles —
/// never a package-specific type — and may come from GPS or from
/// fully-sufficient manual entry; neither is ever assumed.
class PrayerState extends Equatable {
  const PrayerState({
    this.latitude,
    this.longitude,
    this.usingGps = false,
    this.settings = const PrayerSettings(),
    required this.date,
    this.result,
    this.isResolvingLocation = false,
    this.locationError,
    this.notifications = const NotificationSettings(),
    this.iqamathOffsets = const IqamathOffsetMinutes(),
    this.silentMode = const SilentModeSettings(),
    this.preReminderEnabled = false,
    this.preReminderMinutes = 10,
  });

  final double? latitude;
  final double? longitude;

  /// True if the current coordinates came from GPS rather than manual
  /// entry — shown in the UI so the source is never ambiguous.
  final bool usingGps;

  final PrayerSettings settings;
  final DateTime date;
  final PrayerTimesResult? result;
  final bool isResolvingLocation;
  final String? locationError;

  /// Read from Settings on [PrayerCubit.loadSettings] and used to
  /// schedule notifications and to show the iqamath column.
  final NotificationSettings notifications;
  final IqamathOffsetMinutes iqamathOffsets;
  final SilentModeSettings silentMode;

  /// Optional local reminder fired [preReminderMinutes] before each
  /// enabled prayer's adhan — separate from the at-prayer-time toggle.
  final bool preReminderEnabled;
  final int preReminderMinutes;

  bool get hasCoordinates => latitude != null && longitude != null;

  PrayerState copyWith({
    double? latitude,
    double? longitude,
    bool? usingGps,
    PrayerSettings? settings,
    DateTime? date,
    PrayerTimesResult? result,
    bool? isResolvingLocation,
    String? locationError,
    NotificationSettings? notifications,
    IqamathOffsetMinutes? iqamathOffsets,
    SilentModeSettings? silentMode,
    bool? preReminderEnabled,
    int? preReminderMinutes,
  }) {
    return PrayerState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      usingGps: usingGps ?? this.usingGps,
      settings: settings ?? this.settings,
      date: date ?? this.date,
      result: result ?? this.result,
      isResolvingLocation: isResolvingLocation ?? false,
      locationError: locationError,
      notifications: notifications ?? this.notifications,
      iqamathOffsets: iqamathOffsets ?? this.iqamathOffsets,
      silentMode: silentMode ?? this.silentMode,
      preReminderEnabled: preReminderEnabled ?? this.preReminderEnabled,
      preReminderMinutes: preReminderMinutes ?? this.preReminderMinutes,
    );
  }

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    usingGps,
    settings.method,
    settings.madhab,
    date,
    result,
    isResolvingLocation,
    locationError,
  ];
}
