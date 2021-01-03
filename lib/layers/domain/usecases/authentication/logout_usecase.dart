import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/usecase.dart';
import '../../repositories/authentication_repository.dart';

@Injectable()
class LogoutUsecase implements Usecase<Unit, NoParams> {
  final AuthRepository authRepo;
  final PreferencesService pref;

  LogoutUsecase({@required this.authRepo, @required this.pref});

  @override
  Future<Either<Failure, Unit>> call(NoParams _) async {
    await pref.saveCurrentFcmToken('');
    return authRepo.signOut();
  }
}
