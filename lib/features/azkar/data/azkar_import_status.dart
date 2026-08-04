// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Typed outcome of checking/running the azkar import — mirrors
// QuranImportStatus so the two features fail the same honest way.

sealed class AzkarImportStatus {
  const AzkarImportStatus();
}

class AzkarImported extends AzkarImportStatus {
  const AzkarImported();
}

/// No bundled dataset found — the feature stays at "no items yet".
class AzkarAssetMissing extends AzkarImportStatus {
  const AzkarAssetMissing();
}

/// A dataset exists but its SHA-256 didn't match — refused rather
/// than importing unverified text.
class AzkarVerificationFailed extends AzkarImportStatus {
  const AzkarVerificationFailed();
}
