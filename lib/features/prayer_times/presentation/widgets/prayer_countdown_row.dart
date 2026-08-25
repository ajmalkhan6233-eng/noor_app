// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of prayer_hero.dart (2026-08-25 live-device review: the
// hero read as mostly empty space above a small countdown, and the
// countdown/now numerals were sized too small for the one thing this
// screen exists to answer at a glance) — the prayer name, a plain
// "approaching" line under it, and the countdown+now row, sized up.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/motion/motion.dart';
import 'prayer_time_format.dart';

class PrayerCountdownRow extends StatelessWidget {
  const PrayerCountdownRow({
    super.key,
    required this.prayerName,
    required this.remaining,
    required this.now,
  });

  final String prayerName;
  final Duration remaining;
  final DateTime now;

  static const _countdownStyle = TextStyle(
    color: AppColors.sage,
    fontFeatures: [FontFeature.tabularFigures()],
    letterSpacing: 1,
    fontSize: 34,
    fontWeight: FontWeight.w700,
  );

  static const _nowStyle = TextStyle(
    color: AppColors.gold,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  @override
  Widget build(BuildContext context) {
    final countdown = _formatRemaining(remaining);
    return Column(
      children: [
        Text(
          prayerName,
          style: AppTypography.heroDisplay.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          '$prayerName is approaching',
          style: const TextStyle(color: AppColors.sage, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _countdownText(context, countdown),
            const SizedBox(width: 10),
            Text('now ${formatClock(now)}', style: _nowStyle),
          ],
        ),
      ],
    );
  }

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
