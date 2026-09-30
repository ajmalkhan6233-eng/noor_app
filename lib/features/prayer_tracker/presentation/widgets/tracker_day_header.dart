// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';

/// Section title plus the previous/next-day chevrons (48dp targets).
class TrackerDayHeader extends StatelessWidget {
  const TrackerDayHeader({
    super.key,
    required this.title,
    required this.isToday,
    required this.cubit,
  });

  final String title;
  final bool isToday;
  final PrayerTrackerCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(child: SectionHeader(title)),
        SemanticButton(
          label: l10n.trackerPreviousDay,
          onTap: cubit.goToPreviousDay,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Icon(Icons.chevron_left, color: context.colors.gold, size: 20),
          ),
        ),
        SemanticButton(
          label: l10n.trackerNextDay,
          onTap: cubit.goToNextDay,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Icon(
              Icons.chevron_right,
              color: isToday ? context.colors.hairline : context.colors.gold,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
