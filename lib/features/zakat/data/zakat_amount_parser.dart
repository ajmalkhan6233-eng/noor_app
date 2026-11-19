// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Turns what a person types into a Zakat field into a number. Before
// this, "150,000" (the usual way to write amounts in Sri Lanka) failed
// double.tryParse and silently became 0, and "-500" was accepted as a
// negative asset. Pure, so it is unit-tested directly.

/// Parses a typed amount. Commas, spaces and a leading "Rs"/"LKR" are
/// ignored. Anything unreadable, negative or not finite becomes 0.
double parseZakatAmount(String raw) {
  var text = raw.trim().toLowerCase();
  for (final prefix in ['lkr', 'rs.', 'rs']) {
    if (text.startsWith(prefix)) {
      text = text.substring(prefix.length);
      break;
    }
  }
  text = text.replaceAll(',', '').replaceAll(' ', '');
  final value = double.tryParse(text);
  if (value == null || !value.isFinite || value < 0) return 0;
  return value;
}
