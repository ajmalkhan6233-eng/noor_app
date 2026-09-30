// Bismillahir Rahmanir Raheem — watermark: ALLAH


class SurahDownloadFailure implements Exception {
  const SurahDownloadFailure(this.message);
  final String message;
  @override
  String toString() => message;
}
