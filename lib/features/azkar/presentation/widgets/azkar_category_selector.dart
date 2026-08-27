// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A vertical list of category rows — icon, label, chevron — each
// opening its own AzkarCategoryScreen. Replaced the horizontal chip
// selector + single flat list (2026-08-24 live-device review:
// "categorized, not one flat list", matching the reference app's
// grouped-row pattern for its Daily/Azkar sections).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../data/azkar_category.dart';
import '../../logic/azkar_cubit/azkar_cubit.dart';
import '../azkar_category_screen.dart';

extension _AzkarCategoryIcon on AzkarCategory {
  IconData get icon {
    switch (this) {
      case AzkarCategory.morning:
        return Icons.wb_sunny_outlined;
      case AzkarCategory.evening:
        return Icons.nights_stay_outlined;
      case AzkarCategory.afterPrayer:
        return Icons.self_improvement_outlined;
      case AzkarCategory.sleep:
        return Icons.bedtime_outlined;
      case AzkarCategory.travel:
        return Icons.flight_outlined;
      case AzkarCategory.childProtection:
        return Icons.child_care_outlined;
      case AzkarCategory.illness:
        return Icons.healing_outlined;
      case AzkarCategory.distress:
        return Icons.spa_outlined;
      case AzkarCategory.debt:
        return Icons.account_balance_wallet_outlined;
      case AzkarCategory.visitingGrave:
        return Icons.park_outlined;
      case AzkarCategory.visitingSick:
        return Icons.volunteer_activism_outlined;
    }
  }
}

class AzkarCategorySelector extends StatelessWidget {
  const AzkarCategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Scrollable, not a plain Column: 11 categories (grew from fewer
    // when "Visiting the Sick" split out of "illness") no longer fit
    // every device's available height under the Expanded above it —
    // confirmed live as a ~48px bottom RenderFlex overflow.
    return AppCard(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final category in AzkarCategory.values) ...[
              _row(context, category),
              if (category != AzkarCategory.values.last)
                const Divider(color: AppColors.hairline, height: 1),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, AzkarCategory category) {
    return SemanticButton(
      label: '${category.label} azkar',
      hint: 'Double tap to open',
      onTap: () {
        final cubit = context.read<AzkarCubit>();
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: AzkarCategoryScreen(category: category),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(category.icon, color: AppColors.gold, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(category.label, style: const TextStyle(color: AppColors.ink)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.sage, size: 20),
          ],
        ),
      ),
    );
  }
}
