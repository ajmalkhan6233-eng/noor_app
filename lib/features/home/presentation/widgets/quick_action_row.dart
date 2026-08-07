// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Four one-tap shortcuts to the features people reach for most.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../calendar/presentation/calendar_screen.dart';
import '../../../qibla/presentation/qibla_screen.dart';
import '../../../tasbih/presentation/tasbih_screen.dart';
import '../../../zakat/presentation/zakat_screen.dart';

class QuickActionRow extends StatelessWidget {
  const QuickActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _action(context, Icons.blur_circular, 'Tasbih', const TasbihScreen()),
        _action(context, Icons.explore, 'Qibla', const QiblaScreen()),
        _action(context, Icons.calendar_month, 'Calendar', const CalendarScreen()),
        _action(context, Icons.savings_outlined, 'Zakat', const ZakatScreen()),
      ],
    );
  }

  Widget _action(
    BuildContext context,
    IconData icon,
    String label,
    Widget destination,
  ) {
    return Expanded(
      child: SemanticButton(
        label: label,
        hint: 'Double tap to open $label',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => destination),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.hairline),
              ),
              child: Icon(icon, color: AppColors.emerald),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: AppColors.sage, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
