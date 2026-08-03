// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/prayer_times_result.dart';
import 'prayer_time_format.dart';

/// The five daily prayers plus sunrise, in chronological order.
class PrayerTimesList extends StatelessWidget {
  const PrayerTimesList({super.key, required this.times});

  final PrayerTimesComputed times;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row('Fajr', times.fajr),
        _row('Sunrise', times.sunrise),
        for (final (name, time) in times.prayerEntries.skip(1))
          _row(name, time),
      ],
    );
  }

  Widget _row(String name, DateTime time) {
    final label = '$name: ${formatClock(time)}';
    return Semantics(
      label: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(color: AppColors.textPrimary)),
            Text(
              formatClock(time),
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
