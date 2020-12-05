import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/authentication_repository.dart';

@Injectable()
class LoginWithAnonymousUsecase implements Usecase<User, NoParams> {
  final AuthRepository authRepo;

  LoginWithAnonymousUsecase({@required this.authRepo});

  @override
  Future<Either<Failure, User>> call(NoParams _) {
    return authRepo.signInAnonymously();
  }
}
