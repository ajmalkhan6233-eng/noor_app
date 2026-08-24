// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Fixed settings entry point in the top bar. Previously a free-drag
// floating button (DraggableFloating) positioned over the tab content;
// moved into the persistent top bar per the locked UI structure, so it
// no longer needs to be repositionable.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/semantics_helpers.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../../../settings/presentation/settings_screen.dart';

class SettingsGearButton extends StatelessWidget {
  const SettingsGearButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prayerCubit = context.read<PrayerCubit>();
    return SemanticButton(
      label: l10n.settingsSemanticLabel,
      hint: l10n.settingsHint,
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
        );
        // Location (and everything else) is only ever changed from
        // Settings now, which doesn't share this tab shell's
        // PrayerCubit — re-read from the DB on return so a location
        // change there takes effect immediately, not just next launch.
        await prayerCubit.loadSettings();
      },
      child: const Icon(Icons.settings_outlined, color: AppColors.gold, size: 22),
    );
  }
}
