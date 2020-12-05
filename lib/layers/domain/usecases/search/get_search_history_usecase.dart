import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/search_repository.dart';

@Injectable()
class GetSearchHistoryUsecase extends Usecase<List<String>, NoParams> {
  final SearchRepository searchRepo;

  GetSearchHistoryUsecase({@required this.searchRepo});

  @override
  Future<Either<Failure, List<String>>> call(NoParams _) {
    return searchRepo.getHistory();
  }
}
