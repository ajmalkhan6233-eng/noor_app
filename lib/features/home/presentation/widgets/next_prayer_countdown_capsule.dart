// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Section 3's next-prayer countdown capsule: clock icon, prayer name
// + Adhan time, and a large monospace live countdown — cyan border
// per the locked palette's "cyan used sparingly, specific spots only"
// rule. Countdown logic mirrors prayer_times/presentation/widgets/
// prayer_hero.dart's ticking pattern.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_times/data/prayer_times_result.dart';
import '../../../prayer_times/presentation/widgets/prayer_time_format.dart';

class NextPrayerCountdownCapsule extends StatefulWidget {
  const NextPrayerCountdownCapsule({super.key, required this.times});

  final PrayerTimesComputed times;

  @override
  State<NextPrayerCountdownCapsule> createState() => _NextPrayerCountdownCapsuleState();
}

class _NextPrayerCountdownCapsuleState extends State<NextPrayerCountdownCapsule> {
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

  (String name, DateTime time)? _nextEntry() {
    for (final entry in widget.times.prayerEntries) {
      if (entry.$2.isAfter(_now)) return entry;
    }
    return null;
  }

  String _formatRemaining(Duration remaining) {
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final next = _nextEntry() ?? ('Fajr', widget.times.fajr);
    final countdown = _nextEntry() == null
        ? '00:00:00'
        : _formatRemaining(next.$2.difference(_now));

    return AppCard(
      padding: const EdgeInsets.all(16),
      borderColor: AppColors.accentSecondary,
      glowColor: AppColors.accentSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_filled, color: AppColors.accentSecondary, size: 18),
              const SizedBox(width: 8),
              Text(l10n.nextPrayerLabel, style: AppTypography.caption),
              const Spacer(),
              Text(next.$1, style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
              const SizedBox(width: 6),
              Text(formatClock(next.$2), style: AppTypography.caption),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Semantics(
              liveRegion: true,
              label: '${l10n.nextPrayerLabel}: ${next.$1}, $countdown',
              child: Text(
                countdown,
                style: const TextStyle(
                  fontFeatures: [FontFeature.tabularFigures()],
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.accentSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
