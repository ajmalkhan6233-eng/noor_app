// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../data/quran_import_status.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'bookmarks_screen.dart';
import 'widgets/quran_import_notice.dart';
import 'widgets/surah_index.dart';
import '../../../core/constants/app_color_tokens.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: context.colors.paper,
        title: Text(l10n.quranScreenTitle),
        actions: [
          Semantics(
            label: l10n.bookmarksLabel,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.bookmark_outline),
              tooltip: l10n.bookmarksLabel,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider.value(
                    value: context.read<QuranCubit>(),
                    child: const BookmarksScreen(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state.importStatus is QuranImporting) {
              return QuranImportNotice(status: state.importStatus!);
            }
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: context.colors.gold),
              );
            }
            if (!state.isImported) {
              return QuranImportNotice(status: state.importStatus!);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SurahIndex(state: state)),
              ],
            );
          },
        ),
      ),
    );
  }
}
