import '../model/search_result_model.dart';

abstract class NetworkSearchDatasource {
  Future<List<SearchResultModel>> search(String text);
}
