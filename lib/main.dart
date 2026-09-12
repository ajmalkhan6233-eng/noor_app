// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Entry point. Deliberately thin — all real setup happens in `app.dart`
// and the `core/` services, so this file never needs to grow.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/database/database_helper.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  if (!(prefs.getBool('hasCleanedRestoredPrayerData') ?? false)) {
    final db = await DatabaseHelper.instance.database;
    await db.delete('prayer_completions');
    // Same false-progress problem as prayer_completions (see comment
    // history): an OEM-restored DB would otherwise claim fasting days
    // were observed on an install where the user hasn't fasted at
    // all yet, inflating currentFastingStreak from day one.
    await db.delete('fasting_days');
    await prefs.setBool('hasCleanedRestoredPrayerData', true);
  }
  runApp(const NoorApp());
}
