// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../logic/settings_cubit/settings_cubit.dart';
import '../logic/settings_cubit/settings_state.dart';
import 'widgets/about_donate_section.dart';
import 'widgets/display_section.dart';
import 'widgets/high_latitude_rule_section.dart';
import 'widgets/iqamath_offset_section.dart';
import 'widgets/language_section.dart';
import 'widgets/method_madhab_section.dart';
import 'widgets/prayer_adjustments_section.dart';
import 'widgets/silent_mode_section.dart';

/// Settings: calculation preferences and display. Notification
/// toggles live on the Home dashboard, not buried here.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit()..load(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(l10n.settingsSemanticLabel)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.emerald),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              StaggeredFadeIn(
                children: [
                  SectionHeader(l10n.calculationSectionHeader),
                  AppCard(
                    child: Column(
                      children: const [
                        MethodMadhabSection(),
                        SizedBox(height: 12),
                        HighLatitudeRuleSection(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(l10n.manualAdjustmentsSectionHeader),
                  const AppCard(child: PrayerAdjustmentsSection()),
                  const SizedBox(height: 16),
                  SectionHeader(l10n.iqamathOffsetsSectionHeader),
                  const AppCard(child: IqamathOffsetSection()),
                  const SizedBox(height: 16),
                  SectionHeader(l10n.silentModeSectionHeader),
                  const AppCard(child: SilentModeSection()),
                  const SizedBox(height: 16),
                  SectionHeader(l10n.displaySectionHeader),
                  const AppCard(child: DisplaySection()),
                  const SizedBox(height: 16),
                  SectionHeader(l10n.languageSectionHeader),
                  const AppCard(child: LanguageSection()),
                  const SizedBox(height: 24),
                  const AboutDonateSection(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
