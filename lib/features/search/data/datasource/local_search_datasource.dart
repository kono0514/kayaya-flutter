abstract class LocalSearchDatasource {
  Future<List<String>> getHistory();
  Future<void> cacheQuery(String text);
  Future<void> clear();
}
