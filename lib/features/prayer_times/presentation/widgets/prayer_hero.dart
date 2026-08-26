// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The astrolabe ring, the next prayer's name in Cormorant Garamond,
// and its live countdown — one ticking clock driving all three.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/effects/particle_burst.dart';
import '../../data/iqamath_offsets.dart';
import '../../data/prayer_times_result.dart';
import '../../logic/prayer_countdown_phase.dart';
import 'astrolabe_ring.dart';
import 'iqama_gap_row.dart';
import 'prayer_countdown_row.dart';

class PrayerHero extends StatefulWidget {
  const PrayerHero({super.key, required this.times, required this.offsets});

  final PrayerTimesComputed times;
  final IqamathOffsetMinutes offsets;

  @override
  State<PrayerHero> createState() => _PrayerHeroState();
}

class _PrayerHeroState extends State<PrayerHero> {
  late final Timer _timer;
  DateTime _now = DateTime.now();
  bool _wasInIqamaGap = false;

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

  @override
  Widget build(BuildContext context) {
    final phase = computePrayerCountdownPhase(
      times: widget.times,
      offsets: widget.offsets,
      now: _now,
    );

    final inIqamaGap = phase is IqamaGapPhase;
    if (inIqamaGap && !_wasInIqamaGap) {
      // One-time "ignition" moment right as the gap opens — per
      // noor-kinetic-typography, a particle burst belongs on a
      // meaningful state change like this, not on every tick.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ParticleBurst.play(context, intensity: 0.5);
      });
    }
    _wasInIqamaGap = inIqamaGap;

    final label = switch (phase) {
      NextPrayerPhase(:final prayerName, :final remaining) =>
        'Next prayer: $prayerName, in ${_ariaCountdown(remaining)}',
      IqamaGapPhase(:final prayerName, :final remaining) =>
        '$prayerName iqamah in ${_ariaCountdown(remaining)}',
    };

    return Column(
      children: [
        AstrolabeRing(times: widget.times, now: _now),
        const SizedBox(height: 4),
        Semantics(
          liveRegion: true,
          label: label,
          child: switch (phase) {
            NextPrayerPhase(:final prayerName, :final remaining) =>
              PrayerCountdownRow(
                prayerName: prayerName,
                remaining: remaining,
                now: _now,
              ),
            IqamaGapPhase(:final prayerName, :final remaining) =>
              IqamaGapRow(prayerName: prayerName, remaining: remaining),
          },
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
