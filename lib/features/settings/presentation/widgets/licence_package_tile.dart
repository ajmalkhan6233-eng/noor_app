// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One package's licence text, collapsed by default. Tap to expand —
// no Material ExpansionTile (it drags in default M3 tinting); a plain
// AnimatedSize keeps this on our own palette.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';

class LicencePackageTile extends StatefulWidget {
  const LicencePackageTile({
    super.key,
    required this.packageName,
    required this.licenceText,
  });

  final String packageName;
  final String licenceText;

  @override
  State<LicencePackageTile> createState() => _LicencePackageTileState();
}

class _LicencePackageTileState extends State<LicencePackageTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${widget.packageName} licence',
      hint: _expanded ? 'Double tap to collapse' : 'Double tap to expand',
      child: AppCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.packageName,
                        style: const TextStyle(color: AppColors.parchment),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.sage,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: _expanded
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            widget.licenceText,
                            style: AppTypography.caption.copyWith(height: 1.5),
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
