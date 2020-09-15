part of 'anime_details_cubit.dart';

abstract class AnimeDetailsState extends Equatable {
  const AnimeDetailsState();
}

class AnimeDetailsInitial extends AnimeDetailsState {
  const AnimeDetailsInitial();

  @override
  List<Object> get props => [];
}

class AnimeDetailsLoaded extends AnimeDetailsState {
  final GetAnimeDetails$Query$Anime details;
  final BrowseAnimes$Query$Animes$Data listData;
  final bool hasListData;

  const AnimeDetailsLoaded({this.details, this.listData, this.hasListData});

  @override
  List<Object> get props => [details, listData, hasListData];
}

class AnimeDetailsError extends AnimeDetailsState {
  final Exception exception;

  const AnimeDetailsError(this.exception);

  @override
  List<Object> get props => [exception];
}
