// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One optional reminder alarm fired a configurable number of minutes
// before each enabled prayer's adhan — separate from the at-prayer-
// time adhan toggle itself (that one stays per-prayer, on the Home
// dashboard; this is a single global on/off + minutes value).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

class PreReminderSection extends StatelessWidget {
  const PreReminderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final enabled = state.settings.preReminderEnabled;
        final minutes = state.settings.preReminderMinutes;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Remind me before adhan',
                  style: TextStyle(color: AppColors.ink),
                ),
                SemanticButton(
                  label: enabled
                      ? 'Turn off pre-adhan reminder'
                      : 'Turn on pre-adhan reminder',
                  onTap: () => context.read<SettingsCubit>().setPreReminderEnabled(!enabled),
                  child: Icon(
                    enabled ? Icons.notifications_active : Icons.notifications_off_outlined,
                    color: enabled ? AppColors.gold : AppColors.sage,
                  ),
                ),
              ],
            ),
            if (enabled) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Minutes before',
                    style: TextStyle(color: AppColors.sage, fontSize: 13),
                  ),
                  Row(
                    children: [
                      SemanticButton(
                        label: 'Decrease reminder minutes',
                        onTap: () => context
                            .read<SettingsCubit>()
                            .setPreReminderMinutes((minutes - 5).clamp(5, 60)),
                        child: const Icon(Icons.remove, color: AppColors.gold),
                      ),
                      SizedBox(
                        width: 48,
                        child: Text(
                          '$minutes min',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.sage),
                        ),
                      ),
                      SemanticButton(
                        label: 'Increase reminder minutes',
                        onTap: () => context
                            .read<SettingsCubit>()
                            .setPreReminderMinutes((minutes + 5).clamp(5, 60)),
                        child: const Icon(Icons.add, color: AppColors.gold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
