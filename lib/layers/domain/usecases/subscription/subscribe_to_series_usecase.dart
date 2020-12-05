import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/subscription_repository.dart';

@Injectable()
class SubscribeToSeriesUsecase
    extends Usecase<Unit, SubscribeToSeriesUsecaseParams> {
  final SubscriptionRepository subscriptionRepository;

  SubscribeToSeriesUsecase({@required this.subscriptionRepository});

  @override
  Future<Either<Failure, Unit>> call(SubscribeToSeriesUsecaseParams params) {
    return subscriptionRepository.subscribe(params.id);
  }
}

class SubscribeToSeriesUsecaseParams {
  final String id;

  SubscribeToSeriesUsecaseParams(this.id);
}
