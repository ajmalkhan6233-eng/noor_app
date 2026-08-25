// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The astrolabe ring, the next prayer's name in Cormorant Garamond,
// and its live countdown — one ticking clock driving all three.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/prayer_times_result.dart';
import 'astrolabe_ring.dart';
import 'prayer_countdown_row.dart';

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

  (String name, DateTime time) _nextEntry() {
    for (final entry in widget.times.prayerEntries) {
      if (entry.$2.isAfter(_now)) return entry;
    }
    // After Isha, there's no later entry left today — the next Fajr is
    // tomorrow. Only today's computed times are available here, so
    // tomorrow's Fajr is approximated as the same clock time one day
    // later (prayer times shift by at most a couple of minutes
    // day-to-day, close enough for a live countdown). A static
    // "tomorrow" label with no countdown was a real regression here
    // (2026-08-24 live-device review) — the whole point of this ring
    // is a live countdown someone can glance at to see how long is
    // left, and that's exactly the case right after Isha.
    return ('Fajr', widget.times.fajr.add(const Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final next = _nextEntry();
    final remaining = next.$2.difference(_now);
    final label = 'Next prayer: ${next.$1}, in ${_ariaCountdown(remaining)}';

    return Column(
      children: [
        AstrolabeRing(times: widget.times, now: _now),
        const SizedBox(height: 4),
        Semantics(
          liveRegion: true,
          label: label,
          child: PrayerCountdownRow(
            prayerName: next.$1,
            remaining: remaining,
            now: _now,
          ),
        ),
      ],
    );
  }

  String _ariaCountdown(Duration remaining) {
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
