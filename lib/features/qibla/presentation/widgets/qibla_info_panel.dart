// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Numeric qibla bearing and distance — always shown, independent of
/// whether a compass is available or trustworthy.
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
      child: Column(
        children: [
          Text(
            bearingText,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$distanceText to the Kaaba',
            style: const TextStyle(color: AppColors.sage),
          ),
        ],
      ),
    );
  }
}
