// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The native isIgnoringBatteryOptimizations/requestIgnoreBattery-
// Optimizations MethodChannel calls (SilentModeChannel,
// MainActivity.kt) existed but nothing in the app ever called them —
// the exact "reliable notifications" fix this app most needed had no
// UI trigger anywhere (found 2026-08-26, direct request). Samsung,
// Xiaomi, and Huawei in particular run background-killing layers on
// top of stock Android that silently drop scheduled alarms/
// notifications unless the app is exempted from battery optimization.
//
// Same "check on resume" pattern as HomeQuickToggles' Silent Mode fix
// (2026-08-25) — the user grants this in a system settings screen,
// not in-app, so the status has to be re-checked when they come back,
// not just once at first build.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_times/data/silent_mode_channel.dart';
import '../../../../core/constants/app_color_tokens.dart';

class BatteryOptimizationSection extends StatefulWidget {
  const BatteryOptimizationSection({super.key, SilentModeChannel? channel})
    : _channel = channel ?? const SilentModeChannel();

  final SilentModeChannel _channel;

  @override
  State<BatteryOptimizationSection> createState() => _BatteryOptimizationSectionState();
}

class _BatteryOptimizationSectionState extends State<BatteryOptimizationSection>
    with WidgetsBindingObserver {
  bool? _isExempted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final exempted = await widget._channel.isIgnoringBatteryOptimizations();
    if (mounted) setState(() => _isExempted = exempted);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Nothing to show once already exempted (the previous "this app is
    // exempt from battery optimization" message was a technical detail
    // that doesn't need surfacing) or before the first check resolves —
    // the underlying exemption request itself is unaffected, this only
    // hides the confirmation copy. Only the actionable "not yet
    // exempted" case renders anything.
    if (_isExempted != false) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l10n.batteryOptimizationSectionHeader),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.batteryOptimizationNotExemptedMessage,
                style: AppTypography.caption(context.colors.sage),
              ),
              const SizedBox(height: 8),
              SemanticButton(
                label: l10n.grantBatteryOptimizationExemptionLabel,
                hint: 'Opens the system battery settings dialog for this app',
                onTap: () async {
                  await widget._channel.requestIgnoreBatteryOptimizations();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    l10n.grantBatteryOptimizationExemptionLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.gold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
