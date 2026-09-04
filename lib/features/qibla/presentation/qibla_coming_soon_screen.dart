// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Replaces the live Qibla compass for this release (2026-09-04, direct
// request) — the compass dial has a real, unresolved GPU/compositor
// rendering glitch (see CLAUDE.md's log), and rather than ship a
// visibly broken/flickering screen, this honest placeholder takes its
// place in navigation. None of the sensor/rendering code
// (compass_needle_and_badge.dart, qibla_compass_dial.dart, etc.) is
// touched or deleted — only More screen's route target changes, so
// re-enabling the real screen later is a one-line swap back.
//
// Offers a reasonable fallback where it can: a plain bearing/distance
// number using the already-correct QiblaCalculator math, with no
// needle, no sensor stream, no live rendering at all — just today's
// last-known location from PrayerCubit if one is available.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/glass_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_state.dart';
import '../data/qibla_calculator.dart';
import '../../../core/constants/app_color_tokens.dart';

class QiblaComingSoonScreen extends StatelessWidget {
  const QiblaComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.paper,
      appBar: AppBar(
        backgroundColor: context.colors.paper,
        elevation: 0,
        title: Text(l10n.qiblaScreenTitle),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.explore_outlined, color: context.colors.gold, size: 40),
                const SizedBox(height: 16),
                Text(
                  l10n.comingSoonMessage(l10n.qiblaScreenTitle),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.ink, fontSize: 16),
                ),
                const SizedBox(height: 20),
                BlocBuilder<PrayerCubit, PrayerState>(
                  builder: (context, state) {
                    if (!state.hasCoordinates) return const SizedBox.shrink();
                    final bearing = QiblaCalculator.bearingToKaaba(state.latitude!, state.longitude!);
                    final distance = QiblaCalculator.distanceToKaabaKm(state.latitude!, state.longitude!);
                    return Semantics(
                      label: '${bearing.round()} degrees ${l10n.qiblaBearingReadoutLabel}, '
                          '${distance.round()} kilometres to the Kaaba',
                      child: Text(
                        '${bearing.round()}° ${l10n.qiblaBearingReadoutLabel}  ·  '
                        '${distance.round()} km',
                        style: TextStyle(color: context.colors.gold, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
