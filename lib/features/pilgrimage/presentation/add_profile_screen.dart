// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Create a new pilgrim profile: a display name plus a beginner or
// experienced choice (also used to seed `preferred_language`).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_locale_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/pilgrim_profile.dart';
import '../logic/profile_cubit/profile_cubit.dart';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _nameController = TextEditingController();
  PilgrimExperienceLevel _level = PilgrimExperienceLevel.beginner;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => PilgrimProfileCubit(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.paper,
          appBar: AppBar(title: Text(l10n.addProfileLabel)),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  textField: true,
                  label: l10n.profileNameFieldLabel,
                  hint: l10n.profileNameFieldHint,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: l10n.profileNameFieldLabel),
                  ),
                ),
                const SizedBox(height: 24),
                Text(l10n.experienceLevelLabel, style: const TextStyle(color: AppColors.sage)),
                _levelChoice(l10n.beginnerLabel, PilgrimExperienceLevel.beginner),
                _levelChoice(l10n.experiencedLabel, PilgrimExperienceLevel.experienced),
                const SizedBox(height: 24),
                SemanticButton(
                  label: l10n.createProfileButtonLabel,
                  hint: l10n.createProfileButtonHint,
                  onTap: () => _submit(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.createProfileButtonLabel,
                      style: const TextStyle(color: AppColors.card, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _levelChoice(String label, PilgrimExperienceLevel level) {
    final selected = _level == level;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SemanticButton(
        label: label,
        hint: AppLocalizations.of(context)!.selectOptionHint,
        onTap: () => setState(() => _level = level),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: AppColors.gold,
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: AppColors.ink)),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<PilgrimProfileCubit>();
    final locale = AppLocaleController.instance.locale.value;
    await cubit.createProfile(
      displayName: _nameController.text,
      experienceLevel: _level,
      preferredLanguage: locale?.languageCode,
    );
    final created = cubit.state.selected;
    if (created != null && context.mounted) {
      Navigator.of(context).pop(created);
    }
  }
}
