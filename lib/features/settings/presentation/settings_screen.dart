// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../logic/settings_cubit/settings_cubit.dart';
import '../logic/settings_cubit/settings_state.dart';
import 'widgets/about_donate_section.dart';
import 'widgets/adhan_sound_section.dart';
import 'widgets/advanced_timing_section.dart';
import 'widgets/battery_optimization_section.dart';
import 'widgets/country_section.dart';
import 'widgets/display_section.dart';
import 'widgets/downloaded_audio_section.dart';
import 'widgets/high_latitude_rule_section.dart';
import 'widgets/language_section.dart';
import 'widgets/location_section.dart';
import 'widgets/method_madhab_section.dart';
import 'widgets/pre_reminder_section.dart';
import 'widgets/test_adhan_section.dart';
import '../../../core/constants/app_color_tokens.dart';

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
      backgroundColor: context.colors.paper,
      appBar: AppBar(title: Text(l10n.settingsSemanticLabel)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: context.colors.gold),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              StaggeredFadeIn(
                children: [
                  SectionHeader(l10n.locationSectionHeader),
                  const AppCard(child: LocationSection()),
                  const SizedBox(height: 16),
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
                  const AppCard(child: AdvancedTimingSection()),
                  const SizedBox(height: 16),
                  SectionHeader(l10n.preReminderSectionHeader),
                  const AppCard(child: PreReminderSection()),
                  const SizedBox(height: 16),
                  const SectionHeader('Adhan Sound'),
                  const AppCard(child: AdhanSoundSection()),
                  const SizedBox(height: 16),
                  const SectionHeader('Test Adhan'),
                  const AppCard(child: TestAdhanSection()),
                  const SizedBox(height: 16),
                  const BatteryOptimizationSection(),
                  const DownloadedAudioSection(),
                  SectionHeader(l10n.displaySectionHeader),
                  const AppCard(child: DisplaySection()),
                  const SizedBox(height: 16),
                  SectionHeader(l10n.languageSectionHeader),
                  const AppCard(child: LanguageSection()),
                  const SizedBox(height: 16),
                  SectionHeader(l10n.countrySectionHeader),
                  const AppCard(child: CountrySection()),
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
