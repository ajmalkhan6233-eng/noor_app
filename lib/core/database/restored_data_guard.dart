// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Some phone makers (e.g. MIUI) restore the old encrypted database on a
// reinstall even though allowBackup is false, which shows prayers as
// ticked on a brand-new install. The guard clears that stale tracker
// data, but ONLY on a fresh install. An app UPDATE keeps the user's
// SharedPreferences, so non-empty prefs mean real, legitimate data:
// never delete it.

import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences flag: the guard has already run on this install.
const String restoredDataGuardKey = 'hasCleanedRestoredPrayerData';

/// True when this launch looks like a fresh install: the guard has not
/// run and no preference has ever been saved. Pure, so it is easy to test.
bool looksLikeFreshInstall({
  required bool guardAlreadyRan,
  required Set<String> preferenceKeys,
}) =>
    !guardAlreadyRan && preferenceKeys.isEmpty;

/// Runs once per install. [wipe] clears the tracker tables; it is called
/// only for a fresh install. A failure never blocks app start: the guard
/// simply retries on the next launch.
Future<void> runRestoredDataGuard(
  SharedPreferences prefs, {
  required Future<void> Function() wipe,
}) async {
  final alreadyRan = prefs.getBool(restoredDataGuardKey) ?? false;
  if (alreadyRan) return;
  final fresh = looksLikeFreshInstall(
    guardAlreadyRan: alreadyRan,
    preferenceKeys: prefs.getKeys(),
  );
  try {
    if (fresh) await wipe();
    await prefs.setBool(restoredDataGuardKey, true);
  } catch (_) {}
}
