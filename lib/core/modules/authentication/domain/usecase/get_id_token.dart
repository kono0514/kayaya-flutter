import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../error.dart';
import '../../../../usecase.dart';
import '../repository/auth_repository.dart';

class GetIdToken implements Usecase<String, NoParams> {
  final AuthRepository authRepo;

  GetIdToken({@required this.authRepo});

  @override
  Future<Either<Failure, String>> call(NoParams _) {
    return authRepo.getIdToken();
  }
}
