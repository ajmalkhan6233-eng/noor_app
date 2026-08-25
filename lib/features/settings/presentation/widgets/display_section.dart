// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_theme_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../data/app_theme_mode.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

/// Theme, Quran text size (Arabic + translation), and Hijri calendar offset.
class DisplaySection extends StatelessWidget {
  const DisplaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final settings = state.settings;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _themeSegments(context, settings.themeMode),
            const SizedBox(height: 12),
            Semantics(
              label: 'Quran text size',
              value: '${settings.arabicFontScale.toStringAsFixed(2)}x',
              slider: true,
              child: Slider(
                activeColor: AppColors.gold,
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
                const Text(
                  'Hijri offset',
                  style: TextStyle(color: AppColors.ink),
                ),
                Row(
                  children: [
                    SemanticButton(
                      label: 'Decrease Hijri offset',
                      onTap: () => context
                          .read<SettingsCubit>()
                          .setHijriOffsetDays(settings.hijriOffsetDays - 1),
                      child: const Icon(Icons.remove, color: AppColors.gold),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${settings.hijriOffsetDays}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.sage),
                      ),
                    ),
                    SemanticButton(
                      label: 'Increase Hijri offset',
                      onTap: () => context
                          .read<SettingsCubit>()
                          .setHijriOffsetDays(settings.hijriOffsetDays + 1),
                      child: const Icon(Icons.add, color: AppColors.gold),
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
    return Semantics(
      label: 'Theme',
      value: selected.label,
      child: Row(
        children: [
          for (final mode in AppThemeModeOption.values) ...[
            if (mode != AppThemeModeOption.values.first) const SizedBox(width: 8),
            Expanded(
              child: SemanticButton(
                label: mode.label,
                onTap: () {
                  context.read<SettingsCubit>().setThemeMode(mode);
                  AppThemeController.instance.themeMode.value = mode.flutterThemeMode;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: mode == selected ? AppColors.gold : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: mode == selected ? AppColors.gold : AppColors.hairline,
                    ),
                  ),
                  child: Text(
                    mode.label,
                    style: TextStyle(
                      color: mode == selected ? AppColors.paper : AppColors.ink,
                      fontWeight: mode == selected ? FontWeight.w700 : FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
