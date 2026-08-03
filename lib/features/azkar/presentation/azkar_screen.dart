// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../data/azkar_category.dart';
import '../logic/azkar_cubit/azkar_cubit.dart';
import '../logic/azkar_cubit/azkar_state.dart';
import 'widgets/azkar_category_selector.dart';
import 'widgets/azkar_empty_state.dart';
import 'widgets/azkar_item_tile.dart';

/// Azkar: category selector plus a repetition-counted list of dhikr,
/// or a clear empty state for categories with no text loaded yet.
class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarCubit()..selectCategory(AzkarCategory.values.first),
      child: const _AzkarView(),
    );
  }
}

class _AzkarView extends StatelessWidget {
  const _AzkarView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const AzkarCategorySelector(),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AzkarCubit, AzkarState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  }
                  if (state.items.isEmpty) {
                    return const AzkarEmptyState();
                  }
                  return ListView(
                    children: [
                      for (final item in state.items)
                        AzkarItemTile(item: item),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
