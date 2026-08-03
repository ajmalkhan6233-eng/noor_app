// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/prayer_times_result.dart';

/// Live "next prayer in HH:MM:SS" countdown, ticking every second.
class NextPrayerCountdown extends StatefulWidget {
  const NextPrayerCountdown({super.key, required this.times});

  final PrayerTimesComputed times;

  @override
  State<NextPrayerCountdown> createState() => _NextPrayerCountdownState();
}

class _NextPrayerCountdownState extends State<NextPrayerCountdown> {
  late Timer _timer;
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
    final label = next == null
        ? 'Isha has passed — next prayer is tomorrow\'s Fajr'
        : 'Next: ${next.$1} in ${_formatRemaining(next.$2.difference(_now))}';

    return Semantics(
      liveRegion: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.milestone,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _formatRemaining(Duration remaining) {
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
