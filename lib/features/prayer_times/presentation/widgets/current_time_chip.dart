// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'prayer_time_format.dart';
import '../../../../core/constants/app_color_tokens.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/corner_radius.dart';
import 'prayer_countdown_row.dart';

/// A separated pill for the current clock time — deliberately distinct
/// in shape, size, and position from the countdown above it, so it
/// can't be mistaken for a second countdown number.
class CurrentTimeChip extends StatelessWidget {
  const CurrentTimeChip({super.key, required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context)!.currentTimeSemantics(formatClock(now)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(context.radiusFor(20)),
          border: Border.all(color: context.colors.hairline),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
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
      ),
    );
  }
}
