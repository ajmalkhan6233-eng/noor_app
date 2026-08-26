// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Home countdown's third state (2026-08-26): active only between
// a prayer's adhan and its iqamah. Mirrors PrayerCountdownRow's
// digit-fade countdown treatment (noor-kinetic-typography) so the
// number still feels alive, but swaps the copy for an encouraging
// "head to the masjid" message instead of "approaching" — this state
// means the opposite: the prayer already started, iqamah is next.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/motion/motion.dart';

class IqamaGapRow extends StatelessWidget {
  const IqamaGapRow({
    super.key,
    required this.prayerName,
    required this.remaining,
  });

  final String prayerName;
  final Duration remaining;

  static const _countdownStyle = TextStyle(
    color: AppColors.accentSecondary,
    fontFeatures: [FontFeature.tabularFigures()],
    letterSpacing: 1,
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    final countdown = _formatRemaining(remaining);
    return Column(
      children: [
        Text(
          'Head to the masjid',
          style: AppTypography.heroDisplay.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$prayerName iqamah is next',
          style: const TextStyle(color: AppColors.sage, fontSize: 13),
        ),
        const SizedBox(height: 6),
        _countdownText(context, countdown),
      ],
    );
  }

  /// The seconds digits fade as they change rather than jumping — same
  /// treatment as PrayerCountdownRow's own countdown.
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
    final minutes = remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
