// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Animation level picker: Full, Reduced or Off. Reads and writes only
// through SettingsCubit.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

class MotionSection extends StatelessWidget {
  const MotionSection({super.key});

  static const _modes = ['Full', 'Reduced', 'Off'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final mode = state.settings.motionMode;
        return Semantics(
          label: l10n.motionSettingTitle,
          value: l10n.motionSettingSemantics(mode),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.motionSettingTitle,
                  style: AppTypography.body(context.colors.ink),
                ),
              ),
              DropdownButton<String>(
                value: _modes.contains(mode) ? mode : 'Full',
                dropdownColor: context.colors.card,
                underline: const SizedBox.shrink(),
                items: [
                  for (final m in _modes)
                    DropdownMenuItem(
                      value: m,
                      child: Text(m, style: AppTypography.body(context.colors.ink)),
                    ),
                ],
                onChanged: (v) {
                  if (v != null) context.read<SettingsCubit>().setMotionMode(v);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
