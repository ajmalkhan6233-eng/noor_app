// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Settings > Display: the single Rich visuals switch (default OFF).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/haptics/haptic_service.dart';
import '../../../../core/visual_style_controller.dart';
import '../../../../l10n/generated/app_localizations.dart';

class RichVisualsSwitch extends StatelessWidget {
  const RichVisualsSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = VisualStyleController.instance;
    return ValueListenableBuilder<bool>(
      valueListenable: controller.rich,
      builder: (context, rich, _) => Semantics(
        toggled: rich,
        label: l10n.settingsRichVisuals,
        hint: l10n.settingsRichVisualsHint,
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: rich,
          activeThumbColor: context.colors.gold,
          title: Text(l10n.settingsRichVisuals, style: AppTypography.body(context.colors.ink)),
          subtitle: Text(
            l10n.settingsRichVisualsHint,
            style: AppTypography.caption(context.colors.sage),
          ),
          onChanged: (value) {
            const HapticService().tap();
            controller.setRich(value);
          },
        ),
      ),
    );
  }
}
