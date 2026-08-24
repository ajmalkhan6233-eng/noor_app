// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One category's dhikr list, opened from AzkarScreen's category row
// (2026-08-24 live-device review: restructured from one flat list
// with a horizontal chip selector into categorized rows you tap into,
// matching the reference app's pattern).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../data/azkar_category.dart';
import '../data/azkar_import_status.dart';
import '../logic/azkar_cubit/azkar_cubit.dart';
import '../logic/azkar_cubit/azkar_state.dart';
import 'widgets/azkar_empty_state.dart';
import 'widgets/azkar_item_tile.dart';

class AzkarCategoryScreen extends StatefulWidget {
  const AzkarCategoryScreen({super.key, required this.category});

  final AzkarCategory category;

  @override
  State<AzkarCategoryScreen> createState() => _AzkarCategoryScreenState();
}

class _AzkarCategoryScreenState extends State<AzkarCategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AzkarCubit>().selectCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        elevation: 0,
        title: Text(widget.category.label),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<AzkarCubit, AzkarState>(
          builder: (context, state) {
            if (state.category != widget.category || state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              );
            }
            if (state.items.isEmpty) {
              return AzkarEmptyState(
                verificationFailed: state.importStatus is AzkarVerificationFailed,
              );
            }
            return ListView(
              children: [
                StaggeredFadeIn(
                  children: [
                    for (final item in state.items) AzkarItemTile(item: item),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
