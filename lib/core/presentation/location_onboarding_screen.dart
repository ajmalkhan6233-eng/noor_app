// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown exactly once, right after the splash screen, before the main
// dashboard — a language choice, then location (needed for accurate
// prayer times). Skipping never blocks anything: the app opens
// normally either way, and both stay changeable from Settings after.
//
// The battery-optimization step was cut (2026-08-25 live-device
// review: "people will not like that question... this is critical" —
// a second permission-style prompt during first launch was too much
// friction). "Allow unrestricted battery usage" is still reachable
// from Settings for anyone who wants more reliable background adhan.
//
// GPS has no network fallback in this app (zero INTERNET permission,
// locked) — a pure on-device GPS fix can fail indoors or time out.
// The old version discarded that failure silently and always
// finished onboarding anyway, leaving the app half-configured until
// the user found their own way to Settings to pick a district
// (2026-08-25 live-device review: "the [app] should be displayed...
// without that I have to go inside settings"). Now a failed fix
// reveals the same district picker inline, right here, so one tap of
// "Enable location" always ends with a fully working app either way.

import 'package:flutter/material.dart';

import '../app_locale_controller.dart';
import '../constants/app_colors.dart';
import '../location/location_service.dart';
import '../utils/semantics_helpers.dart';
import '../../features/prayer_times/presentation/widgets/district_selector.dart';
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
  bool _gpsFailed = false;
  String? _pickedDistrict;
  AppLocaleOption _selectedLocale = AppLocaleOption.english;

  Future<void> _finish({String? district}) async {
    final repository = SettingsRepository();
    final settings = await repository.load();
    await repository.save(
      settings
          .copyWith(hasSeenLocationOnboarding: true, locale: _selectedLocale)
          .withSelectedDistrict(district ?? settings.selectedDistrict),
    );
    AppLocaleController.instance.locale.value = _selectedLocale.locale;
    if (mounted) widget.onFinished();
  }

  Future<void> _enableLocation() async {
    setState(() => _resolving = true);
    final coordinates = await _locationService.getCurrentCoordinates();
    if (!mounted) return;
    if (coordinates != null) {
      await _finish();
      return;
    }
    setState(() {
      _resolving = false;
      _gpsFailed = true;
    });
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
              const SizedBox(height: 20),
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
              if (_gpsFailed) ...[
                const SizedBox(height: 16),
                const Text(
                  "Couldn't get a GPS fix — pick your district instead, "
                  "just this once.",
                  style: TextStyle(color: AppColors.sage, height: 1.4),
                ),
                const SizedBox(height: 12),
                DistrictSelector(
                  selectedDistrict: _pickedDistrict,
                  onSelected: (district) => setState(() => _pickedDistrict = district.name),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _pickedDistrict == null
                        ? null
                        : () => _finish(district: _pickedDistrict),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.paper,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _resolving ? null : () => _finish(),
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
    return SemanticButton(
      label: option.nativeName,
      hint: 'Double tap to set app language',
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
