import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../error.dart';
import '../../../../usecase.dart';
import '../repository/auth_repository.dart';

class Logout implements Usecase<Unit, NoParams> {
  final AuthRepository authRepo;

  Logout({@required this.authRepo});

  @override
  Future<Either<Failure, Unit>> call(NoParams _) async {
    return await authRepo.signOut();
  }
}
