import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/search_repository.dart';

@Injectable()
class ClearSearchHistoryUsecase extends Usecase<Unit, NoParams> {
  final SearchRepository searchRepo;

  ClearSearchHistoryUsecase({@required this.searchRepo});

  @override
  Future<Either<Failure, Unit>> call(NoParams _) {
    return searchRepo.clearHistory();
  }
}
