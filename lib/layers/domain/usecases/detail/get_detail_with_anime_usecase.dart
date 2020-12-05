import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../entities/anime.dart';
import '../../entities/detail.dart';
import '../../repositories/detail_repository.dart';

@Injectable()
class GetDetailWithAnimeUsecase
    extends Usecase<Tuple2<Anime, Detail>, GetDetailWithAnimeUsecaseParams> {
  final DetailRepository detailRepository;

  GetDetailWithAnimeUsecase({@required this.detailRepository});

  @override
  Future<Either<Failure, Tuple2<Anime, Detail>>> call(
      GetDetailWithAnimeUsecaseParams params) {
    return detailRepository.getDetailWithAnime(params.id);
  }
}

class GetDetailWithAnimeUsecaseParams {
  final String id;

  GetDetailWithAnimeUsecaseParams({@required this.id});
}
