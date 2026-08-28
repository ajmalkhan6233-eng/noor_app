// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_color_tokens.dart';

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
          _item(context, 'Ramadan', tint: true),
          _item(context, 'Eid / Ashura', dot: true),
          _item(context, 'White Days', ring: true),
          _item(context, 'Sri Lanka holiday / Poya', cyanDot: true),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
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
                ? context.colors.gold.withValues(alpha: 0.2)
                : dot
                    ? context.colors.gold
                    : cyanDot
                        ? context.colors.accentSecondary
                        : Colors.transparent,
            border: ring ? Border.all(color: context.colors.gold) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTypography.caption(context.colors.sage)),
      ],
    );
  }
}
