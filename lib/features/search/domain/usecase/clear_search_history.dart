import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../repository/search_repository.dart';

class ClearSearchHistory extends Usecase<Unit, NoParams> {
  final SearchRepository searchRepo;

  ClearSearchHistory({@required this.searchRepo});

  @override
  Future<Either<Failure, Unit>> call(NoParams _) {
    return searchRepo.clearHistory();
  }
}
