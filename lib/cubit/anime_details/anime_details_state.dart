part of 'anime_details_cubit.dart';

abstract class AnimeDetailsState extends Equatable {
  const AnimeDetailsState();
}

class AnimeDetailsInitial extends AnimeDetailsState {
  @override
  List<Object> get props => [];
}

class AnimeDetailsLoaded extends AnimeDetailsState {
  final GetAnimeDetails$Query$Anime details;

  AnimeDetailsLoaded(this.details);

  @override
  List<Object> get props => [details];
}

class AnimeDetailsError extends AnimeDetailsState {
  final Exception exception;

  const AnimeDetailsError(this.exception);

  @override
  List<Object> get props => [exception];
}
