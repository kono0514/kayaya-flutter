import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error.dart';
import '../../../../core/usecase.dart';
import '../../entities/detail.dart';
import '../../repositories/detail_repository.dart';

@Injectable()
class GetDetailUsecase extends Usecase<Detail, GetDetailUsecaseParams> {
  final DetailRepository detailRepository;

  GetDetailUsecase({@required this.detailRepository});

  @override
  Future<Either<Failure, Detail>> call(GetDetailUsecaseParams params) {
    return detailRepository.getDetail(params.id);
  }
}

class GetDetailUsecaseParams {
  final String id;

  GetDetailUsecaseParams({@required this.id});
}
