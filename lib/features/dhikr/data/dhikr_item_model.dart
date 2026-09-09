import 'package:flutter/foundation.dart';

@immutable
class DhikrItemModel {
  final String id;
  final String title;
  final String arabicText;
  final String transliteration;
  final String translation;
  final int targetCount;
  final String category;

  const DhikrItemModel({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.targetCount,
    required this.category,
  });

  static const List<DhikrItemModel> defaultPresets = [
    DhikrItemModel(
      id: 'istighfar_general',
      title: 'General Istighfar',
      arabicText: 'أَسْتَغْفِرُ اللّٰهَ',
      transliteration: 'Astaghfirullah',
      translation: 'I seek forgiveness from Allah',
      targetCount: 100,
      category: 'Istighfar',
    ),
    DhikrItemModel(
      id: 'istighfar_yunus',
      title: 'Dua of Prophet Yunus (AS)',
      arabicText: 'لَّا إِلٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ',
      transliteration: 'La ilaha illa anta subhanaka inni kuntu minaz-zalimin',
      translation: 'There is no deity except You; exalted are You; indeed, I have been of the wrongdoers.',
      targetCount: 100,
      category: 'Istighfar',
    ),
  ];
}