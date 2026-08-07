// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Three tap targets (EN / தமிழ் / සිංහල) instead of Settings' dropdown
// — the top bar wants an always-visible, one-tap switch. Applies
// immediately via AppLocaleController and persists through
// SettingsCubit, same as the Settings screen's own picker.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_locale_controller.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/semantics_helpers.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../settings/data/app_locale.dart';
import '../../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../../settings/logic/settings_cubit/settings_state.dart';

class LanguagePills extends StatelessWidget {
  const LanguagePills({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final selected = state.settings.locale;
        return Semantics(
          label: l10n.languagePickerSemanticLabel,
          value: selected.nativeName,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option in AppLocaleOption.values) ...[
                _pill(context, option, option == selected),
                if (option != AppLocaleOption.values.last) const SizedBox(width: 4),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _pill(BuildContext context, AppLocaleOption option, bool active) {
    return SemanticButton(
      label: option.nativeName,
      hint: AppLocalizations.of(context)!.switchLanguageHint,
      onTap: () {
        context.read<SettingsCubit>().setLocale(option);
        AppLocaleController.instance.locale.value = option.locale;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: active ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: active ? null : Border.all(color: AppColors.hairline),
        ),
        child: Text(
          _shortLabel(option),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.paper : AppColors.sage,
          ),
        ),
      ),
    );
  }

  String _shortLabel(AppLocaleOption option) {
    return switch (option) {
      AppLocaleOption.english => 'EN',
      AppLocaleOption.tamil => option.nativeName,
      AppLocaleOption.sinhala => option.nativeName,
    };
  }
}
