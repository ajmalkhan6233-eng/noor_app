// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Home's top card: a compact "confirm today's date" card — the Gregorian
// date and the Hijri date pill, with a small engraved "Allah" watermark
// in the corner. The Bismillah / Assalamu Alaikum greeting that used to
// animate here now plays only in the launch splash (2026-09-28, direct
// request — it was duplicating the splash sequence).

import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/allah_calligraphy.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../core/constants/app_color_tokens.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.hijriOffsetDays});

  final int hijriOffsetDays;

  @override
  Widget build(BuildContext context) {
    final hijri = HijriDate.fromGregorian(DateTime.now(), offsetDays: hijriOffsetDays);
    final dateSubtitle = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(DateTime.now());

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Quiet corner watermark, never overlapping the date text.
          const Positioned(
            top: 0,
            right: 0,
            child: Opacity(opacity: 0.55, child: AllahCalligraphy(fontSize: 26)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Stacked, not side-by-side, so neither date ever
                // truncates the other (2026-08-25 live-device review).
                Text(dateSubtitle, style: AppTypography.caption(context.colors.sage)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.paper,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.colors.hairline),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.brightness_2_outlined, color: context.colors.gold, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        hijri.formatted,
                        style: AppTypography.caption(context.colors.sage).copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
