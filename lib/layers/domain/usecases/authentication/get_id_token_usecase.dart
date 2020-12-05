import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/authentication_repository.dart';

@Injectable()
class GetIdTokenUsecase implements Usecase<String, NoParams> {
  final AuthRepository authRepo;

  GetIdTokenUsecase({@required this.authRepo});

  @override
  Future<Either<Failure, String>> call(NoParams _) {
    return authRepo.getIdToken();
  }
}
