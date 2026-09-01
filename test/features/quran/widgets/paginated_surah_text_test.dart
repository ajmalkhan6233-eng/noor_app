// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/quran_ayah.dart';
import 'package:noor/features/quran/presentation/widgets/paginated_surah_text.dart';

const _ayahs = [
  QuranAyah(surahId: 112, ayahNumber: 1, arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ'),
  QuranAyah(surahId: 112, ayahNumber: 2, arabicText: 'اللَّهُ الصَّمَدُ'),
  QuranAyah(surahId: 112, ayahNumber: 3, arabicText: 'لَمْ يَلِدْ وَلَمْ يُولَدْ'),
  QuranAyah(surahId: 112, ayahNumber: 4, arabicText: 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ'),
];

void main() {
  final keys = <int, GlobalKey>{};
  GlobalKey keyFor(int ayahNumber) => keys.putIfAbsent(ayahNumber, GlobalKey.new);

  testWidgets('renders inside a PageView without error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaginatedSurahText(
            ayahs: _ayahs,
            fontScale: 1.0,
            bookmarkedAyahNumbers: const {},
            onToggleBookmark: (_) {},
            ayahKeyFor: keyFor,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(PageView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a swipe moves to the next page without throwing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaginatedSurahText(
            ayahs: List.generate(60, (i) => QuranAyah(surahId: 2, ayahNumber: i + 1, arabicText: 'نَص آية ${i + 1}' * 10)),
            fontScale: 1.0,
            bookmarkedAyahNumbers: const {},
            onToggleBookmark: (_) {},
            ayahKeyFor: keyFor,
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
