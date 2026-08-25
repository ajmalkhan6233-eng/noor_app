// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'azkar_category_screen.dart';
import '../data/azkar_category.dart';
import '../data/azkar_item.dart';
import '../data/azkar_repository.dart';
import '../logic/azkar_cubit/azkar_cubit.dart';
import 'widgets/azkar_category_selector.dart';

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
  String _query = '';
  List<(AzkarCategory category, AzkarItem item)> _results = const [];

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
          backgroundColor: AppColors.paper,
          title: Text(AppLocalizations.of(context)!.azkarScreenTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: TextField(
                  style: const TextStyle(color: AppColors.ink),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: AppColors.sage),
                    hintText: 'Search duas — e.g. "sleep", "travel"',
                    hintStyle: TextStyle(color: AppColors.sage),
                    border: InputBorder.none,
                  ),
                  onChanged: _search,
                ),
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
      return const Center(
        child: Text('No matching duas found.', style: TextStyle(color: AppColors.sage)),
      );
    }
    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final (category, item) = _results[index];
        final resultLabel = item.transliteration ?? item.translation ?? '';
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
                      Text(category.label, style: const TextStyle(color: AppColors.gold, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(
                        resultLabel,
                        style: const TextStyle(color: AppColors.ink),
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
