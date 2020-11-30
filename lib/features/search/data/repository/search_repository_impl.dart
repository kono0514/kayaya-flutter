import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../domain/entity/search_result.dart';
import '../../domain/repository/search_repository.dart';
import '../datasource/local_search_datasource.dart';
import '../datasource/network_search_datasource.dart';

class SearchRepositoryImpl extends SearchRepository {
  final LocalSearchDatasource localDatasource;
  final NetworkSearchDatasource networkDatasource;

  SearchRepositoryImpl({
    @required this.localDatasource,
    @required this.networkDatasource,
  });

  @override
  Future<Either<Failure, List<SearchResult>>> search(String text) async {
    try {
      final _result = await networkDatasource.search(text);
      return Right(_result);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<String>>> getHistory() async {
    try {
      final _result = await localDatasource.getHistory();
      return Right(_result);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Unit>> saveHistory(String text) async {
    try {
      await localDatasource.cacheQuery(text);
      return Right(unit);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Unit>> clearHistory() async {
    try {
      await localDatasource.clear();
      return Right(unit);
    } catch (e) {
      return Left(e);
    }
  }
}
