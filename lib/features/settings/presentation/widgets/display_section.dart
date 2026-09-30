// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_theme_controller.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/app_theme_mode.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';
import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/corner_radius.dart';

/// Theme, Quran text size (Arabic + translation), and Hijri calendar offset.
class DisplaySection extends StatelessWidget {
  const DisplaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final settings = state.settings;
        final l10n = AppLocalizations.of(context)!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _themeSegments(context, settings.themeMode),
            const SizedBox(height: 12),
            Semantics(
              label: l10n.settingsQuranTextSize,
              value: '${settings.arabicFontScale.toStringAsFixed(2)}x',
              slider: true,
              child: Slider(
                activeColor: context.colors.gold,
                min: 0.75,
                max: 2.0,
                divisions: 25,
                value: settings.arabicFontScale,
                onChanged: (v) =>
                    context.read<SettingsCubit>().setArabicFontScale(v),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.settingsHijriOffset,
                  style: TextStyle(color: context.colors.ink),
                ),
                Row(
                  children: [
                    SemanticButton(
                      label: l10n.settingsHijriDecrease,
                      onTap: () => context
                          .read<SettingsCubit>()
                          .setHijriOffsetDays(settings.hijriOffsetDays - 1),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.remove, color: context.colors.gold),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${settings.hijriOffsetDays}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.colors.sage),
                      ),
                    ),
                    SemanticButton(
                      label: l10n.settingsHijriIncrease,
                      onTap: () => context
                          .read<SettingsCubit>()
                          .setHijriOffsetDays(settings.hijriOffsetDays + 1),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.add, color: context.colors.gold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Compact three-way segmented control instead of a dropdown — sets
  // AppThemeController live (so the MaterialApp itself repaints
  // immediately) alongside the persisted SettingsCubit value.
  Widget _themeSegments(BuildContext context, AppThemeModeOption selected) {
    final l10n = AppLocalizations.of(context)!;
    String labelOf(AppThemeModeOption m) => switch (m) {
      AppThemeModeOption.dark => l10n.themeNebula,
      AppThemeModeOption.light => l10n.themeDawn,
      AppThemeModeOption.system => l10n.themeFollowSystem,
      AppThemeModeOption.mushaf => l10n.themeMushaf,
      AppThemeModeOption.emeraldNight => l10n.themeEmeraldNight,
    };
    return Semantics(
      label: l10n.settingsThemeLabel,
      value: labelOf(selected),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final mode in AppThemeModeOption.values)
            SizedBox(
              width: 104,
              child: SemanticButton(
                label: labelOf(mode),
                onTap: () {
                  context.read<SettingsCubit>().setThemeMode(mode);
                  AppThemeController.instance.apply(mode);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: mode == selected ? context.colors.gold : Colors.transparent,
                    borderRadius: BorderRadius.circular(context.radiusFor(10)),
                    border: Border.all(
                      color: mode == selected ? context.colors.gold : context.colors.hairline,
                    ),
                  ),
                  child: Text(
                    labelOf(mode),
                    style: TextStyle(
                      color: mode == selected ? context.colors.paper : context.colors.ink,
                      fontWeight: mode == selected ? FontWeight.w700 : FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
