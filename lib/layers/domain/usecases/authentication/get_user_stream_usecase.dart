import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/authentication_repository.dart';

@Injectable()
class GetUserStreamUsecase implements Usecase<Stream<User>, NoParams> {
  final AuthRepository authRepo;

  GetUserStreamUsecase({@required this.authRepo});

  @override
  Future<Either<Failure, Stream<User>>> call(NoParams _) {
    return Future.value(Right(authRepo.user));
  }
}
