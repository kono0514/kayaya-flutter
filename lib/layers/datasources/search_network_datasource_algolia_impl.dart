import 'package:algolia/algolia.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../core/services/preferences_service.dart';
import '../data/datasources/search_network_datasource.dart';
import '../data/models/search_result_model.dart';

@Injectable(as: SearchNetworkDatasource)
class SearchNetworkDatasourceAlgoliaImpl extends SearchNetworkDatasource {
  final Algolia algolia;
  final PreferencesService pref;

  SearchNetworkDatasourceAlgoliaImpl({
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