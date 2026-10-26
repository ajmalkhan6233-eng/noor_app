// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of prayer_times_list.dart to stay under the 150-line rule.
// The adhan time (and optional iqamath time) on one prayer row. Shrinks
// to fit instead of overflowing at large text sizes.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import 'prayer_time_format.dart';

class PrayerRowTimes extends StatelessWidget {
  const PrayerRowTimes({super.key, required this.time, this.iqamathTime});

  final DateTime time;
  final DateTime? iqamathTime;

  @override
  Widget build(BuildContext context) {
    final iqamath = iqamathTime;
    return Flexible(
      child: ExcludeSemantics(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(formatClock(time), style: AppTypography.time(context.colors.ink)),
              if (iqamath != null) ...[
                const SizedBox(width: 10),
                Text(formatClock(iqamath), style: AppTypography.caption(context.colors.sage)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
