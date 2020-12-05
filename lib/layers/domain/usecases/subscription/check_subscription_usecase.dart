import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/subscription_repository.dart';

@Injectable()
class CheckSubscriptionUsecase
    extends Usecase<bool, CheckSubscriptionUsecaseParams> {
  final SubscriptionRepository subscriptionRepository;

  CheckSubscriptionUsecase({@required this.subscriptionRepository});
  @override
  Future<Either<Failure, bool>> call(CheckSubscriptionUsecaseParams params) {
    return subscriptionRepository.isSubscribed(params.id);
  }
}

class CheckSubscriptionUsecaseParams {
  final String id;

  CheckSubscriptionUsecaseParams(this.id);
}
