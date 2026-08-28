// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of prayer_hero.dart (2026-08-25 live-device review: the
// hero read as mostly empty space above a small countdown, and the
// countdown/now numerals were sized too small for the one thing this
// screen exists to answer at a glance) — the prayer name, a plain
// "approaching" line under it, and the countdown+now row, sized up.
//
// Relabeled (2026-08-26, direct request: "unclear whether the big
// number is a countdown or the current time") — the countdown and the
// current clock used to sit inline on one row with only 10px between
// them, both in similarly-weighted numerals, so a glance couldn't
// tell which was which. Now the countdown is explicitly captioned
// "Next prayer in", and the current time is pulled into its own
// separated chip with a clock icon and "Current time" label — visually
// a distinct element, not a second half of the same row.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/motion/motion.dart';
import 'prayer_time_format.dart';
import '../../../../core/constants/app_color_tokens.dart';

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

  // Bumped again (2026-08-25: "the countdown a little more big, and
  // the time also a little more big") — this is the one number the
  // whole Home screen exists to answer at a glance.
  static TextStyle _countdownStyle(Color color) => TextStyle(
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
        letterSpacing: 1,
        fontSize: 40,
        fontWeight: FontWeight.w700,
      );

  static TextStyle _labelStyle(Color color) => TextStyle(
        color: color,
        fontSize: 13,
        letterSpacing: 0.5,
      );

  static TextStyle clockChipLabelStyle(Color color) => TextStyle(
        color: color,
        fontSize: 11,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w600,
      );

  static TextStyle clockChipTimeStyle(Color color) => TextStyle(
        color: color,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  @override
  Widget build(BuildContext context) {
    final countdown = _formatRemaining(remaining);
    return Column(
      children: [
        Text(
          prayerName,
          style: AppTypography.heroDisplay(context.colors.ink).copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text('Next prayer in', style: _labelStyle(context.colors.sage)),
        const SizedBox(height: 6),
        _countdownText(context, countdown),
        const SizedBox(height: 18),
        _CurrentTimeChip(now: now),
      ],
    );
  }

  /// The seconds digits fade as they change rather than jumping; the
  /// rest of the countdown ("HH:MM:") stays static.
  Widget _countdownText(BuildContext context, String countdown) {
    final style = _countdownStyle(context.colors.sage);
    if (countdown.length < 2) {
      return Text(countdown, style: style);
    }
    final prefix = countdown.substring(0, countdown.length - 2);
    final seconds = countdown.substring(countdown.length - 2);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(prefix, style: style),
        AnimatedSwitcher(
          duration: Motion.effective(context, Motion.short),
          child: Text(
            seconds,
            key: ValueKey(seconds),
            style: style,
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

/// A separated pill for the current clock time — deliberately distinct
/// in shape, size, and position from the countdown above it, so it
/// can't be mistaken for a second countdown number.
class _CurrentTimeChip extends StatelessWidget {
  const _CurrentTimeChip({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Current time ${formatClock(now)}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.colors.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.schedule, size: 13, color: context.colors.sage),
            const SizedBox(width: 6),
            Text(
              'CURRENT TIME',
              style: PrayerCountdownRow.clockChipLabelStyle(context.colors.sage),
            ),
            const SizedBox(width: 8),
            Text(
              formatClock(now),
              style: PrayerCountdownRow.clockChipTimeStyle(context.colors.gold),
            ),
          ],
        ),
      ),
    );
  }
}
