import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/authentication_repository.dart';

@Injectable()
class VerifyPhoneCodeUsecase
    implements Usecase<User, VerifyPhoneCodeUsecaseParams> {
  final AuthRepository authRepo;

  VerifyPhoneCodeUsecase({@required this.authRepo});

  @override
  Future<Either<Failure, User>> call(VerifyPhoneCodeUsecaseParams params) {
    return authRepo.signInWithPhoneNumberVerify(
      verificationId: params.verificationId,
      code: params.code,
    );
  }
}

class VerifyPhoneCodeUsecaseParams {
  final String verificationId;
  final String code;

  VerifyPhoneCodeUsecaseParams({
    @required this.verificationId,
    @required this.code,
  });
}
