part of 'anime_relations_cubit.dart';

abstract class AnimeRelationsState extends Equatable {
  const AnimeRelationsState();

  @override
  List<Object> get props => [];
}

class AnimeRelationsInitial extends AnimeRelationsState {}

class AnimeRelationsLoaded extends AnimeRelationsState {
  final GetAnimeRelations$Query$Anime$Relations relations;
  final GetAnimeRelations$Query$Anime$Recommendations recommendations;

  const AnimeRelationsLoaded(this.relations, this.recommendations);

  @override
  List<Object> get props => [relations, recommendations];
}

class AnimeRelationsError extends AnimeRelationsState {
  final Exception exception;

  const AnimeRelationsError(this.exception);

  @override
  List<Object> get props => [exception];
}
