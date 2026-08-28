// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Every bookmarked dua, one tap away from the Duas & Dhikr tab's app
// bar — direct request (2026-08-26): "so they can have their own set
// of dua every day". Shows the full AzkarItemTile (Arabic,
// transliteration, translation, counter), not just a label, since the
// point is to actually read/recite them here, not just navigate away.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/empty_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../settings/logic/settings_cubit/settings_state.dart';
import '../logic/azkar_cubit/azkar_cubit.dart';
import '../logic/azkar_cubit/azkar_state.dart';
import 'widgets/azkar_item_tile.dart';
import '../../../core/constants/app_color_tokens.dart';

class AzkarBookmarksScreen extends StatefulWidget {
  const AzkarBookmarksScreen({super.key});

  @override
  State<AzkarBookmarksScreen> createState() => _AzkarBookmarksScreenState();
}

class _AzkarBookmarksScreenState extends State<AzkarBookmarksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AzkarCubit>().loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => SettingsCubit()..load(),
      child: Scaffold(
        backgroundColor: context.colors.paper,
        appBar: AppBar(title: Text(l10n.bookmarksLabel)),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<AzkarCubit, AzkarState>(
            builder: (context, state) {
              if (state.bookmarkedItems.isEmpty) {
                return EmptyState(
                  icon: Icons.bookmark_border,
                  message: l10n.noAzkarBookmarksMessage,
                );
              }
              return BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
                  final fontScale = settingsState.settings.arabicFontScale;
                  return ListView(
                    children: [
                      StaggeredFadeIn(
                        children: [
                          for (final item in state.bookmarkedItems)
                            AzkarItemTile(item: item, fontScale: fontScale),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
