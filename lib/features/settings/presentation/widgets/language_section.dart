// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// UI chrome language only — Quran/Azkar Arabic text and its existing
// transliteration/translation are never affected by this setting.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_locale_controller.dart';
import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/app_locale.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

/// Dropdown to switch the app's interface language — applied
/// immediately via [AppLocaleController], and persisted through
/// [SettingsCubit] so it's remembered after a restart.
class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final selected = state.settings.locale;
        return Semantics(
          label: l10n.languagePickerSemanticLabel,
          value: selected.nativeName,
          child: DropdownButton<AppLocaleOption>(
            isExpanded: true,
            value: selected,
            dropdownColor: context.colors.card,
            style: TextStyle(color: context.colors.ink),
            items: [
              for (final option in AppLocaleOption.values)
                DropdownMenuItem(
                  value: option,
                  child: Text(
                    option.nativeName,
                    style: TextStyle(
                      fontFamily: AppTypography.uiFamilyForLanguageCode(
                        option.languageCode,
                      ),
                    ),
                  ),
                ),
            ],
            onChanged: (option) {
              if (option == null) return;
              context.read<SettingsCubit>().setLocale(option);
              AppLocaleController.instance.locale.value = option.locale;
            },
          ),
        );
      },
    );
  }
}
