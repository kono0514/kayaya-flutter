import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../core/exception.dart';
import '../../core/in_memory_cache.dart';
import '../data/datasources/detail_local_datasource.dart';
import '../data/models/detail_model.dart';

@Injectable(as: DetailLocalDatasource)
class DetailLocalDatasourceMemoryImpl extends DetailLocalDatasource {
  final InMemoryCache memoryCache;

  DetailLocalDatasourceMemoryImpl({@required this.memoryCache});

  @override
  Future<void> cacheDetail(
    DetailModel detail, {
    Duration duration = const Duration(seconds: 60),
  }) async {
    try {
      memoryCache.cache<DetailModel>(detail.id, detail, duration: duration);
    } on Exception catch (e) {
      throw CacheException(e);
    }
  }

  @override
  Future<DetailModel> fetchDetail(String id) {
    try {
      return Future.value(memoryCache.read<DetailModel>(id));
    } on Exception catch (e) {
      throw CacheException(e);
    }
  }
}
