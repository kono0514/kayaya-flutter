import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../error.dart';
import '../../../../usecase.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class LoginWithAnonymous implements Usecase<User, NoParams> {
  final AuthRepository authRepo;

  LoginWithAnonymous({@required this.authRepo});

  @override
  Future<Either<Failure, User>> call(NoParams _) {
    return authRepo.signInAnonymously();
  }
}
