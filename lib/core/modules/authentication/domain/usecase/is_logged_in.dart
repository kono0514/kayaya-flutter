import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../error.dart';
import '../../../../usecase.dart';
import '../repository/auth_repository.dart';

class IsLoggedIn implements Usecase<bool, NoParams> {
  final AuthRepository authRepo;

  IsLoggedIn({@required this.authRepo});

  @override
  Future<Either<Failure, bool>> call(NoParams _) {
    return authRepo.isLoggedIn();
  }
}
