// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of LocationSelector to keep that file under the project's
// line-count convention. The raw lat/lng entry itself — kept, never
// deleted, just no longer front-and-center.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ManualCoordinatesEntry extends StatefulWidget {
  const ManualCoordinatesEntry({super.key, required this.onApply});

  final void Function(double latitude, double longitude) onApply;

  @override
  State<ManualCoordinatesEntry> createState() => _ManualCoordinatesEntryState();
}

class _ManualCoordinatesEntryState extends State<ManualCoordinatesEntry> {
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _apply() {
    final lat = double.tryParse(_latController.text);
    final lng = double.tryParse(_lngController.text);
    if (lat == null || lng == null) return;
    widget.onApply(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _field(context, _latController, l10n.latitudeLabel, true)),
            const SizedBox(width: 8),
            Expanded(child: _field(context, _lngController, l10n.longitudeLabel, false)),
          ],
        ),
        const SizedBox(height: 8),
        SemanticButton(
          label: l10n.applyManualLocationSemanticLabel,
          onTap: _apply,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              l10n.applyCoordinatesLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.ink),
            ),
          ),
        ),
      ],
    );
  }

  Widget _field(
    BuildContext context,
    TextEditingController controller,
    String label,
    bool isLat,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      textField: true,
      label: isLat ? l10n.manualLatitudeSemanticLabel : l10n.manualLongitudeSemanticLabel,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.ink),
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
