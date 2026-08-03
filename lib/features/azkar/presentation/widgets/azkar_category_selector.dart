// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
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
                  child: Semantics(
                    label: '${category.label} azkar',
                    selected: state.category == category,
                    child: ChoiceChip(
                      label: Text(category.label),
                      selected: state.category == category,
                      selectedColor: AppColors.accent,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: state.category == category
                            ? AppColors.background
                            : AppColors.textPrimary,
                      ),
                      onSelected: (_) =>
                          context.read<AzkarCubit>().selectCategory(category),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
