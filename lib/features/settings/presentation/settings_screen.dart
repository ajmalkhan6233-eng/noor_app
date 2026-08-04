// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../logic/settings_cubit/settings_cubit.dart';
import '../logic/settings_cubit/settings_state.dart';
import 'widgets/about_donate_section.dart';
import 'widgets/display_section.dart';
import 'widgets/high_latitude_rule_section.dart';
import 'widgets/method_madhab_section.dart';
import 'widgets/notification_toggles_section.dart';
import 'widgets/prayer_adjustments_section.dart';

/// Settings: calculation preferences, notifications, display, and —
/// at the very bottom, once, quietly — About and Donate.
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
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: const Text('Settings')),
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
                children: const [
                  SectionHeader('Calculation'),
                  AppCard(
                    child: Column(
                      children: [
                        MethodMadhabSection(),
                        SizedBox(height: 12),
                        HighLatitudeRuleSection(),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  SectionHeader('Manual adjustments (minutes)'),
                  AppCard(child: PrayerAdjustmentsSection()),
                  SizedBox(height: 16),
                  SectionHeader('Notifications'),
                  AppCard(child: NotificationTogglesSection()),
                  SizedBox(height: 16),
                  SectionHeader('Display'),
                  AppCard(child: DisplaySection()),
                  SizedBox(height: 24),
                  AboutDonateSection(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
