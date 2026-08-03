// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_times/data/prayer_adjustments.dart';
import 'package:noor/features/prayer_times/data/prayer_high_latitude_rule.dart';
import 'package:noor/features/prayer_times/data/prayer_settings.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/app_theme_mode.dart';
import 'package:noor/features/settings/data/notification_settings.dart';

void main() {
  group('AppSettings.copyWith', () {
    test('changes only the requested field', () {
      const original = AppSettings();
      final updated = original.copyWith(arabicFontScale: 1.5);

      expect(updated.arabicFontScale, 1.5);
      expect(updated.themeMode, original.themeMode);
      expect(updated.hijriOffsetDays, original.hijriOffsetDays);
    });

    test('nested prayer settings update independently', () {
      const original = AppSettings();
      final updated = original.copyWith(
        prayerSettings: original.prayerSettings.copyWith(
          method: PrayerCalculationMethod.karachi,
          highLatitudeRule: PrayerHighLatitudeRule.seventhOfNight,
        ),
      );

      expect(updated.prayerSettings.method, PrayerCalculationMethod.karachi);
      expect(
        updated.prayerSettings.highLatitudeRule,
        PrayerHighLatitudeRule.seventhOfNight,
      );
      expect(updated.prayerSettings.madhab, original.prayerSettings.madhab);
    });
  });

  group('PrayerAdjustmentMinutes.copyWith', () {
    test('changes only the requested prayer', () {
      const original = PrayerAdjustmentMinutes();
      final updated = original.copyWith(isha: 5);

      expect(updated.isha, 5);
      expect(updated.fajr, 0);
      expect(updated.dhuhr, 0);
    });
  });

  group('NotificationSettings.copyWith', () {
    test('toggles only the requested prayer', () {
      const original = NotificationSettings();
      final updated = original.copyWith(asr: false);

      expect(updated.asr, isFalse);
      expect(updated.fajr, isTrue);
      expect(updated.isha, isTrue);
    });
  });

  group('AppThemeModeOption.flutterThemeMode', () {
    test('maps every option to a distinct Flutter ThemeMode', () {
      final mapped = AppThemeModeOption.values
          .map((mode) => mode.flutterThemeMode)
          .toSet();
      expect(mapped.length, AppThemeModeOption.values.length);
    });
  });
}
