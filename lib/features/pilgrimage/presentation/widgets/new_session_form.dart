// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Lets the pilgrim choose a type (Umrah/Hajj) and gender (drives
// Idtiba/Ramal only — never persisted) before starting a new session.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/pilgrim_profile.dart';
import '../../data/pilgrimage_session.dart';
import '../../logic/session_cubit/session_cubit.dart';

class NewSessionForm extends StatefulWidget {
  const NewSessionForm({super.key, required this.profile});

  final PilgrimProfile profile;

  @override
  State<NewSessionForm> createState() => _NewSessionFormState();
}

class _NewSessionFormState extends State<NewSessionForm> {
  PilgrimageType _type = PilgrimageType.umrah;
  bool _isMale = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.pilgrimageTypeLabel, style: const TextStyle(color: AppColors.sage)),
        const SizedBox(height: 8),
        _choiceRow(l10n.umrahLabel, _type == PilgrimageType.umrah, () => setState(() => _type = PilgrimageType.umrah)),
        _choiceRow(l10n.hajjLabel, _type == PilgrimageType.hajj, () => setState(() => _type = PilgrimageType.hajj)),
        const SizedBox(height: 24),
        Text(l10n.genderLabel, style: const TextStyle(color: AppColors.sage)),
        const SizedBox(height: 8),
        _choiceRow(l10n.maleLabel, _isMale, () => setState(() => _isMale = true)),
        _choiceRow(l10n.femaleLabel, !_isMale, () => setState(() => _isMale = false)),
        const SizedBox(height: 24),
        SemanticButton(
          label: l10n.startSessionButtonLabel,
          hint: l10n.startSessionButtonHint,
          onTap: () {
            final cubit = context.read<PilgrimageSessionCubit>();
            cubit.setGender(isMale: _isMale);
            cubit.startSession(_type);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.emerald, borderRadius: BorderRadius.circular(12)),
            child: Text(l10n.startSessionButtonLabel, style: const TextStyle(color: AppColors.card, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _choiceRow(String label, bool selected, VoidCallback onTap) {
    return SemanticButton(
      label: label,
      hint: AppLocalizations.of(context)!.selectOptionHint,
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: AppColors.emerald,
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: AppColors.ink)),
          ],
        ),
      ),
    );
  }
}
