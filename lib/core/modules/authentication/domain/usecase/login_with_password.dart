import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../error.dart';
import '../../../../usecase.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class LoginWithPassword implements Usecase<User, SendPhoneCodeParams> {
  final AuthRepository authRepo;

  LoginWithPassword({@required this.authRepo});

  @override
  Future<Either<Failure, User>> call(SendPhoneCodeParams params) {
    return authRepo.signInWithPassword(
      username: params.username,
      password: params.password,
    );
  }
}

class SendPhoneCodeParams {
  final String username;
  final String password;

  SendPhoneCodeParams({
    @required this.username,
    @required this.password,
  });
}
