import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../core/error.dart';
import '../../../core/exception.dart';
import '../../../core/paged_list.dart';
import '../../../core/utils/logger.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/anime_relation.dart';
import '../../domain/entities/detail.dart';
import '../../domain/entities/episode.dart';
import '../../domain/repositories/detail_repository.dart';
import '../datasources/detail_local_datasource.dart';
import '../datasources/detail_network_datasource.dart';

@Injectable(as: DetailRepository)
class DetailRepositoryImpl implements DetailRepository {
  final DetailLocalDatasource localDatasource;
  final DetailNetworkDatasource networkDatasource;

  DetailRepositoryImpl({
    @required this.localDatasource,
    @required this.networkDatasource,
  });

  @override
  Future<Either<Failure, Detail>> getDetail(String id) async {
    try {
      var cache;
      try {
        cache = await localDatasource.fetchDetail(id);
      } on CacheException catch (e, s) {
        errorLog(e.innerException, s);
      }

      var result;
      if (cache == null) {
        result = await networkDatasource.fetchDetail(id);
        try {
          localDatasource.cacheDetail(result);
        } on CacheException catch (e, s) {
          errorLog(e.innerException, s);
        }
      } else {
        result = cache;
      }

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
  Future<Either<Failure, Tuple2<Anime, Detail>>> getDetailWithAnime(
      String id) async {
    try {
      final result = await networkDatasource.fetchDetailFull(id);
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
  Future<Either<Failure, AnimeRelation>> getRelations(String id) async {
    try {
      final result = await networkDatasource.fetchRelations(id);
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
  Future<Either<Failure, PagedList<Episode>>> getEpisodes({
    String id,
    int page = 1,
    String sortOrder = 'asc',
  }) async {
    try {
      final result = await networkDatasource.fetchEpisodes(id, page, sortOrder);
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
  Future<Either<Failure, Tuple2<int, bool>>> getEpisodePageInfo(
      {String id, int number}) async {
    try {
      final result = await networkDatasource.fetchEpisodePageInfo(id, number);
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
