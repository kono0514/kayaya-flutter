import 'package:dartz/dartz.dart';
import 'package:kayaya_flutter/core/error.dart';
import 'package:meta/meta.dart';

import '../../../../usecase.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class GetUserStream implements Usecase<Stream<User>, NoParams> {
  final AuthRepository authRepo;

  GetUserStream({@required this.authRepo});

  @override
  Future<Either<Failure, Stream<User>>> call(NoParams _) {
    return Future.value(Right(authRepo.user));
  }
}
