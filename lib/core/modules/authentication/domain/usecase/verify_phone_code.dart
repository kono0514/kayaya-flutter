import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../error.dart';
import '../../../../usecase.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class VerifyPhoneCode implements Usecase<User, VerifyPhoneCodeParams> {
  final AuthRepository authRepo;

  VerifyPhoneCode({@required this.authRepo});

  @override
  Future<Either<Failure, User>> call(VerifyPhoneCodeParams params) {
    return authRepo.signInWithPhoneNumberVerify(
      verificationId: params.verificationId,
      code: params.code,
    );
  }
}

class VerifyPhoneCodeParams {
  final String verificationId;
  final String code;

  VerifyPhoneCodeParams({
    @required this.verificationId,
    @required this.code,
  });
}
