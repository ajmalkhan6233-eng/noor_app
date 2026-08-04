// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/app_chip.dart';
import '../../data/azkar_category.dart';
import '../../logic/azkar_cubit/azkar_cubit.dart';
import '../../logic/azkar_cubit/azkar_state.dart';

/// Horizontally-scrollable chip row across the five azkar categories.
class AzkarCategorySelector extends StatelessWidget {
  const AzkarCategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarCubit, AzkarState>(
      builder: (context, state) {
        return SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final category in AzkarCategory.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AppChip(
                    label: category.label,
                    semanticLabel: '${category.label} azkar',
                    selected: state.category == category,
                    onTap: () =>
                        context.read<AzkarCubit>().selectCategory(category),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
