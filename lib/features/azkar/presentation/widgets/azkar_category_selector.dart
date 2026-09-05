// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A vertical list of category rows — icon, label, chevron — each
// opening its own AzkarCategoryScreen. Replaced the horizontal chip
// selector + single flat list (2026-08-24 live-device review:
// "categorized, not one flat list", matching the reference app's
// grouped-row pattern for its Daily/Azkar sections).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../data/azkar_category.dart';
import '../../logic/azkar_cubit/azkar_cubit.dart';
import '../azkar_category_screen.dart';
import '../../../../core/constants/app_color_tokens.dart';
import 'azkar_category_icon_painters_a.dart';
import 'azkar_category_icon_painters_b.dart';
import 'azkar_category_icon_painters_c.dart';
import 'azkar_category_icon_painters_d.dart';
import 'azkar_category_icon_painters_e.dart';

extension _AzkarCategoryIcon on AzkarCategory {
  CustomPainter painter(Color color) {
    return switch (this) {
      AzkarCategory.morning => AzkarMorningIconPainter(color),
      AzkarCategory.evening => AzkarEveningIconPainter(color),
      AzkarCategory.afterPrayer => AzkarAfterPrayerIconPainter(color),
      AzkarCategory.sleep => AzkarSleepIconPainter(color),
      AzkarCategory.travel => AzkarTravelIconPainter(color),
      AzkarCategory.childProtection => AzkarChildProtectionIconPainter(color),
      AzkarCategory.illness => AzkarIllnessIconPainter(color),
      AzkarCategory.distress => AzkarDistressIconPainter(color),
      AzkarCategory.debt => AzkarDebtIconPainter(color),
      AzkarCategory.visitingGrave => AzkarVisitingGraveIconPainter(color),
      AzkarCategory.visitingSick => AzkarVisitingSickIconPainter(color),
      AzkarCategory.funeral => AzkarFuneralIconPainter(color),
      AzkarCategory.weather => AzkarWeatherIconPainter(color),
      AzkarCategory.foodFasting => AzkarFoodFastingIconPainter(color),
      AzkarCategory.marriage => AzkarMarriageIconPainter(color),
      AzkarCategory.wakingUp => AzkarWakingUpIconPainter(color),
      AzkarCategory.home => AzkarHomeIconPainter(color),
      AzkarCategory.clothing => AzkarClothingIconPainter(color),
      AzkarCategory.toilet => AzkarToiletIconPainter(color),
      AzkarCategory.wudu => AzkarWuduIconPainter(color),
      AzkarCategory.mosque => AzkarMosqueIconPainter(color),
      AzkarCategory.anger => AzkarAngerIconPainter(color),
      AzkarCategory.fear => AzkarFearIconPainter(color),
      AzkarCategory.sneezing => AzkarSneezingIconPainter(color),
    };
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
                Divider(color: context.colors.hairline, height: 1),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, AzkarCategory category) {
    // Alternate gold/cyan badge tint per row purely for cute visual
    // variety — stays on the two locked accent tokens, no new palette.
    final index = AzkarCategory.values.indexOf(category);
    final accent = index.isEven ? context.colors.gold : context.colors.accentSecondary;
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _iconBadge(accent, category),
            const SizedBox(width: 16),
            Expanded(
              child: Text(category.label, style: TextStyle(color: context.colors.ink)),
            ),
            Icon(Icons.chevron_right, color: context.colors.sage, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _iconBadge(Color accent, AzkarCategory category) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [accent.withValues(alpha: 0.22), accent.withValues(alpha: 0.08)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.2),
        boxShadow: [
          BoxShadow(color: accent.withValues(alpha: 0.18), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Center(
        child: SizedBox(width: 26, height: 26, child: CustomPaint(painter: category.painter(accent))),
      ),
    );
  }
}
