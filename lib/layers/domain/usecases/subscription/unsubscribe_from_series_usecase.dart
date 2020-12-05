import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/subscription_repository.dart';

@Injectable()
class UnsubscribeFromSeriesUsecase
    extends Usecase<Unit, UnsubscribeFromSeriesUsecaseParams> {
  final SubscriptionRepository subscriptionRepository;

  UnsubscribeFromSeriesUsecase({@required this.subscriptionRepository});

  @override
  Future<Either<Failure, Unit>> call(
      UnsubscribeFromSeriesUsecaseParams params) {
    return subscriptionRepository.unsubscribe(params.id);
  }
}

class UnsubscribeFromSeriesUsecaseParams {
  final String id;

  UnsubscribeFromSeriesUsecaseParams(this.id);
}
