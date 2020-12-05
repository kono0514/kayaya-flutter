import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/paged_list.dart';
import '../../../../core/usecase.dart';
import '../../entities/anime.dart';
import '../../entities/anime_filter.dart';
import '../../repositories/anime_repository.dart';

@Injectable()
class GetAnimesUsecase
    extends Usecase<PagedList<Anime>, GetAnimesUsecaseParams> {
  final AnimeRepository animeRepository;

  GetAnimesUsecase({@required this.animeRepository});

  @override
  Future<Either<Failure, PagedList<Anime>>> call(
      GetAnimesUsecaseParams params) {
    return animeRepository.getAnimes(page: params.page, filter: params.filter);
  }
}

class GetAnimesUsecaseParams {
  final int page;
  final Filter filter;

  GetAnimesUsecaseParams({@required this.page, @required this.filter});
}
