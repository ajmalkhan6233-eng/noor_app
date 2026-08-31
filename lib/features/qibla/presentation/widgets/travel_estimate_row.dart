// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of qibla_route_card.dart to stay under the 150-line-per-
// file rule — the three flying/camel/foot stat columns beneath the
// route line.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/travel_estimate.dart';
import 'travel_mode_icons.dart';

class TravelEstimateRow extends StatelessWidget {
  const TravelEstimateRow({super.key, required this.distanceKm});

  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final flyingHours = TravelEstimate.flyingHours(distanceKm).round();
    final camelDays = TravelEstimate.camelDays(distanceKm).round();
    final footMonths = TravelEstimate.footMonths(distanceKm).round();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 11),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.ink.withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          _column(colors, FlyingIconPainter(colors.sage), l10n.qiblaHoursAbbrev(flyingHours), l10n.qiblaFlyingLabel),
          _divider(colors),
          _column(colors, CamelIconPainter(colors.sage), l10n.qiblaDaysAbbrev(camelDays), l10n.qiblaCamelLabel),
          _divider(colors),
          _column(colors, WalkingIconPainter(colors.sage), l10n.qiblaMonthsAbbrev(footMonths), l10n.qiblaFootLabel),
        ],
      ),
    );
  }

  Widget _divider(AppColorTokens colors) => Container(width: 1, height: 30, color: colors.ink.withValues(alpha: 0.1));

  Widget _column(AppColorTokens colors, CustomPainter icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          CustomPaint(size: const Size(16, 16), painter: icon),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: colors.ink, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 1),
          Text(label.toUpperCase(), style: AppTypography.caption(colors.sage).copyWith(fontSize: 8, letterSpacing: 0.6)),
        ],
      ),
    );
  }
}
