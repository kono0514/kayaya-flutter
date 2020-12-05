import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/authentication_repository.dart';

@Injectable()
class LoginWithPasswordUsecase implements Usecase<User, SendPhoneCodeParams> {
  final AuthRepository authRepo;

  LoginWithPasswordUsecase({@required this.authRepo});

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
