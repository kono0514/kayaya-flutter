import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/authentication_repository.dart';

@Injectable()
class LogoutUsecase implements Usecase<Unit, NoParams> {
  final AuthRepository authRepo;

  LogoutUsecase({@required this.authRepo});

  @override
  Future<Either<Failure, Unit>> call(NoParams _) async {
    return authRepo.signOut();
  }
}
