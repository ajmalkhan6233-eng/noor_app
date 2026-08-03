// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Typed outcome of checking/running the Quran import — the UI always
// shows one of these, never a raw exception string.

sealed class QuranImportStatus {
  const QuranImportStatus();
}

/// Already imported and ready to read/search.
class QuranImported extends QuranImportStatus {
  const QuranImported();
}

/// No Tanzil asset file found — the feature is disabled until one is
/// added.
class QuranAssetMissing extends QuranImportStatus {
  const QuranAssetMissing();
}

/// An asset file exists but its SHA-256 didn't match the expected
/// value — refused rather than importing unverified text.
class QuranVerificationFailed extends QuranImportStatus {
  const QuranVerificationFailed();
}
