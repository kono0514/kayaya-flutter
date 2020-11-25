import 'package:algolia/algolia.dart';
import 'package:kayaya_flutter/features/search/search.dart';

abstract class SearchService {
  Future<SearchResult> search(String query);
}

class AlgoliaSearchService implements SearchService {
  Algolia _client;

  AlgoliaSearchService() {
    _client = Algolia.init(
      applicationId: 'IBF8ZIWBKS',
      apiKey: 'a248f7500d9424891a3892b7eadd25a7',
    );
  }

  @override
  Future<SearchResult> search(String query) async {
    final _query = _client.index('animes').setHitsPerPage(20).search(query);
    final _results = await _query.getObjects();
    final List<SearchResultItem> _hits = [];
    _results.hits.forEach((h) {
      _hits.add(SearchResultItem.fromJson({
        'id': h.objectID.split('::').last,
        ...h.data,
      }));
    });
    return SearchResult(_hits);
  }
}

class ElasticSearchService implements SearchService {
  ElasticSearchService();

  @override
  Future<SearchResult> search(String query) async {
    throw UnimplementedError();
  }
}
