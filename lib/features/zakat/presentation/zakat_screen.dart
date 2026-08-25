// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Full Zakat al-Mal calculator: gold, silver, cash, receivables,
// business inventory, minus liabilities. Nisab is priced from
// user-entered gold/silver prices — this offline app never fetches a
// market price. All maths is pure and unit-tested — see
// zakat_calculator.dart.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/zakat_calculator.dart';
import '../data/zakat_price_memory.dart';
import 'widgets/zakat_number_field.dart';
import 'widgets/zakat_result_card.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  var _inputs = const ZakatInputs();
  final _priceMemory = ZakatPriceMemory();

  @override
  void initState() {
    super.initState();
    _priceMemory.loadGoldPrice().then((price) {
      if (price != null && mounted) {
        setState(() => _inputs = _inputs.copyWith(goldPricePerGram: price));
      }
    });
    _priceMemory.loadSilverPrice().then((price) {
      if (price != null && mounted) {
        setState(() => _inputs = _inputs.copyWith(silverPricePerGram: price));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = ZakatCalculator.calculate(_inputs);
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(l10n.zakatCalculatorLabel)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.goldSilverHeader, style: AppTypography.caption),
                const SizedBox(height: 8),
                ZakatNumberField(
                  label: l10n.goldGramsLabel,
                  onChanged: (v) => setState(
                    () => _inputs = _inputs.copyWith(goldGrams: v),
                  ),
                ),
                ZakatNumberField(
                  label: l10n.goldPriceLabel,
                  initialValue: _inputs.goldPricePerGram == 0
                      ? null
                      : _inputs.goldPricePerGram,
                  onChanged: (v) {
                    setState(() => _inputs = _inputs.copyWith(goldPricePerGram: v));
                    _priceMemory.saveGoldPrice(v);
                  },
                ),
                ZakatNumberField(
                  label: l10n.silverGramsLabel,
                  onChanged: (v) => setState(
                    () => _inputs = _inputs.copyWith(silverGrams: v),
                  ),
                ),
                ZakatNumberField(
                  label: l10n.silverPriceLabel,
                  initialValue: _inputs.silverPricePerGram == 0
                      ? null
                      : _inputs.silverPricePerGram,
                  onChanged: (v) {
                    setState(() => _inputs = _inputs.copyWith(silverPricePerGram: v));
                    _priceMemory.saveSilverPrice(v);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.otherAssetsHeader, style: AppTypography.caption),
                const SizedBox(height: 8),
                ZakatNumberField(
                  label: l10n.cashSavingsLabel,
                  onChanged: (v) =>
                      setState(() => _inputs = _inputs.copyWith(cash: v)),
                ),
                ZakatNumberField(
                  label: l10n.receivablesLabel,
                  onChanged: (v) => setState(
                    () => _inputs = _inputs.copyWith(receivables: v),
                  ),
                ),
                ZakatNumberField(
                  label: l10n.businessInventoryLabel,
                  onChanged: (v) => setState(
                    () =>
                        _inputs = _inputs.copyWith(businessInventoryValue: v),
                  ),
                ),
                ZakatNumberField(
                  label: l10n.liabilitiesLabel,
                  onChanged: (v) => setState(
                    () => _inputs = _inputs.copyWith(liabilities: v),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ZakatResultCard(result: result),
        ],
      ),
    );
  }
}
