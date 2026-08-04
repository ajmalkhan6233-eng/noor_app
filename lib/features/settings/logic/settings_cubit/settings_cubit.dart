// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Presentation only dispatches setters and reads state — every
// change is persisted immediately so Prayer Times/Qibla see it on
// their next read.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../prayer_times/data/iqamath_offsets.dart';
import '../../../prayer_times/data/prayer_adjustments.dart';
import '../../../prayer_times/data/prayer_high_latitude_rule.dart';
import '../../../prayer_times/data/prayer_settings.dart';
import '../../../prayer_times/data/silent_mode_settings.dart';
import '../../data/app_locale.dart';
import '../../data/app_settings.dart';
import '../../data/app_theme_mode.dart';
import '../../data/notification_settings.dart';
import '../../data/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({SettingsRepository? repository})
    : _repository = repository ?? SettingsRepository(),
      super(const SettingsState());

  final SettingsRepository _repository;

  Future<void> load() async {
    final settings = await _repository.load();
    emit(SettingsState(settings: settings, isLoading: false));
  }

  Future<void> setMethod(PrayerCalculationMethod method) => _update(
    (s) => s.copyWith(prayerSettings: s.prayerSettings.copyWith(method: method)),
  );

  Future<void> setMadhab(PrayerMadhab madhab) => _update(
    (s) => s.copyWith(prayerSettings: s.prayerSettings.copyWith(madhab: madhab)),
  );

  Future<void> setHighLatitudeRule(PrayerHighLatitudeRule rule) => _update(
    (s) => s.copyWith(
      prayerSettings: s.prayerSettings.copyWith(highLatitudeRule: rule),
    ),
  );

  Future<void> setAdjustments(PrayerAdjustmentMinutes adjustments) => _update(
    (s) => s.copyWith(
      prayerSettings: s.prayerSettings.copyWith(adjustments: adjustments),
    ),
  );

  Future<void> setNotifications(NotificationSettings notifications) =>
      _update((s) => s.copyWith(notifications: notifications));

  Future<void> setThemeMode(AppThemeModeOption themeMode) =>
      _update((s) => s.copyWith(themeMode: themeMode));

  Future<void> setArabicFontScale(double scale) =>
      _update((s) => s.copyWith(arabicFontScale: scale));

  Future<void> setHijriOffsetDays(int days) =>
      _update((s) => s.copyWith(hijriOffsetDays: days));

  Future<void> setLocationLabel(String? label) =>
      _update((s) => AppSettings(
        prayerSettings: s.prayerSettings,
        notifications: s.notifications,
        themeMode: s.themeMode,
        arabicFontScale: s.arabicFontScale,
        hijriOffsetDays: s.hijriOffsetDays,
        locationLabel: label,
        iqamathOffsets: s.iqamathOffsets,
        silentMode: s.silentMode,
        selectedDistrict: s.selectedDistrict,
        locale: s.locale,
      ));

  Future<void> setIqamathOffsets(IqamathOffsetMinutes offsets) =>
      _update((s) => s.copyWith(iqamathOffsets: offsets));

  Future<void> setSilentMode(SilentModeSettings silentMode) =>
      _update((s) => s.copyWith(silentMode: silentMode));

  /// Sets or clears (pass `null`) the selected Sri Lankan district.
  Future<void> setSelectedDistrict(String? district) =>
      _update((s) => s.withSelectedDistrict(district));

  /// Switches the app's UI chrome language — takes effect immediately,
  /// no restart required. Never affects Arabic/Quran/Azkar text.
  Future<void> setLocale(AppLocaleOption locale) =>
      _update((s) => s.copyWith(locale: locale));

  Future<void> _update(AppSettings Function(AppSettings) updater) async {
    final next = updater(state.settings);
    emit(state.copyWith(settings: next));
    await _repository.save(next);
  }
}
