// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../data/app_theme_mode.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

/// Theme, Arabic text size, and Hijri calendar offset.
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
            Semantics(
              label: 'Theme',
              value: settings.themeMode.label,
              child: DropdownButton<AppThemeModeOption>(
                isExpanded: true,
                value: settings.themeMode,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
                items: [
                  for (final mode in AppThemeModeOption.values)
                    DropdownMenuItem(value: mode, child: Text(mode.label)),
                ],
                onChanged: (mode) {
                  if (mode != null) {
                    context.read<SettingsCubit>().setThemeMode(mode);
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              label: 'Arabic text size',
              value: '${settings.arabicFontScale.toStringAsFixed(2)}x',
              slider: true,
              child: Slider(
                activeColor: AppColors.accent,
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
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                Row(
                  children: [
                    SemanticButton(
                      label: 'Decrease Hijri offset',
                      onTap: () => context
                          .read<SettingsCubit>()
                          .setHijriOffsetDays(settings.hijriOffsetDays - 1),
                      child: const Icon(Icons.remove, color: AppColors.accent),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${settings.hijriOffsetDays}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    SemanticButton(
                      label: 'Increase Hijri offset',
                      onTap: () => context
                          .read<SettingsCubit>()
                          .setHijriOffsetDays(settings.hijriOffsetDays + 1),
                      child: const Icon(Icons.add, color: AppColors.accent),
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
}
