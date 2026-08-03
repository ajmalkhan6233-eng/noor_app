// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The astrolabe ring, the next prayer's name in Cormorant Garamond,
// and its live countdown — one ticking clock driving all three.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/prayer_times_result.dart';
import 'astrolabe_ring.dart';

class PrayerHero extends StatefulWidget {
  const PrayerHero({super.key, required this.times});

  final PrayerTimesComputed times;

  @override
  State<PrayerHero> createState() => _PrayerHeroState();
}

class _PrayerHeroState extends State<PrayerHero> {
  late final Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  (String name, DateTime time)? _nextEntry() {
    for (final entry in widget.times.prayerEntries) {
      if (entry.$2.isAfter(_now)) return entry;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final next = _nextEntry();
    final heroName = next?.$1 ?? 'Fajr';
    final countdown = next == null
        ? 'tomorrow'
        : _formatRemaining(next.$2.difference(_now));
    final label = next == null
        ? 'Isha has passed; next prayer is tomorrow\'s Fajr'
        : 'Next prayer: ${next.$1}, in $countdown';

    return Column(
      children: [
        AstrolabeRing(times: widget.times, now: _now),
        const SizedBox(height: 12),
        Semantics(
          liveRegion: true,
          label: label,
          child: Column(
            children: [
              Text(heroName, style: AppTypography.heroDisplay),
              const SizedBox(height: 4),
              Text(
                countdown,
                style: const TextStyle(
                  color: AppColors.sage,
                  fontFeatures: [FontFeature.tabularFigures()],
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatRemaining(Duration remaining) {
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
