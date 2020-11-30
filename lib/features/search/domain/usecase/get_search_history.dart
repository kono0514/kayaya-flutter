import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../repository/search_repository.dart';

class GetSearchHistory extends Usecase<List<String>, NoParams> {
  final SearchRepository searchRepo;

  GetSearchHistory({@required this.searchRepo});

  @override
  Future<Either<Failure, List<String>>> call(NoParams _) {
    return searchRepo.getHistory();
  }
}
