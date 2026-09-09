import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';

class AppColors {
  static const Color spaceDark = Color(0xFF0B0E14);
  static const Color cardBg = Color(0xFF161B22);
  static const Color noorGold = Color(0xFFFFD700);
  static const Color fajrAmber = Color(0xFFFFB300);
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color checkGreen = Color(0xFF00E676);
}

class PrayerEngine {
  // Default Sri Lanka Coordinates (Colombo baseline)
  static PrayerTimes getTimes() {
    final coordinates = Coordinates(6.9271, 79.8612);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    return PrayerTimes(coordinates, DateComponents.from(DateTime.now()), params);
  }

  static String getNextPrayerName(PrayerTimes times) {
    switch (times.nextPrayer()) {
      case Prayer.fajr: return "Fajr";
      case Prayer.sunrise: return "Sunrise";
      case Prayer.dhuhr: return "Dhuhr";
      case Prayer.asr: return "Asr";
      case Prayer.maghrib: return "Maghrib";
      case Prayer.isha: return "Isha";
      default: return "Fajr";
    }
  }
}