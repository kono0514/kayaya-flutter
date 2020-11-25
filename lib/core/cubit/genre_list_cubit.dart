import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';

part 'genre_list_state.dart';

class GenreListCubit extends Cubit<GenreListState> {
  final AniimRepository repository;

  GenreListCubit(this.repository) : super(GenreListInitial());

  void getGenreList() async {
    final currentState = state;

    if (currentState is! GenreListLoaded) {
      try {
        emit(GenreListLoading());

        final genres = await repository.fetchGenres();
        emit(GenreListLoaded(genres));
      } catch (e) {
        emit(GenreListError(e));
      }
    }
  }
}
