// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Every setting prayer times, qibla, and other screens read display
// or calculation preferences from — one explicit object, never
// scattered defaults.

import '../../prayer_times/data/iqamath_offsets.dart';
import '../../prayer_times/data/prayer_settings.dart';
import '../../prayer_times/data/silent_mode_settings.dart';
import 'app_locale.dart';
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
    this.iqamathOffsets = const IqamathOffsetMinutes(),
    this.silentMode = const SilentModeSettings(),
    this.selectedDistrict,
    this.locale = AppLocaleOption.english,
    this.preReminderEnabled = false,
    this.preReminderMinutes = 10,
    this.hasSeenLocationOnboarding = false,
  });

  final PrayerSettings prayerSettings;
  final NotificationSettings notifications;
  final AppThemeModeOption themeMode;

  /// UI chrome language — never affects Arabic/Quran/Azkar text.
  final AppLocaleOption locale;

  /// Minutes added after each adhan to get the iqamath time, shown as
  /// a second column beside the adhan time.
  final IqamathOffsetMinutes iqamathOffsets;

  /// Per-prayer "silence the phone" toggles plus the extra minutes
  /// kept silent after iqamath.
  final SilentModeSettings silentMode;

  /// Name of the selected Sri Lankan district (see [sriLankaDistricts]),
  /// or `null` when the user is using GPS or manual coordinates.
  final String? selectedDistrict;

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

  /// Optional local reminder fired [preReminderMinutes] before each
  /// enabled prayer's adhan — separate from the at-prayer-time adhan
  /// notification itself. Off by default.
  final bool preReminderEnabled;
  final int preReminderMinutes;

  /// True once the one-time, first-launch location explanation has
  /// been shown (regardless of whether the user granted or skipped
  /// it) — never shown again after that, per the locked "ask once"
  /// rule.
  final bool hasSeenLocationOnboarding;

  AppSettings copyWith({
    PrayerSettings? prayerSettings,
    NotificationSettings? notifications,
    AppThemeModeOption? themeMode,
    double? arabicFontScale,
    int? hijriOffsetDays,
    String? locationLabel,
    IqamathOffsetMinutes? iqamathOffsets,
    SilentModeSettings? silentMode,
    AppLocaleOption? locale,
    bool? preReminderEnabled,
    int? preReminderMinutes,
    bool? hasSeenLocationOnboarding,
  }) {
    return AppSettings(
      prayerSettings: prayerSettings ?? this.prayerSettings,
      notifications: notifications ?? this.notifications,
      themeMode: themeMode ?? this.themeMode,
      arabicFontScale: arabicFontScale ?? this.arabicFontScale,
      hijriOffsetDays: hijriOffsetDays ?? this.hijriOffsetDays,
      locationLabel: locationLabel ?? this.locationLabel,
      iqamathOffsets: iqamathOffsets ?? this.iqamathOffsets,
      silentMode: silentMode ?? this.silentMode,
      selectedDistrict: selectedDistrict,
      locale: locale ?? this.locale,
      preReminderEnabled: preReminderEnabled ?? this.preReminderEnabled,
      preReminderMinutes: preReminderMinutes ?? this.preReminderMinutes,
      hasSeenLocationOnboarding: hasSeenLocationOnboarding ?? this.hasSeenLocationOnboarding,
    );
  }

  /// Sets (or clears) the selected district explicitly — `copyWith`
  /// can't distinguish "leave unchanged" from "set to null", so this
  /// dedicated method exists for the one field that must support both.
  AppSettings withSelectedDistrict(String? district) {
    return AppSettings(
      prayerSettings: prayerSettings,
      notifications: notifications,
      themeMode: themeMode,
      arabicFontScale: arabicFontScale,
      hijriOffsetDays: hijriOffsetDays,
      locationLabel: locationLabel,
      iqamathOffsets: iqamathOffsets,
      silentMode: silentMode,
      selectedDistrict: district,
      locale: locale,
      preReminderEnabled: preReminderEnabled,
      preReminderMinutes: preReminderMinutes,
      hasSeenLocationOnboarding: hasSeenLocationOnboarding,
    );
  }
}
