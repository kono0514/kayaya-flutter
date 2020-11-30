import 'package:algolia/algolia.dart';
import 'package:meta/meta.dart';

import '../../data/datasource/network_search_datasource.dart';
import '../../data/model/search_result_model.dart';

class AlgoliaNetworkSearchDatasourceImpl extends NetworkSearchDatasource {
  final Algolia algolia;

  AlgoliaNetworkSearchDatasourceImpl({@required this.algolia});

  @override
  Future<List<SearchResultModel>> search(String text) async {
    final _query = algolia.index('animes').setHitsPerPage(20).search(text);
    final _results = await _query.getObjects();
    final _hits = <SearchResultModel>[];
    _results.hits.forEach((h) {
      _hits.add(SearchResultModel.fromJson({
        'id': h.objectID.split('::').last,
        ...h.data,
      }));
    });
    return _hits;
  }
}
