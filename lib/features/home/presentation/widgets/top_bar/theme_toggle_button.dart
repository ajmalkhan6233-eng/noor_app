// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Crescent icon that cycles the persisted theme-mode preference
// (dark -> light -> system -> dark). Note: buildLightTheme() and
// buildDarkTheme() currently resolve to the same locked dark palette
// (see app_theme.dart), so light/system won't visibly change anything
// yet — this only wires up and persists the preference for whenever a
// light variant of the palette is authored.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/semantics_helpers.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../settings/data/app_theme_mode.dart';
import '../../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../../settings/logic/settings_cubit/settings_state.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  void _cycle(BuildContext context, AppThemeModeOption current) {
    const values = AppThemeModeOption.values;
    final next = values[(values.indexOf(current) + 1) % values.length];
    context.read<SettingsCubit>().setThemeMode(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final mode = state.settings.themeMode;
        return Semantics(
          value: mode.label,
          child: SemanticButton(
            label: l10n.themeToggleSemanticLabel,
            hint: l10n.themeToggleHint,
            onTap: () => _cycle(context, mode),
            child: const Icon(
              Icons.nightlight_round,
              color: AppColors.gold,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}
