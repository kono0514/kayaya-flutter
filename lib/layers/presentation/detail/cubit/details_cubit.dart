import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/anime.dart';
import '../../../domain/entities/detail.dart';
import '../../../domain/usecases/detail/get_detail_usecase.dart';
import '../../../domain/usecases/detail/get_detail_with_anime_usecase.dart';

part 'details_state.dart';

@Injectable()
class DetailsCubit extends Cubit<DetailsState> {
  final GetDetailUsecase getDetailUsecase;
  final GetDetailWithAnimeUsecase getDetailWithAnimeUsecase;

  DetailsCubit({
    @required this.getDetailUsecase,
    @required this.getDetailWithAnimeUsecase,
  }) : super(const DetailsInitial());

  Future<void> loadDetails(String id) async {
    emit(const DetailsInitial());

    final result = await getDetailUsecase(GetDetailUsecaseParams(id: id));
    result.fold(
      (l) => emit(DetailsError(l.message)),
      (r) => emit(DetailsLoaded(details: r, hasListData: false)),
    );
  }

  Future<void> loadDetailsFull(String id) async {
    emit(const DetailsInitial());

    final result = await getDetailWithAnimeUsecase(
        GetDetailWithAnimeUsecaseParams(id: id));
    result.fold(
      (l) => emit(DetailsError(l.message)),
      (r) => emit(DetailsLoaded(
        details: r.value2,
        animeListData: r.value1,
        hasListData: true,
      )),
    );
  }
}
