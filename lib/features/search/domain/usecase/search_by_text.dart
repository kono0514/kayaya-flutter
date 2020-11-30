import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../entity/search_result.dart';
import '../repository/search_repository.dart';

class SearchByText extends Usecase<List<SearchResult>, SearchByTextParams> {
  final SearchRepository searchRepo;

  SearchByText({@required this.searchRepo});

  @override
  Future<Either<Failure, List<SearchResult>>> call(
      SearchByTextParams params) async {
    return searchRepo.search(params.text);
  }
}

class SearchByTextParams {
  final String text;

  SearchByTextParams({@required this.text});
}
