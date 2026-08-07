// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Fixed settings entry point in the top bar. Previously a free-drag
// floating button (DraggableFloating) positioned over the tab content;
// moved into the persistent top bar per the locked UI structure, so it
// no longer needs to be repositionable.

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/semantics_helpers.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../settings/presentation/settings_screen.dart';

class SettingsGearButton extends StatelessWidget {
  const SettingsGearButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SemanticButton(
      label: l10n.settingsSemanticLabel,
      hint: l10n.settingsHint,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
      ),
      child: const Icon(Icons.settings_outlined, color: AppColors.gold, size: 22),
    );
  }
}
