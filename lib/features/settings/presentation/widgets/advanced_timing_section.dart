// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Manual per-prayer adjustment minutes and iqamath offsets — ten
// individual +/- steppers between them — collapsed behind one
// disclosure row by default. These are genuine precision controls
// (not clutter to delete), but most people never touch them; folding
// both sections behind "Advanced timing" instead of showing all ten
// rows on first open matches the Athan-app-style simplicity asked for
// (2026-08-24 live-device review) without losing the precision.

import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';
import 'iqamath_offset_section.dart';
import 'prayer_adjustments_section.dart';
import '../../../../core/constants/app_color_tokens.dart';

class AdvancedTimingSection extends StatefulWidget {
  const AdvancedTimingSection({super.key});

  @override
  State<AdvancedTimingSection> createState() => _AdvancedTimingSectionState();
}

class _AdvancedTimingSectionState extends State<AdvancedTimingSection> {
  // Defaulted open (2026-08-25, explicitly asked for twice: "plus or
  // minus option" for both iqamah and azan times) — collapsed-by-
  // default was hiding a feature that was actually already built, not
  // reducing clutter for someone actively looking for it.
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SemanticButton(
          label: 'Advanced timing',
          hint: _expanded ? 'Double tap to collapse' : 'Double tap to expand',
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Expanded(child: Text('Advanced timing', style: TextStyle(color: context.colors.ink))),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: context.colors.sage,
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 12),
          const SectionHeader('Manual adjustments'),
          const SizedBox(height: 4),
          const PrayerAdjustmentsSection(),
          const SizedBox(height: 16),
          const SectionHeader('Iqamath offsets'),
          const SizedBox(height: 4),
          const IqamathOffsetSection(),
        ],
      ],
    );
  }
}
