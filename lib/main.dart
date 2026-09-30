// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Entry point. Deliberately thin — all real setup happens in `app.dart`
// and the `core/` services, so this file never needs to grow.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/database/database_helper.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // sqflite_sqlcipher has no web implementation (see
  // settings_repository.dart's own kIsWeb gate) — this app doesn't
  // target web, this guard exists solely so a local web-preview
  // session doesn't hang on startup before ever reaching runApp.
  if (!kIsWeb && !(prefs.getBool('hasCleanedRestoredPrayerData') ?? false)) {
    // A failure here must never keep the app from starting: the cleanup
    // simply retries on the next launch.
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('prayer_completions');
      // Same false-progress problem as prayer_completions: an
      // OEM-restored DB would otherwise claim fasting days were observed
      // on an install where the user hasn't fasted at all yet.
      await db.delete('fasting_days');
      await prefs.setBool('hasCleanedRestoredPrayerData', true);
    } catch (_) {}
  }
  runApp(const NoorApp());
}
