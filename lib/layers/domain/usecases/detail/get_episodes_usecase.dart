import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/paged_list.dart';
import '../../../../core/usecase.dart';
import '../../entities/episode.dart';
import '../../repositories/detail_repository.dart';

@Injectable()
class GetEpisodesUsecase
    extends Usecase<PagedList<Episode>, GetEpisodesUsecaseParams> {
  final DetailRepository detailRepository;

  GetEpisodesUsecase({@required this.detailRepository});

  @override
  Future<Either<Failure, PagedList<Episode>>> call(
      GetEpisodesUsecaseParams params) {
    return detailRepository.getEpisodes(
      id: params.id,
      page: params.page,
      sortOrder: params.order,
    );
  }
}

class GetEpisodesUsecaseParams {
  final String id;
  final int page;
  final String order;

  GetEpisodesUsecaseParams({
    @required this.id,
    @required this.page,
    @required this.order,
  });
}
