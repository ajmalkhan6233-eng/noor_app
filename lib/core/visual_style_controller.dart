// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One switch for every rich visual (2026-11-19): OFF (default) = the
// plain Simple look, no animations, no particle background. ON = the
// Cosmic/Dawn/Mushaf/Emerald themes with all their motion. Stored in
// SharedPreferences so it needs no database migration.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisualStyleController {
  VisualStyleController._();

  static final VisualStyleController instance = VisualStyleController._();

  static const String prefsKey = 'rich_visuals';

  /// false = Simple (default), true = Rich visuals.
  final ValueNotifier<bool> rich = ValueNotifier<bool>(false);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    rich.value = prefs.getBool(prefsKey) ?? false;
  }

  Future<void> setRich(bool value) async {
    rich.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefsKey, value);
  }
}
