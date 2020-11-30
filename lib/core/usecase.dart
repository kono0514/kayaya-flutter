import 'package:dartz/dartz.dart';

import 'error.dart';

abstract class Usecase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {}
