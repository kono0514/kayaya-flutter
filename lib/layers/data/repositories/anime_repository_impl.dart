import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../core/error.dart';
import '../../../core/paged_list.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/anime_filter.dart';
import '../../domain/entities/genre.dart';
import '../../domain/repositories/anime_repository.dart';
import '../datasources/anime_local_datasource.dart';
import '../datasources/anime_network_datasource.dart';

@Injectable(as: AnimeRepository)
class AnimeRepositoryImpl implements AnimeRepository {
  final AnimeLocalDatasource localDatasource;
  final AnimeNetworkDatasource networkDatasource;

  AnimeRepositoryImpl({
    @required this.localDatasource,
    @required this.networkDatasource,
  });

  @override
  Future<Either<Failure, String>> getFeatured() async {
    try {
      var result;
      var cache = await localDatasource.fetchFeatured();
      if (cache == null) {
        result = await networkDatasource.fetchFeatured();
        localDatasource.cacheFeatured(result);
      } else {
        result = cache;
      }

      return Right(result);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    try {
      final result = await networkDatasource.fetchGenres();
      return Right(result);
    } catch (e, s) {
      print(e);
      print(s);
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, PagedList<Anime>>> getAnimes({
    int page,
    Filter filter,
  }) async {
    try {
      final result = await networkDatasource.fetchAnimes(page, filter);
      return Right(result);
    } catch (e, s) {
      print(e);
      print(s);
      return Left(e);
    }
  }
}
