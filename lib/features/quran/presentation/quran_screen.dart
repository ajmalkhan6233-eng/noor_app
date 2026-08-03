// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'surah_reader_screen.dart';
import 'widgets/quran_import_notice.dart';
import 'widgets/quran_search_bar.dart';
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
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
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
        const QuranSearchBar(),
        const SizedBox(height: 12),
        if (state.lastRead != null)
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
                style: const TextStyle(color: AppColors.accent),
              ),
            ),
          ),
        Expanded(
          child: ListView(
            children: [
              for (final surah in (state.searchQuery.isEmpty
                  ? state.surahs
                  : const []))
                SurahListTile(surah: surah, onTap: () => _open(context, surah.id)),
              if (state.searchQuery.isNotEmpty)
                for (final ayah in state.searchResults)
                  Semantics(
                    label:
                        'Search result: Surah ${ayah.surahId}, '
                        'Ayah ${ayah.ayahNumber}',
                    button: true,
                    child: ListTile(
                      onTap: () => _open(context, ayah.surahId),
                      title: Text(
                        ayah.arabicText,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        'Surah ${ayah.surahId}, Ayah ${ayah.ayahNumber}',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
