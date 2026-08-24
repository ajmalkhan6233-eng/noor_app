// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Section 3 of the UI Structure Pass: the Home tab's hero card — a
// Hijri-date pill, an "Assalamu Alaikum" greeting, and today's
// Gregorian date underneath. Location used to have its own pill and
// edit dialog here too; removed — location is only ever changed from
// Settings now, so Home doesn't need to know how to edit it.
//
// Deliberately compact, not the shared AppTypography.heroDisplay size
// (44px, used for the prayer countdown/Zakat total/About app name) —
// a large "Assalamu Alaikum" here was taking up roughly half the
// visible screen on a phone, crowding out the actually time-sensitive
// content (next prayer, streak) below it.

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../l10n/generated/app_localizations.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.hijriOffsetDays});

  final int hijriOffsetDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hijri = HijriDate.fromGregorian(DateTime.now(), offsetDays: hijriOffsetDays);
    final dateSubtitle = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(DateTime.now());

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.assalamuAlaikumGreeting,
                  style: const TextStyle(
                    fontFamily: AppTypography.displayFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(dateSubtitle, style: AppTypography.caption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.brightness_2_outlined, color: AppColors.gold, size: 14),
                const SizedBox(width: 6),
                Text(hijri.formatted, style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
