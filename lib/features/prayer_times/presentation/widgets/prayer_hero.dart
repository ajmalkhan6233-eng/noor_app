// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The astrolabe ring, the next prayer's name in Cormorant Garamond,
// and its live countdown — one ticking clock driving all three.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/motion/motion.dart';
import '../../data/prayer_times_result.dart';
import 'astrolabe_ring.dart';
import 'prayer_time_format.dart';

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
    final countdown = _formatRemaining(next.$2.difference(_now));
    final label = 'Next prayer: ${next.$1}, in $countdown';

    return Column(
      children: [
        AstrolabeRing(times: widget.times, now: _now),
        const SizedBox(height: 12),
        Semantics(
          liveRegion: true,
          label: label,
          child: Column(
            children: [
              Text(
                next.$1,
                // heroDisplay's shared w300 weight reads as too thin/
                // "weak" for this specific spot — the one thing this
                // whole screen exists to answer at a glance
                // (2026-08-24 live-device review) — bolded locally
                // rather than changing the shared token everywhere
                // else it's used.
                style: AppTypography.heroDisplay.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              // Countdown to the next prayer, with the current clock
              // time right beside it — the whole point of glancing at
              // this screen is usually "how long until I miss it",
              // which needs both numbers side by side, not the clock
              // living somewhere else on the page (2026-08-24
              // live-device review).
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _countdownText(context, countdown),
                  const SizedBox(width: 10),
                  Text('now ${formatClock(_now)}', style: _nowStyle),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Bumped up from the previous unset (body-text-sized) default — the
  // countdown is the number people actually glance at this screen
  // for, and it read too small next to the ring (2026-08-24
  // live-device review: "the countdown, a little bigger").
  static const _countdownStyle = TextStyle(
    color: AppColors.sage,
    fontFeatures: [FontFeature.tabularFigures()],
    letterSpacing: 1,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static const _nowStyle = TextStyle(
    color: AppColors.gold,
    fontSize: 14,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// The seconds digits fade as they change rather than jumping; the
  /// rest of the countdown ("HH:MM:") stays static.
  Widget _countdownText(BuildContext context, String countdown) {
    if (countdown.length < 2) {
      return Text(countdown, style: _countdownStyle);
    }
    final prefix = countdown.substring(0, countdown.length - 2);
    final seconds = countdown.substring(countdown.length - 2);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(prefix, style: _countdownStyle),
        AnimatedSwitcher(
          duration: Motion.effective(context, Motion.short),
          child: Text(
            seconds,
            key: ValueKey(seconds),
            style: _countdownStyle,
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
