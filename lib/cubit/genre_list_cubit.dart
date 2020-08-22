import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/repository.dart';

part 'genre_list_state.dart';

class GenreListCubit extends Cubit<GenreListState> {
  final AniimRepository repository;

  GenreListCubit(this.repository) : super(GenreListInitial());

  void getGenreList() async {
    final currentState = state;

    print('getGenreList state is ${currentState.runtimeType}');

    if (!(currentState is GenreListLoaded)) {
      try {
        print('loading');
        emit(GenreListLoading());

        final genres = await repository.fetchGenres();
        emit(GenreListLoaded(genres));
      } catch (e) {
        emit(GenreListError(e));
      }
    }
  }
}
