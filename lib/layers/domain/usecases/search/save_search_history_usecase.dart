import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/search_repository.dart';

@Injectable()
class SaveSearchHistoryUsecase
    extends Usecase<Unit, SaveSearchHistoryUsecaseParams> {
  final SearchRepository searchRepo;

  SaveSearchHistoryUsecase({@required this.searchRepo});

  @override
  Future<Either<Failure, Unit>> call(SaveSearchHistoryUsecaseParams params) {
    return searchRepo.saveHistory(params.text);
  }
}

class SaveSearchHistoryUsecaseParams {
  final String text;

  SaveSearchHistoryUsecaseParams({@required this.text});
}
