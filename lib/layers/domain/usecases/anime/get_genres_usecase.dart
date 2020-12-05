import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../entities/genre.dart';
import '../../repositories/anime_repository.dart';

@Injectable()
class GetGenresUsecase extends Usecase<List<Genre>, NoParams> {
  final AnimeRepository animeRepository;

  GetGenresUsecase({@required this.animeRepository});

  @override
  Future<Either<Failure, List<Genre>>> call(NoParams params) {
    return animeRepository.getGenres();
  }
}
