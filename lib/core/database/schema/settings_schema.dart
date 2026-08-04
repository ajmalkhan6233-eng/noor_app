// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Single-row settings table (enforced by the `id = 1` check) — the
// one source of truth prayer times, qibla, and every other screen
// read display/calculation preferences from.

const List<String> settingsCreateStatements = [
  '''
  CREATE TABLE app_settings (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    calculation_method TEXT NOT NULL,
    madhab TEXT NOT NULL,
    high_latitude_rule TEXT NOT NULL,
    adjust_fajr_minutes INTEGER NOT NULL DEFAULT 0,
    adjust_sunrise_minutes INTEGER NOT NULL DEFAULT 0,
    adjust_dhuhr_minutes INTEGER NOT NULL DEFAULT 0,
    adjust_asr_minutes INTEGER NOT NULL DEFAULT 0,
    adjust_maghrib_minutes INTEGER NOT NULL DEFAULT 0,
    adjust_isha_minutes INTEGER NOT NULL DEFAULT 0,
    notify_fajr INTEGER NOT NULL DEFAULT 1,
    notify_dhuhr INTEGER NOT NULL DEFAULT 1,
    notify_asr INTEGER NOT NULL DEFAULT 1,
    notify_maghrib INTEGER NOT NULL DEFAULT 1,
    notify_isha INTEGER NOT NULL DEFAULT 1,
    theme_mode TEXT NOT NULL DEFAULT 'dark',
    arabic_font_scale REAL NOT NULL DEFAULT 1.0,
    hijri_offset_days INTEGER NOT NULL DEFAULT 0,
    location_label TEXT,
    iqamath_fajr_minutes INTEGER NOT NULL DEFAULT 20,
    iqamath_dhuhr_minutes INTEGER NOT NULL DEFAULT 15,
    iqamath_asr_minutes INTEGER NOT NULL DEFAULT 15,
    iqamath_maghrib_minutes INTEGER NOT NULL DEFAULT 10,
    iqamath_isha_minutes INTEGER NOT NULL DEFAULT 15,
    silent_fajr INTEGER NOT NULL DEFAULT 0,
    silent_dhuhr INTEGER NOT NULL DEFAULT 0,
    silent_asr INTEGER NOT NULL DEFAULT 0,
    silent_maghrib INTEGER NOT NULL DEFAULT 0,
    silent_isha INTEGER NOT NULL DEFAULT 0,
    silent_extra_minutes INTEGER NOT NULL DEFAULT 5,
    selected_district TEXT,
    language_code TEXT NOT NULL DEFAULT 'en'
  )
  ''',
];
