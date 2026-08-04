// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Every saved bookmark, one tap away from the Quran tab's app bar —
// bookmarks are stored locally (encrypted SQLite) and survive app
// restarts, so this list is always ready the next time the app opens.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/empty_state.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'surah_reader_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(l10n.bookmarksLabel)),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          if (state.bookmarks.isEmpty) {
            return EmptyState(
              icon: Icons.bookmark_border,
              message: l10n.noBookmarksMessage,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: state.bookmarks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final bookmark = state.bookmarks[index];
              final label = l10n.surahAyahLabel(
                bookmark.surahId,
                bookmark.ayahNumber,
              );
              return AppCard(
                padding: EdgeInsets.zero,
                child: SemanticButton(
                  label: label,
                  hint: l10n.openHint,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BlocProvider.value(
                        value: context.read<QuranCubit>(),
                        child: SurahReaderScreen(surahId: bookmark.surahId),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark, color: AppColors.emerald, size: 20),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            label,
                            style: const TextStyle(color: AppColors.ink),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
