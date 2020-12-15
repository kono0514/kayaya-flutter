import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase.dart';
import '../../../domain/entities/genre.dart';
import '../../../domain/usecases/anime/get_genres_usecase.dart';

part 'genre_list_state.dart';

@Injectable()
class GenreListCubit extends Cubit<GenreListState> {
  final GetGenresUsecase getGenresUsecase;

  GenreListCubit(this.getGenresUsecase) : super(GenreListInitial());

  void getGenreList() async {
    final currentState = state;

    if (currentState is! GenreListLoaded) {
      final result = await getGenresUsecase(NoParams());
      result.fold(
        (l) => emit(GenreListError(l.message)),
        (r) => emit(GenreListLoaded(r)),
      );
    }
  }
}
