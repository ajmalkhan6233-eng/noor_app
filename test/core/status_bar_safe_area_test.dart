// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// With a 48dp status bar (and edge-to-edge drawing), no screen title may
// sit under it, in any theme.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/presentation/widgets/collapsing_scaffold.dart';
import 'package:noor/core/presentation/widgets/glow_hero_title.dart';
import 'package:noor/features/qibla/logic/qibla_compass_state.dart';
import 'package:noor/features/qibla/presentation/qibla_compass_screen.dart';
import 'package:noor/features/settings/presentation/about_screen.dart';
import 'package:noor/features/settings/presentation/help_screen.dart';
import 'package:noor/features/settings/presentation/privacy_policy_screen.dart';
import 'package:noor/features/settings/presentation/support_developer_screen.dart';
import 'package:noor/features/zakat/presentation/zakat_screen.dart';

import '../helpers/theme_harness.dart';
import '../helpers/fixed_qibla_cubit.dart';

const _statusBar = 48.0;

Widget _underStatusBar(Widget child, ThemeData theme) {
  return themedApp(
    Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: _statusBar)),
        child: child,
      ),
    ),
    theme,
  );
}

void main() {
  final screens = <String, ({Widget Function() build, String title})>{
    'Help': (build: () => const HelpScreen(), title: 'Help & FAQ'),
    'About': (build: () => const AboutScreen(), title: 'About'),
    'Privacy': (build: () => const PrivacyPolicyScreen(), title: 'Privacy Policy'),
    'Support': (build: () => const SupportDeveloperScreen(), title: 'Support noor'),
    'Zakat': (build: () => const ZakatScreen(), title: 'Zakat calculator'),
    'Qibla': (
      build: () => QiblaCompassScreen(
        cubit: FixedQiblaCubit(const QiblaCompassState(loading: false, bearing: 119, distanceKm: 4800)),
      ),
      title: 'Qibla',
    ),
    'Prayer Times style (collapsing)': (
      build: () => const CollapsingScaffold(
        title: 'Prayer Times',
        largeTitle: GlowHeroTitle('Prayer Times', color: Colors.amber),
        slivers: [SliverToBoxAdapter(child: SizedBox(height: 900))],
      ),
      title: 'Prayer Times',
    ),
  };

  for (final theme in allThemes.entries) {
    for (final screen in screens.entries) {
      testWidgets('${screen.key} title clears the status bar in ${theme.key}', (tester) async {
        tester.view.physicalSize = const Size(360 * 3, 740 * 3);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(_underStatusBar(screen.value.build(), theme.value()));
        await tester.pump(const Duration(milliseconds: 300));

        final titles = find.text(screen.value.title);
        expect(titles, findsWidgets, reason: 'title text present');
        final top = tester.getTopLeft(titles.first).dy;
        expect(top, greaterThanOrEqualTo(_statusBar), reason: 'title at y=$top is under the status bar');
      });
    }
  }
}
