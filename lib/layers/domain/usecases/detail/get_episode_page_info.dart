import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../repositories/detail_repository.dart';

@Injectable()
class GetEpisodePageInfoUsecase
    extends Usecase<Tuple2<int, bool>, GetEpisodePageInfoUsecaseParams> {
  final DetailRepository detailRepository;

  GetEpisodePageInfoUsecase({@required this.detailRepository});

  @override
  Future<Either<Failure, Tuple2<int, bool>>> call(
      GetEpisodePageInfoUsecaseParams params) {
    return detailRepository.getEpisodePageInfo(
      id: params.id,
      number: params.number,
    );
  }
}

class GetEpisodePageInfoUsecaseParams {
  final String id;
  final int number;

  GetEpisodePageInfoUsecaseParams({@required this.id, @required this.number});
}
