// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A horizontal row of dhikr chips, scrollable if the list outgrows
// the screen width. Previously a Material DropdownButton — its open
// menu is a full-screen overlay route with no awareness of the
// draggable counter orb beneath it, so it could render directly on
// top of the orb wherever it had been dragged to (live-device report,
// 2026-09-06). Inline chips lay out in normal flow instead, so there
// is nothing left for anything else to overlap.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/dhikr_option.dart';
import '../../logic/tasbih_cubit/tasbih_cubit.dart';
import '../../logic/tasbih_cubit/tasbih_state.dart';

class DhikrSelector extends StatelessWidget {
  const DhikrSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbihCubit, TasbihState>(
      builder: (context, state) {
        return Semantics(
          label: AppLocalizations.of(context)!.dhikrSelectorSemanticLabel,
          value: state.dhikrLabel,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final option in DhikrOption.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _DhikrChip(
                      label: option.label,
                      selected: state.dhikrLabel == option.label,
                      onTap: () => context.read<TasbihCubit>().selectDhikr(option.label),
                    ),
                  ),
                if (!DhikrOption.values.any((o) => o.label == state.dhikrLabel))
                  _DhikrChip(label: state.dhikrLabel, selected: true, onTap: () {}),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DhikrChip extends StatelessWidget {
  const _DhikrChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SemanticButton(
      label: label,
      hint: selected ? l10n.currentlyCountingLabel(label) : l10n.selectDhikrHint(label),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? context.colors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? context.colors.gold : context.colors.hairline),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? context.colors.gold : context.colors.ink,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
