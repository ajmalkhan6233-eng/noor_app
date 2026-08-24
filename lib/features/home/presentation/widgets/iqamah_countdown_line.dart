// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The "smart" iqamah/adhan line requested for Home (2026-08-24
// live-device review): one row, not two separate treatments. The
// astrolabe ring above this (moved here from Prayer Times) already
// shows the next prayer's name and a live countdown to its adhan —
// so this line only renders for the case the ring can't express:
// adhan for the current prayer has already happened today but its
// iqamah (congregation) time hasn't yet. Showing "Adhan in ..." here
// too would just repeat the ring's own countdown in different words,
// which is exactly the duplication this pass is removing (see
// Section B's de-duplicate item) — so this line stays silent
// whenever there's no pending iqamah to report.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../prayer_times/data/iqamath_offsets.dart';
import '../../../prayer_times/data/prayer_times_result.dart';

class IqamahCountdownLine extends StatefulWidget {
  const IqamahCountdownLine({super.key, required this.times, required this.offsets});

  final PrayerTimesComputed times;
  final IqamathOffsetMinutes offsets;

  @override
  State<IqamahCountdownLine> createState() => _IqamahCountdownLineState();
}

class _IqamahCountdownLineState extends State<IqamahCountdownLine> {
  late final Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _now = DateTime.now()));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  (String name, DateTime iqamah)? _pendingIqamah() {
    (String, DateTime)? current;
    for (final entry in widget.times.prayerEntries) {
      if (!entry.$2.isAfter(_now)) current = entry;
    }
    if (current == null) return null;
    final iqamah = current.$2.add(Duration(minutes: widget.offsets.forPrayer(current.$1)));
    if (!iqamah.isAfter(_now)) return null;
    return (current.$1, iqamah);
  }

  String _formatRemaining(Duration remaining) {
    final minutes = remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final pending = _pendingIqamah();
    if (pending == null) return const SizedBox.shrink();
    final countdown = _formatRemaining(pending.$2.difference(_now));
    final label = '${pending.$1} iqamah in $countdown';
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Center(
        child: Semantics(
          liveRegion: true,
          label: label,
          child: ExcludeSemantics(
            child: Text(
              '${pending.$1} iqamah in $countdown',
              style: AppTypography.caption.copyWith(
                color: AppColors.gold,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
