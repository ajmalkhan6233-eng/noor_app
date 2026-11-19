// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure Zakat al-Mal maths — no I/O, no widgets, fully unit-testable.
// Nisab (the minimum-wealth threshold) is the value of 87.48g of gold
// or 612.36g of silver; this app is offline, so the user supplies
// today's per-gram prices themselves rather than the app guessing or
// fetching them. Per majority contemporary fiqh council guidance, the
// LOWER of the two nisab values is used for mixed/cash wealth — that
// includes more people under the obligation, not fewer.

/// Which metal sets the nisab threshold. Scholars differ; the person
/// chooses (2026-11-19). `lowest` (default) is the majority contemporary
/// position for cash and mixed wealth and includes more people under the
/// obligation; `gold` / `silver` use that metal alone.
enum NisabBasis { lowest, gold, silver }

class ZakatInputs {
  const ZakatInputs({
    this.goldGrams = 0,
    this.goldPricePerGram = 0,
    this.silverGrams = 0,
    this.silverPricePerGram = 0,
    this.cash = 0,
    this.receivables = 0,
    this.businessInventoryValue = 0,
    this.liabilities = 0,
    this.nisabBasis = NisabBasis.lowest,
  });

  final double goldGrams;
  final double goldPricePerGram;
  final double silverGrams;
  final double silverPricePerGram;
  final double cash;
  final double receivables;
  final double businessInventoryValue;
  final double liabilities;
  final NisabBasis nisabBasis;

  double get goldValue => goldGrams * goldPricePerGram;
  double get silverValue => silverGrams * silverPricePerGram;

  double get netWealth =>
      goldValue +
      silverValue +
      cash +
      receivables +
      businessInventoryValue -
      liabilities;

  ZakatInputs copyWith({
    double? goldGrams,
    double? goldPricePerGram,
    double? silverGrams,
    double? silverPricePerGram,
    double? cash,
    double? receivables,
    double? businessInventoryValue,
    double? liabilities,
    NisabBasis? nisabBasis,
  }) {
    return ZakatInputs(
      goldGrams: goldGrams ?? this.goldGrams,
      goldPricePerGram: goldPricePerGram ?? this.goldPricePerGram,
      silverGrams: silverGrams ?? this.silverGrams,
      silverPricePerGram: silverPricePerGram ?? this.silverPricePerGram,
      cash: cash ?? this.cash,
      receivables: receivables ?? this.receivables,
      businessInventoryValue:
          businessInventoryValue ?? this.businessInventoryValue,
      liabilities: liabilities ?? this.liabilities,
      nisabBasis: nisabBasis ?? this.nisabBasis,
    );
  }
}

class ZakatResult {
  const ZakatResult({
    required this.netWealth,
    required this.nisabThreshold,
    required this.nisabMet,
    required this.zakatDue,
    this.missingGoldPrice = false,
    this.missingSilverPrice = false,
  });

  final double netWealth;
  final double nisabThreshold;
  final bool nisabMet;
  final double zakatDue;

  /// Gold/silver grams were entered without that metal's price, so they
  /// are counted as 0 until a price is entered. Shown as a heads-up.
  final bool missingGoldPrice;
  final bool missingSilverPrice;
}

abstract final class ZakatCalculator {
  static const double nisabGoldGrams = 87.48;
  static const double nisabSilverGrams = 612.36;
  static const double rate = 0.025;

  static ZakatResult calculate(ZakatInputs inputs) {
    final nisabByGold = nisabGoldGrams * inputs.goldPricePerGram;
    final nisabBySilver = nisabSilverGrams * inputs.silverPricePerGram;

    // If a price wasn't entered (0), that metal can't set the floor —
    // fall back to whichever metal's nisab is actually prices-in.
    final useGold = inputs.nisabBasis != NisabBasis.silver;
    final useSilver = inputs.nisabBasis != NisabBasis.gold;
    final candidates = [
      if (useGold && inputs.goldPricePerGram > 0) nisabByGold,
      if (useSilver && inputs.silverPricePerGram > 0) nisabBySilver,
    ];
    final nisabThreshold = candidates.isEmpty
        ? 0.0
        : candidates.reduce((a, b) => a < b ? a : b);

    final netWealth = inputs.netWealth;
    final nisabMet = nisabThreshold > 0 && netWealth >= nisabThreshold;

    return ZakatResult(
      netWealth: netWealth,
      nisabThreshold: nisabThreshold,
      nisabMet: nisabMet,
      zakatDue: nisabMet ? netWealth * rate : 0,
      missingGoldPrice: inputs.goldGrams > 0 && inputs.goldPricePerGram <= 0,
      missingSilverPrice: inputs.silverGrams > 0 && inputs.silverPricePerGram <= 0,
    );
  }
}
