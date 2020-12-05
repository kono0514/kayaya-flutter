import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../core/error.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_datasource.dart';
import '../datasources/search_network_datasource.dart';

@Injectable(as: SearchRepository)
class SearchRepositoryImpl extends SearchRepository {
  final SearchLocalDatasource localDatasource;
  final SearchNetworkDatasource networkDatasource;

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
