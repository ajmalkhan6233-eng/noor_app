// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Single source of truth for "what location string should the user
// see right now" — was previously duplicated (LocationPill derived it
// correctly from selectedDistrict/GPS state; HeroCard read a
// different, never-auto-populated field and fell through to a raw
// dialog-title string as if it were a real location name). Both now
// call this.

import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_times/logic/prayer_cubit/prayer_state.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';

/// Precedence: a user-typed custom label (set via the location-name
/// edit dialog) wins if present; otherwise the resolved district
/// name; otherwise a generic "using GPS"/"location set" string once
/// coordinates exist; otherwise `null` (caller decides the empty-
/// state copy — never this function guessing one).
String? resolveLocationLabel(
  SettingsState settingsState,
  PrayerState prayerState,
  AppLocalizations l10n,
) {
  final custom = settingsState.settings.locationLabel;
  if (custom != null && custom.isNotEmpty) return custom;

  final district = settingsState.settings.selectedDistrict;
  if (district != null && district.isNotEmpty) return district;

  if (prayerState.hasCoordinates) {
    return prayerState.usingGps
        ? l10n.locationSetViaGpsLabel
        : l10n.locationSetLabel;
  }

  return null;
}
