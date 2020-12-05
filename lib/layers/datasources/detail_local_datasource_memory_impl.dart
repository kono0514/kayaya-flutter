import 'package:injectable/injectable.dart';
import 'package:kayaya_flutter/core/in_memory_cache.dart';
import 'package:meta/meta.dart';

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
    memoryCache.cache<DetailModel>(detail.id, detail, duration: duration);
  }

  @override
  Future<DetailModel> fetchDetail(String id) =>
      Future.value(memoryCache.read<DetailModel>(id));
}
