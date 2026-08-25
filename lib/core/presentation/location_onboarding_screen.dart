// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown exactly once, right after the splash screen, before the main
// dashboard — a language choice, then location (needed for accurate
// prayer times), explains manual per-prayer adjustment is available
// if a calculated time doesn't match the user's local masjid, then
// never appears again. Skipping never blocks anything: the app opens
// normally either way, and both stay changeable from Settings after.

import 'package:flutter/material.dart';

import '../app_locale_controller.dart';
import '../constants/app_colors.dart';
import '../location/location_service.dart';
import '../../features/settings/data/app_locale.dart';
import '../../features/settings/data/settings_repository.dart';

class LocationOnboardingScreen extends StatefulWidget {
  const LocationOnboardingScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<LocationOnboardingScreen> createState() => _LocationOnboardingScreenState();
}

class _LocationOnboardingScreenState extends State<LocationOnboardingScreen> {
  final _locationService = const LocationService();
  bool _resolving = false;
  AppLocaleOption _selectedLocale = AppLocaleOption.english;

  Future<void> _finish() async {
    final repository = SettingsRepository();
    final settings = await repository.load();
    await repository.save(
      settings.copyWith(hasSeenLocationOnboarding: true, locale: _selectedLocale),
    );
    AppLocaleController.instance.locale.value = _selectedLocale.locale;
    if (mounted) widget.onFinished();
  }

  Future<void> _enableLocation() async {
    setState(() => _resolving = true);
    await _locationService.getCurrentCoordinates();
    if (mounted) await _finish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose your language',
                style: TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (final option in AppLocaleOption.values) ...[
                    if (option != AppLocaleOption.values.first) const SizedBox(width: 8),
                    Expanded(child: _localeButton(option)),
                  ],
                ],
              ),
              const SizedBox(height: 28),
              const Icon(Icons.location_on_outlined, color: AppColors.gold, size: 48),
              const SizedBox(height: 20),
              const Text(
                'Find your prayer times',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'noor uses your location once, on-device only, to calculate '
                'accurate prayer times for where you are. It is never sent '
                'anywhere and you can change or clear it any time from '
                'Settings.',
                style: TextStyle(color: AppColors.sage, height: 1.4),
              ),
              const SizedBox(height: 12),
              const Text(
                "If a calculated time doesn't match your local masjid, "
                'you can nudge each prayer by a few minutes in Settings too.',
                style: TextStyle(color: AppColors.sage, height: 1.4),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _resolving ? null : _enableLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.paper,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_resolving ? 'Locating…' : 'Enable location'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _resolving ? null : _finish,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.gold,
                    side: const BorderSide(color: AppColors.goldBorder),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Not now — I\'ll set a district in Settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _localeButton(AppLocaleOption option) {
    final selected = option == _selectedLocale;
    return GestureDetector(
      onTap: () => setState(() => _selectedLocale = option),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppColors.gold : AppColors.hairline),
        ),
        child: Text(
          option.nativeName,
          style: TextStyle(
            color: selected ? AppColors.paper : AppColors.ink,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
