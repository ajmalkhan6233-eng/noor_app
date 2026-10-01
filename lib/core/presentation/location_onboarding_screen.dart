// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown exactly once, right after the splash: ONE friendly welcome
// screen with ONE button. Tapping it asks, back to back, for location,
// notifications and (only if the phone needs it) exact alarms, each
// explained in a plain line above the button. A "no" never blocks
// anything: prayer times quietly use the last known location (else a
// default) and Settings keeps a small "Allow location" button. The
// language choice stays here because it is a choice, not a permission.

import 'package:flutter/material.dart';

import '../app_locale_controller.dart';
import '../constants/app_color_tokens.dart';
import '../constants/app_spacing.dart';
import '../constants/corner_radius.dart';
import '../permissions/permission_gateway.dart';
import '../permissions/permission_onboarding.dart';
import '../../features/settings/data/app_locale.dart';
import '../../features/settings/data/settings_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import 'welcome_widgets.dart';

class LocationOnboardingScreen extends StatefulWidget {
  const LocationOnboardingScreen({
    super.key,
    required this.onFinished,
    this.gateway,
    this.settingsRepository,
  });

  final VoidCallback onFinished;

  /// Injected by tests; the app uses the real device permissions.
  final PermissionGateway? gateway;
  final SettingsRepository? settingsRepository;

  @override
  State<LocationOnboardingScreen> createState() => _LocationOnboardingScreenState();
}

class _LocationOnboardingScreenState extends State<LocationOnboardingScreen> {
  bool _working = false;
  AppLocaleOption _selectedLocale = AppLocaleOption.english;

  Future<void> _start() async {
    if (_working) return;
    setState(() => _working = true);
    await PermissionOnboarding(gateway: widget.gateway).run();
    final repository = widget.settingsRepository ?? SettingsRepository();
    final settings = await repository.load();
    await repository.save(
      settings.copyWith(hasSeenLocationOnboarding: true, locale: _selectedLocale),
    );
    AppLocaleController.instance.locale.value = _selectedLocale.locale;
    if (mounted) widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.paper,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.screenHorizontal,
                  AppSpacing.screenHorizontal,
                  8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.welcomeLanguageLabel, style: TextStyle(color: colors.sage)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (final option in AppLocaleOption.values) ...[
                          if (option != AppLocaleOption.values.first) const SizedBox(width: 8),
                          Expanded(
                            child: LocaleChoiceButton(
                              option: option,
                              selected: option == _selectedLocale,
                              hint: l10n.welcomeLanguageHint,
                              onTap: () => setState(() => _selectedLocale = option),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(child: Icon(Icons.nights_stay_outlined, color: colors.gold, size: 56)),
                    const SizedBox(height: 16),
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.welcomeTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: colors.ink),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.welcomeIntro, style: TextStyle(color: colors.sage, height: 1.4)),
                    const SizedBox(height: 20),
                    WelcomeReason(icon: Icons.location_on_outlined, text: l10n.welcomeReasonLocation),
                    WelcomeReason(icon: Icons.notifications_outlined, text: l10n.welcomeReasonNotifications),
                    WelcomeReason(icon: Icons.alarm, text: l10n.welcomeReasonAlarms),
                  ],
                ),
              ),
            ),
            // The one button stays pinned at the bottom, never below the fold.
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _working ? null : _start,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.gold,
                    foregroundColor: colors.paper,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.radiusFor(12)),
                    ),
                  ),
                  child: Text(_working ? l10n.welcomeWorking : l10n.welcomeButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
