import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../error.dart';
import '../../../../usecase.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class SendPhoneCode
    implements Usecase<Either<User, String>, SendPhoneCodeParams> {
  final AuthRepository authRepo;

  SendPhoneCode({@required this.authRepo});

  @override
  Future<Either<Failure, Either<User, String>>> call(
      SendPhoneCodeParams params) {
    return authRepo.signInWithPhoneNumberSend(number: params.number);
  }
}

class SendPhoneCodeParams {
  final String number;

  SendPhoneCodeParams({@required this.number});
}
