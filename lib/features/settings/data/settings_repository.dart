// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file touches the `app_settings` table. Always a single
// row (`id = 1`); loading before any save exists returns the defaults.

import '../../../core/database/database_helper.dart';
import '../../prayer_times/data/iqamath_offsets.dart';
import '../../prayer_times/data/prayer_adjustments.dart';
import '../../prayer_times/data/prayer_high_latitude_rule.dart';
import '../../prayer_times/data/prayer_settings.dart';
import '../../prayer_times/data/silent_mode_settings.dart';
import 'app_locale.dart';
import 'app_settings.dart';
import 'app_theme_mode.dart';
import 'notification_settings.dart';

class SettingsRepository {
  SettingsRepository({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<AppSettings> load() async {
    final db = await _dbHelper.database;
    final rows = await db.query('app_settings', where: 'id = 1', limit: 1);
    if (rows.isEmpty) return const AppSettings();

    final row = rows.first;
    return AppSettings(
      prayerSettings: PrayerSettings(
        method: PrayerCalculationMethod.values.byName(
          row['calculation_method']! as String,
        ),
        madhab: PrayerMadhab.values.byName(row['madhab']! as String),
        highLatitudeRule: PrayerHighLatitudeRule.values.byName(
          row['high_latitude_rule']! as String,
        ),
        adjustments: PrayerAdjustmentMinutes(
          fajr: row['adjust_fajr_minutes']! as int,
          sunrise: row['adjust_sunrise_minutes']! as int,
          dhuhr: row['adjust_dhuhr_minutes']! as int,
          asr: row['adjust_asr_minutes']! as int,
          maghrib: row['adjust_maghrib_minutes']! as int,
          isha: row['adjust_isha_minutes']! as int,
        ),
      ),
      notifications: NotificationSettings(
        fajr: (row['notify_fajr']! as int) != 0,
        dhuhr: (row['notify_dhuhr']! as int) != 0,
        asr: (row['notify_asr']! as int) != 0,
        maghrib: (row['notify_maghrib']! as int) != 0,
        isha: (row['notify_isha']! as int) != 0,
      ),
      themeMode: AppThemeModeOption.values.byName(
        row['theme_mode']! as String,
      ),
      arabicFontScale: row['arabic_font_scale']! as double,
      hijriOffsetDays: row['hijri_offset_days']! as int,
      locationLabel: row['location_label'] as String?,
      iqamathOffsets: IqamathOffsetMinutes(
        fajr: row['iqamath_fajr_minutes']! as int,
        dhuhr: row['iqamath_dhuhr_minutes']! as int,
        asr: row['iqamath_asr_minutes']! as int,
        maghrib: row['iqamath_maghrib_minutes']! as int,
        isha: row['iqamath_isha_minutes']! as int,
      ),
      silentMode: SilentModeSettings(
        fajr: (row['silent_fajr']! as int) != 0,
        dhuhr: (row['silent_dhuhr']! as int) != 0,
        asr: (row['silent_asr']! as int) != 0,
        maghrib: (row['silent_maghrib']! as int) != 0,
        isha: (row['silent_isha']! as int) != 0,
        extraMinutesAfterIqamath: row['silent_extra_minutes']! as int,
      ),
      selectedDistrict: row['selected_district'] as String?,
      locale: AppLocaleOptionData.fromLanguageCode(
        row['language_code'] as String? ?? 'en',
      ),
    );
  }

  Future<void> save(AppSettings settings) async {
    final db = await _dbHelper.database;
    final prayer = settings.prayerSettings;
    final notify = settings.notifications;
    final iqamath = settings.iqamathOffsets;
    final silent = settings.silentMode;

    final values = {
      'id': 1,
      'calculation_method': prayer.method.name,
      'madhab': prayer.madhab.name,
      'high_latitude_rule': prayer.highLatitudeRule.name,
      'adjust_fajr_minutes': prayer.adjustments.fajr,
      'adjust_sunrise_minutes': prayer.adjustments.sunrise,
      'adjust_dhuhr_minutes': prayer.adjustments.dhuhr,
      'adjust_asr_minutes': prayer.adjustments.asr,
      'adjust_maghrib_minutes': prayer.adjustments.maghrib,
      'adjust_isha_minutes': prayer.adjustments.isha,
      'notify_fajr': notify.fajr ? 1 : 0,
      'notify_dhuhr': notify.dhuhr ? 1 : 0,
      'notify_asr': notify.asr ? 1 : 0,
      'notify_maghrib': notify.maghrib ? 1 : 0,
      'notify_isha': notify.isha ? 1 : 0,
      'theme_mode': settings.themeMode.name,
      'arabic_font_scale': settings.arabicFontScale,
      'hijri_offset_days': settings.hijriOffsetDays,
      'location_label': settings.locationLabel,
      'iqamath_fajr_minutes': iqamath.fajr,
      'iqamath_dhuhr_minutes': iqamath.dhuhr,
      'iqamath_asr_minutes': iqamath.asr,
      'iqamath_maghrib_minutes': iqamath.maghrib,
      'iqamath_isha_minutes': iqamath.isha,
      'silent_fajr': silent.fajr ? 1 : 0,
      'silent_dhuhr': silent.dhuhr ? 1 : 0,
      'silent_asr': silent.asr ? 1 : 0,
      'silent_maghrib': silent.maghrib ? 1 : 0,
      'silent_isha': silent.isha ? 1 : 0,
      'silent_extra_minutes': silent.extraMinutesAfterIqamath,
      'selected_district': settings.selectedDistrict,
      'language_code': settings.locale.languageCode,
    };

    final existing = await db.query('app_settings', where: 'id = 1');
    if (existing.isEmpty) {
      await db.insert('app_settings', values);
    } else {
      await db.update('app_settings', values, where: 'id = 1');
    }
  }
}
