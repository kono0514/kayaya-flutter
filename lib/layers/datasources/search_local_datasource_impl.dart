import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../core/services/preferences_service.dart';
import '../data/datasources/search_local_datasource.dart';

@Injectable(as: SearchLocalDatasource)
class SearchLocalDatasourceImpl extends SearchLocalDatasource {
  final PreferencesService pref;

  SearchLocalDatasourceImpl({@required this.pref});

  @override
  Future<void> cacheQuery(String text) => pref.addSearchHistory(text);

  @override
  Future<List<String>> getHistory() => Future.value(pref.searchHistory);

  @override
  Future<void> clear() => Future.value(pref.clearSearchHistory());
}
