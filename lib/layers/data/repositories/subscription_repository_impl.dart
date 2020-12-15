import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../core/error.dart';
import '../../../core/exception.dart';
import '../../../core/paged_list.dart';
import '../../../core/utils/logger.dart';
import '../../domain/entities/anime.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_network_datasource.dart';

@Injectable(as: SubscriptionRepository)
class SubscriptionRepositoryImpl extends SubscriptionRepository {
  final SubscriptionNetworkDatasource networkDatasource;

  SubscriptionRepositoryImpl({@required this.networkDatasource});

  @override
  Future<Either<Failure, PagedList<Anime>>> getSubscribedAnimes(
      {int page}) async {
    try {
      final _result = await networkDatasource.fetchSubscriptions(page);
      return Right(_result);
    } on ServerException catch (e, s) {
      errorLog(e.innerException, s);
      return Left(ServerFailure());
    } catch (e, s) {
      errorLog(e, s);
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> subscribe(String id) async {
    try {
      await networkDatasource.subscribe(id);
      return Right(unit);
    } on ServerException catch (e, s) {
      errorLog(e.innerException, s);
      return Left(ServerFailure());
    } catch (e, s) {
      errorLog(e, s);
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> unsubscribe(String id) async {
    try {
      await networkDatasource.unsubscribe(id);
      return Right(unit);
    } on ServerException catch (e, s) {
      errorLog(e.innerException, s);
      return Left(ServerFailure());
    } catch (e, s) {
      errorLog(e, s);
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isSubscribed(String id) async {
    try {
      final result = await networkDatasource.fetchIsSubscribed(id);
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
