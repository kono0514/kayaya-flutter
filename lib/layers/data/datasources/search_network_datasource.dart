import '../models/search_result_model.dart';

abstract class SearchNetworkDatasource {
  Future<List<SearchResultModel>> search(String text);
}
