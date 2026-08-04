// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Location name (tap to set — never geocoded, always user-entered)
// left, the Hijri date beneath it, and the embossed Allah calligraphy
// centred independently of the left column's width.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/allah_calligraphy.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../core/utils/semantics_helpers.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.locationLabel,
    required this.hijriOffsetDays,
    required this.onEditLocation,
  });

  final String? locationLabel;
  final int hijriOffsetDays;
  final VoidCallback onEditLocation;

  @override
  Widget build(BuildContext context) {
    final hijri = HijriDate.fromGregorian(
      DateTime.now(),
      offsetDays: hijriOffsetDays,
    );
    return SizedBox(
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SemanticButton(
              label: locationLabel == null
                  ? 'Set your location name'
                  : 'Location: $locationLabel',
              hint: 'Double tap to edit',
              onTap: onEditLocation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    locationLabel ?? 'Set location',
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(hijri.formatted, style: AppTypography.caption),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: AllahCalligraphy(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
