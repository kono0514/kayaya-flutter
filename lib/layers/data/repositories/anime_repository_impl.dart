import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../core/error.dart';
import '../../../core/exception.dart';
import '../../../core/paged_list.dart';
import '../../../core/utils/logger.dart';
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
      // var cache;
      // try {
      //   cache = await localDatasource.fetchFeatured();
      // } on CacheException catch (e, s) {
      //   errorLog(e.innerException, s);
      // }

      // var result;
      // if (cache == null) {
      //   result = await networkDatasource.fetchFeatured();
      //   try {
      //     localDatasource.cacheFeatured(result);
      //   } on CacheException catch (e, s) {
      //     errorLog(e.innerException, s);
      //   }
      // } else {
      //   result = cache;
      // }

      final result = await networkDatasource.fetchFeatured();
      return Right(result);
    } on ServerException catch (e, s) {
      errorLog(e.innerException, s);
      return Left(ServerFailure());
    } on CacheException catch (e, s) {
      errorLog(e.innerException, s);
      return Left(CacheFailure());
    } catch (e, s) {
      errorLog(e, s);
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    try {
      final result = await networkDatasource.fetchGenres();
      return Right(result);
    } on ServerException catch (e, s) {
      errorLog(e.innerException, s);
      return Left(ServerFailure());
    } catch (e, s) {
      errorLog(e, s);
      return Left(DataFailure());
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
    } on ServerException catch (e, s) {
      errorLog(e.innerException, s);
      return Left(ServerFailure());
    } catch (e, s) {
      errorLog(e, s);
      return Left(DataFailure());
    }
  }
}
