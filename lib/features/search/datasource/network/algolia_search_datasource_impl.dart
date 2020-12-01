import 'package:algolia/algolia.dart';
import 'package:kayaya_flutter/core/services/preferences_service.dart';
import 'package:meta/meta.dart';

import '../../data/datasource/network_search_datasource.dart';
import '../../data/model/search_result_model.dart';

class AlgoliaNetworkSearchDatasourceImpl extends NetworkSearchDatasource {
  final Algolia algolia;
  final PreferencesService pref;

  AlgoliaNetworkSearchDatasourceImpl({
    @required this.algolia,
    @required this.pref,
  });

  @override
  Future<List<SearchResultModel>> search(String text) async {
    final _query = algolia.index('animes').setHitsPerPage(20).search(text);
    final _results = await _query.getObjects();
    final _hits = <SearchResultModel>[];
    _results.hits.forEach((h) {
      _hits.add(SearchResultModel.fromJson({
        'id': h.objectID.split('::').last,
        'name':
            pref.languageCode == 'en' ? h.data['name_en'] : h.data['name_mn'],
        ...h.data,
      }));
    });
    return _hits;
  }
}
