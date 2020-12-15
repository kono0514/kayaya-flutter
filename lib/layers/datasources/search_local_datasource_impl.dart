import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../core/exception.dart';
import '../../core/services/preferences_service.dart';
import '../data/datasources/search_local_datasource.dart';

@Injectable(as: SearchLocalDatasource)
class SearchLocalDatasourceImpl extends SearchLocalDatasource {
  final PreferencesService pref;

  SearchLocalDatasourceImpl({@required this.pref});

  @override
  Future<void> cacheQuery(String text) async {
    try {
      pref.addSearchHistory(text);
    } catch (e) {
      throw CacheException(e);
    }
  }

  @override
  Future<List<String>> getHistory() {
    try {
      return Future.value(pref.searchHistory);
    } catch (e) {
      throw CacheException(e);
    }
  }

  @override
  Future<void> clear() async {
    try {
      Future.value(pref.clearSearchHistory());
    } catch (e) {
      throw CacheException(e);
    }
  }
}
