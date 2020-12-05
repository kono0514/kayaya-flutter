import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/anime_repository.dart';

@Injectable()
class GetFeaturedUsecase implements Usecase<String, NoParams> {
  final AnimeRepository animeRepository;

  GetFeaturedUsecase({@required this.animeRepository});

  @override
  Future<Either<Failure, String>> call(NoParams _) {
    return animeRepository.getFeatured();
  }
}
