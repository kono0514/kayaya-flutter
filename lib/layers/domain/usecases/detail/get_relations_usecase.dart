import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../entities/anime_relation.dart';
import '../../repositories/detail_repository.dart';

@Injectable()
class GetRelationsUsecase
    extends Usecase<AnimeRelation, GetRelationsUsecaseParams> {
  final DetailRepository detailRepository;

  GetRelationsUsecase({@required this.detailRepository});

  @override
  Future<Either<Failure, AnimeRelation>> call(
      GetRelationsUsecaseParams params) {
    return detailRepository.getRelations(params.id);
  }
}

class GetRelationsUsecaseParams {
  final String id;

  GetRelationsUsecaseParams({@required this.id});
}
