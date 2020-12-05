import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/error.dart';
import '../../../core/paged_list.dart';
import '../entities/anime.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, Unit>> subscribe(String id);
  Future<Either<Failure, Unit>> unsubscribe(String id);
  Future<Either<Failure, bool>> isSubscribed(String id);
  Future<Either<Failure, PagedList<Anime>>> getSubscribedAnimes({
    @required int page,
  });
}
