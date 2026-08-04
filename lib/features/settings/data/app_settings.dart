// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Every setting prayer times, qibla, and other screens read display
// or calculation preferences from — one explicit object, never
// scattered defaults.

import '../../prayer_times/data/prayer_settings.dart';
import 'app_theme_mode.dart';
import 'notification_settings.dart';

class AppSettings {
  const AppSettings({
    this.prayerSettings = const PrayerSettings(),
    this.notifications = const NotificationSettings(),
    this.themeMode = AppThemeModeOption.dark,
    this.arabicFontScale = 1.0,
    this.hijriOffsetDays = 0,
    this.locationLabel,
  });

  final PrayerSettings prayerSettings;
  final NotificationSettings notifications;
  final AppThemeModeOption themeMode;

  /// Scale factor applied to Arabic text throughout the app (Quran,
  /// Azkar) — `1.0` is the base design size.
  final double arabicFontScale;

  /// Manual correction (days) applied to the calculated Hijri date,
  /// for local moon-sighting differences.
  final int hijriOffsetDays;

  /// User-entered display name for the current location, e.g.
  /// "Amman, Jordan" — the app never resolves this itself (no
  /// geocoding, no network); `null` until the user sets it.
  final String? locationLabel;

  AppSettings copyWith({
    PrayerSettings? prayerSettings,
    NotificationSettings? notifications,
    AppThemeModeOption? themeMode,
    double? arabicFontScale,
    int? hijriOffsetDays,
    String? locationLabel,
  }) {
    return AppSettings(
      prayerSettings: prayerSettings ?? this.prayerSettings,
      notifications: notifications ?? this.notifications,
      themeMode: themeMode ?? this.themeMode,
      arabicFontScale: arabicFontScale ?? this.arabicFontScale,
      hijriOffsetDays: hijriOffsetDays ?? this.hijriOffsetDays,
      locationLabel: locationLabel ?? this.locationLabel,
    );
  }
}
