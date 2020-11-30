import 'package:dartz/dartz.dart';

import '../../../../core/error.dart';
import '../entity/search_result.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchResult>>> search(String text);
  Future<Either<Failure, List<String>>> getHistory();
  Future<Either<Failure, Unit>> saveHistory(String text);
  Future<Either<Failure, Unit>> clearHistory();
}
