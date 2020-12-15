import 'package:injectable/injectable.dart';
import 'package:kayaya_flutter/core/exception.dart';
import 'package:kayaya_flutter/core/in_memory_cache.dart';
import 'package:meta/meta.dart';

import '../data/datasources/anime_local_datasource.dart';

@Injectable(as: AnimeLocalDatasource)
class AnimeLocalDatasourceMemoryImpl extends AnimeLocalDatasource {
  final InMemoryCache memoryCache;

  AnimeLocalDatasourceMemoryImpl({@required this.memoryCache});

  @override
  Future<void> cacheFeatured(
    String data, {
    Duration duration = const Duration(seconds: 10),
  }) async {
    try {
      memoryCache.cache<String>('featured', data, duration: duration);
    } catch (e) {
      throw CacheException(e);
    }
  }

  @override
  Future<String> fetchFeatured() {
    try {
      return Future.value(memoryCache.read<String>('featured'));
    } catch (e) {
      throw CacheException(e);
    }
  }
}
