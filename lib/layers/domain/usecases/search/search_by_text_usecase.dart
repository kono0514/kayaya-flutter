import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../entities/search_result.dart';
import '../../repositories/search_repository.dart';

@Injectable()
class SearchByTextUsecase
    extends Usecase<List<SearchResult>, SearchByTextUsecaseParams> {
  final SearchRepository searchRepo;

  SearchByTextUsecase({@required this.searchRepo});

  @override
  Future<Either<Failure, List<SearchResult>>> call(
      SearchByTextUsecaseParams params) async {
    return searchRepo.search(params.text);
  }
}

class SearchByTextUsecaseParams {
  final String text;

  SearchByTextUsecaseParams({@required this.text});
}
