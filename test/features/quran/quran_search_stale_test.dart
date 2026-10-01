// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Typing must never lose or replace results: a slow search for an older
// keystroke must not overwrite the results for the current text.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/quran_ayah.dart';
import 'package:noor/features/quran/data/quran_repository.dart';
import 'package:noor/features/quran/logic/quran_cubit/quran_cubit.dart';

class _SlowFirstRepository extends QuranRepository {
  final List<String> queries = [];

  @override
  Future<List<QuranAyah>> search(String query) async {
    queries.add(query);
    if (query == 'a') await Future<void>.delayed(const Duration(milliseconds: 80));
    return [QuranAyah(surahId: 1, ayahNumber: 1, arabicText: 'result for $query')];
  }
}

void main() {
  test('a slow older search cannot overwrite the newest results', () async {
    final repo = _SlowFirstRepository();
    final cubit = QuranCubit(repository: repo, searchDebounce: Duration.zero);

    final first = cubit.search('a');
    final second = cubit.search('ab');
    await Future.wait([first, second]);

    expect(cubit.state.searchQuery, 'ab');
    expect(cubit.state.searchResults.single.arabicText, 'result for ab');
    await cubit.close();
  });

  test('keystrokes inside the debounce window run one search', () async {
    final repo = _SlowFirstRepository();
    final cubit = QuranCubit(repository: repo, searchDebounce: const Duration(milliseconds: 40));

    final calls = [cubit.search('b'), cubit.search('ba'), cubit.search('bab')];
    await Future.wait(calls);

    expect(repo.queries, ['bab']);
    expect(cubit.state.searchResults.single.arabicText, 'result for bab');
    await cubit.close();
  });

  test('clearing the box clears results at once without searching', () async {
    final repo = _SlowFirstRepository();
    final cubit = QuranCubit(repository: repo, searchDebounce: Duration.zero);
    await cubit.search('ab');
    await cubit.search('');

    expect(cubit.state.searchResults, isEmpty);
    expect(repo.queries, ['ab']);
    await cubit.close();
  });
}
