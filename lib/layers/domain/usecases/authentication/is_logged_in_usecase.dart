import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/authentication_repository.dart';

@Injectable()
class IsLoggedInUsecase implements Usecase<bool, NoParams> {
  final AuthRepository authRepo;

  IsLoggedInUsecase({@required this.authRepo});

  @override
  Future<Either<Failure, bool>> call(NoParams _) {
    return authRepo.isLoggedIn();
  }
}
