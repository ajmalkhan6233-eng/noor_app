// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Selectable Adhan sound — see adhan_reciter.dart. Shows the required
// attribution line for the active selection directly beneath the
// picker (the licence condition for four of the five options, not
// optional copy) rather than only in About, since this is the screen
// where the choice is actually made.
//
// Tapping a reciter both selects it AND plays a preview immediately
// (standard ringtone-picker behavior) — previously it only silently
// saved the preference with no audio feedback at all, so there was no
// way to hear a reciter before/after choosing it (live-device report,
// 2026-09-06: "when I click on the country, it's not playing").

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_times/data/adhan_audio_player.dart';
import '../../../prayer_times/data/adhan_reciter.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

class AdhanSoundSection extends StatefulWidget {
  const AdhanSoundSection({super.key});

  @override
  State<AdhanSoundSection> createState() => _AdhanSoundSectionState();
}

class _AdhanSoundSectionState extends State<AdhanSoundSection> {
  final _player = AdhanAudioPlayer();
  AdhanReciter? _previewing;

  @override
  void initState() {
    super.initState();
    _player.onComplete.listen((_) {
      if (mounted) setState(() => _previewing = null);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _selectAndPreview(AdhanReciter reciter) async {
    context.read<SettingsCubit>().setAdhanReciter(reciter);
    if (_previewing == reciter) {
      await _player.stop();
      setState(() => _previewing = null);
      return;
    }
    setState(() => _previewing = reciter);
    // Every reciter (doha included) has a Fajr recording, so it's a
    // safe fixed subject for a picker preview that isn't tied to any
    // specific real prayer.
    await _player.play('Fajr', reciter: reciter);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final selected = state.settings.adhanReciter;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final reciter in AdhanReciter.values)
                  Semantics(
                    label: reciter.label,
                    selected: reciter == selected,
                    button: true,
                    child: SemanticButton(
                      label: reciter.label,
                      hint: _previewing == reciter ? l10n.stopPreviewHint : l10n.playPreviewHint,
                      onTap: () => _selectAndPreview(reciter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: reciter == selected ? context.colors.gold : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: reciter == selected ? context.colors.gold : context.colors.hairline,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _previewing == reciter ? Icons.stop_circle_outlined : Icons.play_circle_outline,
                              size: 16,
                              color: reciter == selected ? context.colors.paper : context.colors.sage,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              reciter.label,
                              style: TextStyle(
                                color: reciter == selected ? context.colors.paper : context.colors.ink,
                                fontSize: 13,
                                fontWeight: reciter == selected ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (selected.attribution != null) ...[
              const SizedBox(height: 10),
              Text(
                selected.attribution!,
                style: TextStyle(color: context.colors.sage, fontSize: 11),
              ),
            ],
          ],
        );
      },
    );
  }
}
