// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Selectable Adhan sound — see adhan_reciter.dart. Shows the required
// attribution line for the active selection directly beneath the
// picker (the licence condition for four of the five options, not
// optional copy) rather than only in About, since this is the screen
// where the choice is actually made.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../prayer_times/data/adhan_reciter.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

class AdhanSoundSection extends StatelessWidget {
  const AdhanSoundSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                      onTap: () =>
                          context.read<SettingsCubit>().setAdhanReciter(reciter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: reciter == selected ? context.colors.gold : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: reciter == selected ? context.colors.gold : context.colors.hairline,
                          ),
                        ),
                        child: Text(
                          reciter.label,
                          style: TextStyle(
                            color: reciter == selected ? context.colors.paper : context.colors.ink,
                            fontSize: 13,
                            fontWeight: reciter == selected ? FontWeight.w700 : FontWeight.w400,
                          ),
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
