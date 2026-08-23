// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Entry point for the pilgrimage tracker: pick an existing pilgrim
// profile or add a new one, then continue to session setup.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/pilgrim_profile.dart';
import '../logic/profile_cubit/profile_cubit.dart';
import '../logic/profile_cubit/profile_state.dart';
import 'add_profile_screen.dart';
import 'pilgrimage_session_screen.dart';

class PilgrimageHomeScreen extends StatelessWidget {
  const PilgrimageHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PilgrimProfileCubit()..loadProfiles(),
      child: const _PilgrimageHomeView(),
    );
  }
}

class _PilgrimageHomeView extends StatelessWidget {
  const _PilgrimageHomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(l10n.pilgrimageLabel)),
      body: BlocBuilder<PilgrimProfileCubit, PilgrimProfileState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              StaggeredFadeIn(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(l10n.profilePickerTitle, style: const TextStyle(color: AppColors.ink, fontSize: 18)),
                  ),
                  if (state.profiles.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(l10n.profilePickerEmptyMessage, style: const TextStyle(color: AppColors.sage)),
                    ),
                  if (state.profiles.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AppCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            for (final profile in state.profiles) ...[
                              _profileRow(context, profile),
                              if (profile != state.profiles.last)
                                const Divider(color: AppColors.hairline, height: 1),
                            ],
                          ],
                        ),
                      ),
                    ),
                  SemanticButton(
                    label: l10n.addProfileLabel,
                    hint: l10n.addProfileHint,
                    onTap: () => _addProfile(context),
                    child: AppCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_add_alt, color: AppColors.gold),
                          const SizedBox(width: 8),
                          Text(l10n.addProfileLabel, style: const TextStyle(color: AppColors.gold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addProfile(BuildContext context) async {
    final created = await Navigator.of(context).push<PilgrimProfile>(
      MaterialPageRoute<PilgrimProfile>(builder: (_) => const AddProfileScreen()),
    );
    if (created == null || !context.mounted) return;
    context.read<PilgrimProfileCubit>().loadProfiles();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PilgrimageSessionScreen(profile: created)),
    );
  }

  Widget _profileRow(BuildContext context, PilgrimProfile profile) {
    final l10n = AppLocalizations.of(context)!;
    return SemanticButton(
      label: profile.displayName,
      hint: l10n.selectProfileHint(profile.displayName),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PilgrimageSessionScreen(profile: profile),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.person_outline, color: AppColors.gold, size: 20),
            const SizedBox(width: 16),
            Expanded(child: Text(profile.displayName, style: const TextStyle(color: AppColors.ink))),
            const Icon(Icons.chevron_right, color: AppColors.sage, size: 18),
          ],
        ),
      ),
    );
  }
}
