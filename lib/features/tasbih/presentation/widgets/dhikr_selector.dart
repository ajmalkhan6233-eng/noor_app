// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A compact dropdown to switch the active dhikr — deliberately not a
// long list rendered on screen at once.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
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
          child: DropdownButton<String>(
            value: state.dhikrLabel,
            underline: const SizedBox.shrink(),
            dropdownColor: AppColors.card,
            style: const TextStyle(color: AppColors.ink),
            items: [
              for (final option in DhikrOption.values)
                DropdownMenuItem(value: option.label, child: Text(option.label)),
              if (!DhikrOption.values.any((o) => o.label == state.dhikrLabel))
                DropdownMenuItem(
                  value: state.dhikrLabel,
                  child: Text(state.dhikrLabel),
                ),
            ],
            onChanged: (label) {
              if (label != null) {
                context.read<TasbihCubit>().selectDhikr(label);
              }
            },
          ),
        );
      },
    );
  }
}
