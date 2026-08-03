// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              _SectionHeader('Calculation'),
              MethodMadhabSection(),
              SizedBox(height: 12),
              HighLatitudeRuleSection(),
              _SectionHeader('Manual adjustments (minutes)'),
              PrayerAdjustmentsSection(),
              _SectionHeader('Notifications'),
              NotificationTogglesSection(),
              _SectionHeader('Display'),
              DisplaySection(),
              SizedBox(height: 32),
              Divider(color: AppColors.divider),
              SizedBox(height: 8),
              AboutDonateSection(),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
