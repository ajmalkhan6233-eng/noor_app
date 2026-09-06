// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'azkar_category_screen.dart';
import '../data/azkar_category.dart';
import '../data/azkar_item.dart';
import '../data/azkar_repository.dart';
import '../logic/azkar_cubit/azkar_cubit.dart';
import 'widgets/azkar_bookmarks_button.dart';
import 'widgets/azkar_category_selector.dart';
import 'widgets/azkar_header.dart';
import '../../../core/constants/app_color_tokens.dart';

/// Azkar: a search box, then a list of category rows (morning,
/// evening, after prayer, sleep, travel) — tap one to open its dhikr
/// list, or type to jump straight to a matching dua by name (e.g.
/// "sleep") without knowing which category it's filed under
/// (2026-08-24 live-device review). Restructured from a horizontal
/// chip selector + single flat list — see AzkarCategoryScreen for
/// what opens on tap.
class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key, AzkarRepository? repository})
    : _repository = repository;

  final AzkarRepository? _repository;

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  late final AzkarRepository _repository = widget._repository ?? AzkarRepository();
  final _searchScrollController = ScrollController();
  String _query = '';
  List<(AzkarCategory category, AzkarItem item)> _results = const [];

  @override
  void dispose() {
    _searchScrollController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    setState(() => _query = query);
    final results = query.trim().isEmpty ? const <(AzkarCategory, AzkarItem)>[] : await _repository.searchItems(query);
    if (mounted) setState(() => _results = results);
  }

  void _openCategory(AzkarCategory category) {
    final cubit = context.read<AzkarCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: AzkarCategoryScreen(category: category),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarCubit()..init(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // No title here — AzkarHeader below is the large, centered
          // "alive" title now (master directive item 8). Keeping this
          // AppBar only for the back button and bookmarks action.
          backgroundColor: context.colors.paper,
          actions: const [AzkarBookmarksButton()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StaggeredFadeIn(
                children: [
                  AzkarHeader(title: AppLocalizations.of(context)!.azkarScreenTitle),
                  AppCard(
                    child: TextField(
                      style: TextStyle(color: context.colors.ink),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: context.colors.sage),
                        hintText: 'Search duas, e.g. "sleep"',
                        hintMaxLines: 1,
                        hintStyle: TextStyle(
                          color: context.colors.ink.withValues(alpha: 0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: _search,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _query.trim().isEmpty
                    ? const AzkarCategorySelector()
                    : _searchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchResults() {
    if (_results.isEmpty) {
      return Center(
        child: Text('No matching duas found.', style: TextStyle(color: context.colors.sage)),
      );
    }
    return ListView.separated(
      controller: _searchScrollController,
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final (category, item) = _results[index];
        final resultLabel = item.transliteration ?? item.translation ?? '';
        // Plain AppCard, not wrapped in a scroll-linked parallax effect
        // (2026-09-05 fix): that wrapper rebuilt this whole subtree on
        // every ScrollController notification from the very list it
        // sat inside, which was swallowing taps on these rows entirely
        // — "not clickable" direct report. No other tappable list row
        // in the app uses this decorative wrapper; not worth the risk
        // here either.
        return AppCard(
          padding: EdgeInsets.zero,
          child: Semantics(
            button: true,
            label: '${category.label}: $resultLabel',
            hint: 'Double tap to open this dua',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _openCategory(category),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.label, style: TextStyle(color: context.colors.gold, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(
                        resultLabel,
                        style: TextStyle(color: context.colors.ink),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
