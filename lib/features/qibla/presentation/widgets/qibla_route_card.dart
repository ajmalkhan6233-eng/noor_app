// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The route/distance card at the top of the new Qibla screen (rebuilt
// 2026-08-30 per the approved mockup) — replaces the old
// QiblaInfoPanel corner badge with a glass card: a curved route line
// from the user's location to Makkah with a plane silhouette
// travelling along it (route_line_with_plane.dart), the live
// great-circle distance, and three rough travel-time estimates
// computed from that same distance (travel_estimate_row.dart).

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/travel_estimate.dart';
import 'route_line_with_plane.dart';
import 'travel_estimate_row.dart';

class QiblaRouteCard extends StatelessWidget {
  const QiblaRouteCard({super.key, required this.distanceKm, this.originLabel});

  final double distanceKm;
  final String? originLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final origin = originLabel ?? l10n.qiblaYourLocationLabel;
    final flyingHours = TravelEstimate.flyingHours(distanceKm).round();
    final camelDays = TravelEstimate.camelDays(distanceKm).round();
    final footMonths = TravelEstimate.footMonths(distanceKm).round();

    return Semantics(
      label:
          '${distanceKm.round()} km, $origin to the Kaaba. '
          '${l10n.qiblaTravelEstimateSemanticLabel(flyingHours, camelDays, footMonths)}',
      child: ExcludeSemantics(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
              decoration: BoxDecoration(
                color: colors.ink.withValues(alpha: 0.045),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.gold.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  RouteLineWithPlane(originLabel: origin),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${_formatKm(distanceKm)} km',
                            style: TextStyle(color: colors.gold, fontSize: 23, fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: '   ·   ${l10n.qiblaRouteCaption(origin)}',
                            style: TextStyle(color: colors.sage, fontSize: 11.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TravelEstimateRow(distanceKm: distanceKm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatKm(double km) {
    final rounded = km.round();
    final str = rounded.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
