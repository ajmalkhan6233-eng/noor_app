// Bismillahir Rahmanir Raheem — watermark: ALLAH


/// One reported progress step during a download — `receivedBytes` and
/// `totalBytes` are both known up front (the source always reports
/// Content-Length), so progress is exact, not estimated.
class SurahDownloadProgress {
  const SurahDownloadProgress(this.receivedBytes, this.totalBytes);
  final int receivedBytes;
  final int? totalBytes;
  double? get fraction => totalBytes == null ? null : receivedBytes / totalBytes!;
}
