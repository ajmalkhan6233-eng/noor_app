// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The single, unmissable answer to "which build is this?" — stamped
// automatically at CI build time from GITHUB_SHA/GITHUB_RUN_NUMBER via
// --dart-define (see .github/workflows/noor.yml), never hand-edited.
// A local/dev build with no dart-defines shows "dev · #0" instead of a
// misleading fake value. This label must stay visible on Home going
// forward — it is the only way anyone can confirm which commit an
// installed APK actually contains.

abstract final class BuildInfo {
  static const String commitSha = String.fromEnvironment(
    'BUILD_SHA',
    defaultValue: 'dev',
  );

  static const String buildNumber = String.fromEnvironment(
    'BUILD_NUMBER',
    defaultValue: '0',
  );

  static const String label = 'Build $commitSha · #$buildNumber';
}
