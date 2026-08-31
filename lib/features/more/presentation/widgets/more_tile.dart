// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of more_screen.dart to stay under the 150-line-per-file
// rule. One colored icon tile in the More screen's grid.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/presentation/icons/noor_icon.dart';
import '../../../../core/presentation/icons/noor_icon_type.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

class MoreTile extends StatelessWidget {
  const MoreTile({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.builder,
    this.onClosed,
    this.comingSoon = false,
  });

  final NoorIconType icon;
  final Color color;
  final String label;
  final WidgetBuilder builder;
  final VoidCallback? onClosed;

  /// Keeps the tile's slot in the grid without making the feature
  /// reachable — used to temporarily pull a screen out of the app
  /// without deleting its code or reflowing everything else around it
  /// (2026-08-31, Qibla, pending another look at its live rendering
  /// glitch). Tapping shows a plain explanation instead of navigating.
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    final tileColor = comingSoon ? context.colors.sage : color;
    return SemanticButton(
      label: comingSoon ? '$label — coming soon' : label,
      hint: comingSoon
          ? AppLocalizations.of(context)!.comingSoonHint
          : AppLocalizations.of(context)!.openHint,
      onTap: comingSoon
          ? () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.comingSoonMessage(label))),
              )
          : () async {
              await Navigator.of(context).push(MaterialPageRoute<void>(builder: builder));
              onClosed?.call();
            },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tileColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: NoorIcon(icon, color: tileColor, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: comingSoon ? context.colors.sage : context.colors.ink, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
