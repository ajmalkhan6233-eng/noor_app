// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';

/// Numeric qibla bearing and distance — always shown, independent of
/// whether a compass is available or trustworthy. Kept small and off
/// to the side (a corner badge, not a headline) so the compass itself
/// stays the visual focus of the screen.
class QiblaInfoPanel extends StatelessWidget {
  const QiblaInfoPanel({
    super.key,
    required this.bearingDegrees,
    required this.distanceKm,
  });

  final double bearingDegrees;
  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    final bearingText = '${bearingDegrees.round()}°';
    final distanceText = '${distanceKm.round()} km';

    return Semantics(
      label:
          'Qibla bearing $bearingText true, '
          'distance to the Kaaba $distanceText',
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              bearingText,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              distanceText,
              style: const TextStyle(color: AppColors.sage, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
