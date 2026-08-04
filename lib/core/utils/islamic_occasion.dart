// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Fixed-date Islamic occasions by Hijri month/day — calendar facts,
// not interpretive content. Ramadan is the whole of month 9; the two
// Eids, Ashura, and the White Days are specific days.

import 'hijri_date.dart';

enum IslamicOccasion { ramadan, eidAlFitr, eidAlAdha, ashura, whiteDays }

extension IslamicOccasionLabel on IslamicOccasion {
  String get label {
    switch (this) {
      case IslamicOccasion.ramadan:
        return 'Ramadan';
      case IslamicOccasion.eidAlFitr:
        return 'Eid al-Fitr';
      case IslamicOccasion.eidAlAdha:
        return 'Eid al-Adha';
      case IslamicOccasion.ashura:
        return 'Ashura';
      case IslamicOccasion.whiteDays:
        return 'White Days';
    }
  }
}

/// Returns every occasion that falls on [date], if any (a day can be
/// both, e.g. White Days never coincide with the others so this is
/// usually zero or one, but the type stays a list for safety).
List<IslamicOccasion> occasionsOn(HijriDate date) {
  final occasions = <IslamicOccasion>[];
  if (date.month == 9) occasions.add(IslamicOccasion.ramadan);
  if (date.month == 10 && date.day == 1) occasions.add(IslamicOccasion.eidAlFitr);
  if (date.month == 12 && date.day == 10) occasions.add(IslamicOccasion.eidAlAdha);
  if (date.month == 1 && date.day == 10) occasions.add(IslamicOccasion.ashura);
  if (date.day >= 13 && date.day <= 15) occasions.add(IslamicOccasion.whiteDays);
  return occasions;
}
