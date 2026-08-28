// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Flutter's default LicensePage is unstyled Material and renders
// bright green under our theme. This replaces it with an ink-and-card
// screen grouped by package, matching the rest of the app.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'widgets/licence_package_tile.dart';
import '../../../core/constants/app_color_tokens.dart';

class _PackageLicence {
  const _PackageLicence({required this.name, required this.text});

  final String name;
  final String text;
}

class LicencesScreen extends StatefulWidget {
  const LicencesScreen({super.key});

  @override
  State<LicencesScreen> createState() => _LicencesScreenState();
}

class _LicencesScreenState extends State<LicencesScreen> {
  late final Future<List<_PackageLicence>> _future = _load();

  static Future<List<_PackageLicence>> _load() async {
    final byPackage = <String, List<String>>{};
    await for (final entry in LicenseRegistry.licenses) {
      final text = entry.paragraphs.map((p) => p.text).join('\n\n');
      for (final package in entry.packages) {
        byPackage.putIfAbsent(package, () => []).add(text);
      }
    }
    final list = [
      for (final e in byPackage.entries)
        _PackageLicence(name: e.key, text: e.value.join('\n\n')),
    ]..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.paper,
      appBar: AppBar(title: Text(l10n.openSourceLicencesLabel)),
      body: FutureBuilder<List<_PackageLicence>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: context.colors.gold),
            );
          }
          final packages = snapshot.data!;
          if (packages.isEmpty) {
            return Center(
              child: Text(
                l10n.noLicencesMessage,
                style: TextStyle(color: context.colors.sage),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              StaggeredFadeIn(
                children: [
                  for (final package in packages) ...[
                    LicencePackageTile(
                      packageName: package.name,
                      licenceText: package.text,
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
