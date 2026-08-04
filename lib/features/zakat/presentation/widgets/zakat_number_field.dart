// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class ZakatNumberField extends StatelessWidget {
  const ZakatNumberField({
    super.key,
    required this.label,
    required this.onChanged,
  });

  final String label;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        textField: true,
        label: label,
        child: TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: AppColors.ink),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppTypography.caption,
          ),
          onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
        ),
      ),
    );
  }
}
