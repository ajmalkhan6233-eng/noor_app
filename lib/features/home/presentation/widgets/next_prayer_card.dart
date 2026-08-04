// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The dashboard's hero card: next prayer's name in Cormorant, its
// clock time, and a circular countdown ring (built-in
// CircularProgressIndicator, filling in emerald as the interval since
// the previous prayer elapses).

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../prayer_times/data/prayer_times_result.dart';
import '../../../prayer_times/presentation/widgets/prayer_time_format.dart';

class NextPrayerCard extends StatefulWidget {
  const NextPrayerCard({super.key, required this.times});

  final PrayerTimesComputed times;

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> {
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

  (String name, DateTime time) _previousEntry(String? nextName) {
    final entries = widget.times.prayerEntries;
    final index = entries.indexWhere((e) => e.$1 == nextName);
    if (index <= 0) return entries.last;
    return entries[index - 1];
  }

  @override
  Widget build(BuildContext context) {
    final next = _nextEntry();
    final heroName = next?.$1 ?? 'Fajr';
    final heroTime = next?.$2;
    final label = next == null
        ? 'Isha has passed; next prayer is tomorrow\'s Fajr'
        : 'Next prayer: ${next.$1} at ${formatClock(next.$2)}';

    double progress = 0;
    if (next != null) {
      final previous = _previousEntry(next.$1);
      final total = next.$2.difference(previous.$2).inSeconds;
      final elapsed = _now.difference(previous.$2).inSeconds;
      progress = total <= 0 ? 0 : (elapsed / total).clamp(0.0, 1.0);
    }

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Semantics(
        liveRegion: true,
        label: label,
        child: Row(
          children: [
            SizedBox(
              width: 84,
              height: 84,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 84,
                    height: 84,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: AppColors.hairline,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.emerald,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.access_time_filled,
                    color: AppColors.emerald,
                    size: 22,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Next prayer', style: AppTypography.caption),
                  Text(
                    heroName,
                    style: AppTypography.heroDisplay.copyWith(fontSize: 32),
                  ),
                  if (heroTime != null)
                    Text(
                      formatClock(heroTime),
                      style: const TextStyle(
                        color: AppColors.emerald,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
