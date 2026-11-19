// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Entry point. Deliberately thin — all real setup happens in `app.dart`
// and the `core/` services, so this file never needs to grow.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/database/database_helper.dart';
import 'core/database/restored_data_guard.dart';
import 'core/visual_style_controller.dart';
import 'features/prayer_times/data/background_adhan_task.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // sqflite_sqlcipher has no web implementation (see
  // settings_repository.dart's own kIsWeb gate) — this app doesn't
  // target web, this guard exists solely so a local web-preview
  // session doesn't hang on startup before ever reaching runApp.
  if (!kIsWeb) {
    // Clears OEM-restored tracker data on a fresh install only; an app
    // update never deletes anything (see restored_data_guard.dart).
    await runRestoredDataGuard(prefs, wipe: () async {
      final db = await DatabaseHelper.instance.database;
      await db.delete('prayer_completions');
      // Same false-progress problem: restored fasting days.
      await db.delete('fasting_days');
    });
  }
  // One fast prefs read so the first frame is already in the right look.
  await VisualStyleController.instance.load();
  runApp(const NoorApp());
  // Keeps the adhan coming even if the app isn't opened for days.
  if (!kIsWeb) unawaited(registerDailyAdhanRefresh());
}
