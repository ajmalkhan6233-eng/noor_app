// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/corner_radius.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Week / Month toggle.
class ProgressRangeSwitch extends StatelessWidget {
  const ProgressRangeSwitch({
    super.key,
    required this.showMonth,
    required this.onWeek,
    required this.onMonth,
  });

  final bool showMonth;
  final VoidCallback onWeek;
  final VoidCallback onMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(child: _segment(context, l10n.progressWeek, !showMonth, onWeek)),
        const SizedBox(width: 8),
        Expanded(child: _segment(context, l10n.progressMonth, showMonth, onMonth)),
      ],
    );
  }

  Widget _segment(BuildContext context, String label, bool selected, VoidCallback onTap) {
    final colors = context.colors;
    return SemanticButton(
      label: label,
      checked: selected,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(context.radiusFor(10)),
          border: Border.all(color: selected ? colors.gold : colors.hairline),
        ),
        child: Text(
          label,
          style: AppTypography.body(selected ? colors.paper : colors.ink).copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
