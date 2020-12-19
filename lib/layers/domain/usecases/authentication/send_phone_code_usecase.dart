import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/authentication_repository.dart';

@Injectable()
class SendPhoneCodeUsecase
    implements Usecase<String, SendPhoneCodeUsecaseParams> {
  final AuthRepository authRepo;

  SendPhoneCodeUsecase({@required this.authRepo});

  @override
  Future<Either<Failure, String>> call(SendPhoneCodeUsecaseParams params) {
    return authRepo.signInWithPhoneNumberSend(number: params.number);
  }
}

class SendPhoneCodeUsecaseParams {
  final String number;

  SendPhoneCodeUsecaseParams({@required this.number});
}
