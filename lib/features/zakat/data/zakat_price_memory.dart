// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Remembers the last-entered gold/silver price per gram, locally only
// — everything else on this screen (grams held, cash, liabilities)
// genuinely changes every visit, but the market price is the one
// field someone re-types identically every time (2026-08-25 audit:
// "Zakat calculator asks for gold/silver prices every time"). Plain
// SharedPreferences rather than the encrypted settings DB — this is a
// non-sensitive convenience value, not worth a schema migration for.

import 'package:shared_preferences/shared_preferences.dart';

class ZakatPriceMemory {
  static const _goldKey = 'zakat_last_gold_price_per_gram';
  static const _silverKey = 'zakat_last_silver_price_per_gram';

  Future<double?> loadGoldPrice() => _load(_goldKey);
  Future<double?> loadSilverPrice() => _load(_silverKey);

  Future<void> saveGoldPrice(double value) => _save(_goldKey, value);
  Future<void> saveSilverPrice(double value) => _save(_silverKey, value);

  Future<double?> _load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  Future<void> _save(String key, double value) async {
    if (value <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }
}
