import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../repository/search_repository.dart';

class SaveSearchHistory extends Usecase<Unit, SaveSearchHistoryParams> {
  final SearchRepository searchRepo;

  SaveSearchHistory({@required this.searchRepo});

  @override
  Future<Either<Failure, Unit>> call(SaveSearchHistoryParams params) {
    return searchRepo.saveHistory(params.text);
  }
}

class SaveSearchHistoryParams {
  final String text;

  SaveSearchHistoryParams({@required this.text});
}
