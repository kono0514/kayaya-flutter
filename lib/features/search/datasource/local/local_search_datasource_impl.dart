import 'package:kayaya_flutter/core/services/preferences_service.dart';
import 'package:meta/meta.dart';

import '../../data/datasource/local_search_datasource.dart';

class LocalSearchDatasourceImpl extends LocalSearchDatasource {
  final PreferencesService pref;

  LocalSearchDatasourceImpl({@required this.pref});

  @override
  Future<void> cacheQuery(String text) => pref.addSearchHistory(text);

  @override
  Future<List<String>> getHistory() => Future.value(pref.searchHistory);

  @override
  Future<void> clear() => Future.value(pref.clearSearchHistory());
}
