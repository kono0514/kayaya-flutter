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
  final List<Genre> genres;

  const GenreListLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

class GenreListError extends GenreListState {
  final String error;

  const GenreListError(this.error);

  @override
  List<Object> get props => [error];
}
