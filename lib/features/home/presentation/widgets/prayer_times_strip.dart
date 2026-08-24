// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Horizontal prayer-times strip for Home — all 5 daily prayers with
// times, sitting below PrayerHero's countdown ring. The upcoming
// prayer gets the gold border + cyan glow treatment, mirroring how
// prayer_times_list.dart marks the current prayer on the Prayer Times
// tab (there: a thin coloured rule) but recoloured to the locked
// gold/cyan palette instead of a flat emerald rule.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../prayer_times/data/prayer_times_result.dart';
import '../../../prayer_times/presentation/widgets/prayer_time_format.dart';

class PrayerTimesStrip extends StatefulWidget {
  const PrayerTimesStrip({super.key, required this.times});

  final PrayerTimesComputed times;

  @override
  State<PrayerTimesStrip> createState() => _PrayerTimesStripState();
}

class _PrayerTimesStripState extends State<PrayerTimesStrip> {
  late final Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => setState(() => _now = DateTime.now()));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String? _upcomingName() {
    for (final entry in widget.times.prayerEntries) {
      if (entry.$2.isAfter(_now)) return entry.$1;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _upcomingName();
    return SizedBox(
      height: 86,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final (name, time) in widget.times.prayerEntries)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _chip(name, time, name == upcoming),
            ),
        ],
      ),
    );
  }

  Widget _chip(String name, DateTime time, bool upcoming) {
    final label = '$name: ${formatClock(time)}${upcoming ? ', next prayer' : ''}';
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderColor: upcoming ? AppColors.gold : null,
          glowColor: upcoming ? AppColors.accentSecondary : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: upcoming ? AppColors.gold : AppColors.sage,
                  fontSize: 12,
                  fontWeight: upcoming ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              Text(formatClock(time), style: AppTypography.time),
            ],
          ),
        ),
      ),
    );
  }
}
