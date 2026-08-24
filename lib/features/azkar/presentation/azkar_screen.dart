// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/parallax_layer.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/azkar_import_status.dart';
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
      create: (_) => AzkarCubit()..init(),
      child: const _AzkarView(),
    );
  }
}

class _AzkarView extends StatefulWidget {
  const _AzkarView();

  @override
  State<_AzkarView> createState() => _AzkarViewState();
}

class _AzkarViewState extends State<_AzkarView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.azkarScreenTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ParallaxLayer(
              controller: _scrollController,
              child: const AzkarCategorySelector(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AzkarCubit, AzkarState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    );
                  }
                  if (state.items.isEmpty) {
                    return AzkarEmptyState(
                      verificationFailed:
                          state.importStatus is AzkarVerificationFailed,
                    );
                  }
                  return ListView(
                    controller: _scrollController,
                    children: [
                      StaggeredFadeIn(
                        children: [
                          for (final item in state.items)
                            AzkarItemTile(item: item),
                        ],
                      ),
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
