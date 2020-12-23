import 'package:algolia/algolia.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../core/exception.dart';
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
    AlgoliaQuerySnapshot _results;
    try {
      _results = await _query.getObjects();
    } on Exception catch (e) {
      throw ServerException(e);
    }

    final _hits = <SearchResultModel>[];
    for (final hit in _results.hits) {
      _hits.add(SearchResultModel.fromJson({
        'id': hit.objectID.split('::').last,
        'name': pref.languageCode == 'en'
            ? hit.data['name_en']
            : hit.data['name_mn'],
        ...hit.data,
      }));
    }
    return _hits;
  }
}
