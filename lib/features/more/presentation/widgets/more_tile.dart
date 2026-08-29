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
  });

  final NoorIconType icon;
  final Color color;
  final String label;
  final WidgetBuilder builder;
  final VoidCallback? onClosed;

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: label,
      hint: AppLocalizations.of(context)!.openHint,
      onTap: () async {
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
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: NoorIcon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colors.ink, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
