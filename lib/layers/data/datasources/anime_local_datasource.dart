abstract class AnimeLocalDatasource {
  Future<String> fetchFeatured();
  Future<void> cacheFeatured(
    String data, {
    Duration duration = const Duration(seconds: 10),
  });
}
