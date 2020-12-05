import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/paged_list.dart';
import '../../../../core/usecase.dart';
import '../../entities/anime.dart';
import '../../repositories/subscription_repository.dart';

@Injectable()
class GetSubscriptionsUsecase
    extends Usecase<PagedList<Anime>, GetSubscriptionsUsecaseParams> {
  final SubscriptionRepository subscriptionRepository;

  GetSubscriptionsUsecase({@required this.subscriptionRepository});

  @override
  Future<Either<Failure, PagedList<Anime>>> call(
      GetSubscriptionsUsecaseParams params) {
    return subscriptionRepository.getSubscribedAnimes(page: params.page);
  }
}

class GetSubscriptionsUsecaseParams {
  final int page;

  GetSubscriptionsUsecaseParams(this.page);
}
