// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../data/quran_import_status.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'surah_reader_screen.dart';
import 'widgets/quran_import_notice.dart';
import 'widgets/quran_search_bar.dart';
import 'widgets/quran_search_result_tile.dart';
import 'widgets/surah_list_tile.dart';

/// Quran: surah index and search, or a clear notice when the feature
/// is disabled (no verified source text on this device).
class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuranCubit()..init(),
      child: const _QuranView(),
    );
  }
}

class _QuranView extends StatelessWidget {
  const _QuranView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state.importStatus is QuranImporting) {
              return QuranImportNotice(status: state.importStatus!);
            }
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.emerald),
              );
            }
            if (!state.isImported) {
              return QuranImportNotice(status: state.importStatus!);
            }
            return _SurahIndex(state: state);
          },
        ),
      ),
    );
  }
}

class _SurahIndex extends StatelessWidget {
  const _SurahIndex({required this.state});

  final QuranState state;

  void _open(BuildContext context, int surahId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<QuranCubit>(),
          child: SurahReaderScreen(surahId: surahId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          child: Column(
            children: [
              const QuranSearchBar(),
              if (state.lastRead != null) ...[
                const SizedBox(height: 8),
                Semantics(
                  label:
                      'Continue reading: Surah ${state.lastRead!.surahId}, '
                      'Ayah ${state.lastRead!.ayahNumber}',
                  button: true,
                  child: TextButton(
                    onPressed: () => _open(context, state.lastRead!.surahId),
                    child: Text(
                      'Continue: Surah ${state.lastRead!.surahId}, '
                      'Ayah ${state.lastRead!.ayahNumber}',
                      style: const TextStyle(color: AppColors.emerald),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              StaggeredFadeIn(
                children: [
                  for (final surah in (state.searchQuery.isEmpty
                      ? state.surahs
                      : const []))
                    SurahListTile(
                      surah: surah,
                      onTap: () => _open(context, surah.id),
                    ),
                  if (state.searchQuery.isNotEmpty)
                    for (final ayah in state.searchResults)
                      QuranSearchResultTile(
                        ayah: ayah,
                        onTap: () => _open(context, ayah.surahId),
                      ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
