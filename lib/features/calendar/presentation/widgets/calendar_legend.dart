// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class CalendarLegend extends StatelessWidget {
  const CalendarLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _item('Ramadan', tint: true),
          _item('Eid / Ashura', dot: true),
          _item('White Days', ring: true),
          _item('Sri Lanka holiday / Poya', cyanDot: true),
        ],
      ),
    );
  }

  Widget _item(
    String label, {
    bool tint = false,
    bool dot = false,
    bool ring = false,
    bool cyanDot = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: tint
                ? AppColors.gold.withValues(alpha: 0.2)
                : dot
                    ? AppColors.gold
                    : cyanDot
                        ? AppColors.accentSecondary
                        : Colors.transparent,
            border: ring ? Border.all(color: AppColors.gold) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
