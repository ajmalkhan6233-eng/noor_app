// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/prayer_times_result.dart';
import 'prayer_time_format.dart';

/// The five daily prayers plus sunrise, in chronological order. The
/// prayer currently in effect carries a thin gold left rule — the
/// only colour accent in an otherwise quiet list.
class PrayerTimesList extends StatefulWidget {
  const PrayerTimesList({super.key, required this.times});

  final PrayerTimesComputed times;

  @override
  State<PrayerTimesList> createState() => _PrayerTimesListState();
}

class _PrayerTimesListState extends State<PrayerTimesList> {
  late final Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String? _currentPrayerName() {
    String? current;
    for (final entry in widget.times.prayerEntries) {
      if (!entry.$2.isAfter(_now)) current = entry.$1;
    }
    return current;
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentPrayerName();
    return Column(
      children: [
        _row('Fajr', widget.times.fajr, current == 'Fajr'),
        _row('Sunrise', widget.times.sunrise, false),
        for (final (name, time) in widget.times.prayerEntries.skip(1))
          _row(name, time, name == current),
      ],
    );
  }

  Widget _row(String name, DateTime time, bool isCurrent) {
    final label = '$name: ${formatClock(time)}${isCurrent ? ', current' : ''}';
    return Semantics(
      label: label,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isCurrent ? AppColors.gold : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(color: AppColors.parchment)),
            Text(formatClock(time), style: AppTypography.time),
          ],
        ),
      ),
    );
  }
}
