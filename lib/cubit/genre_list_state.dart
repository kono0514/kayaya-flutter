part of 'genre_list_cubit.dart';

abstract class GenreListState extends Equatable {
  const GenreListState();
}

class GenreListInitial extends GenreListState {
  const GenreListInitial();

  @override
  List<Object> get props => [];
}

class GenreListLoading extends GenreListState {
  const GenreListLoading();

  @override
  List<Object> get props => [];
}

class GenreListLoaded extends GenreListState {
  final List<GetGenres$Query$Genre> genres;

  GenreListLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

class GenreListError extends GenreListState {
  final Exception exception;

  GenreListError(this.exception);

  @override
  List<Object> get props => [exception];
}
