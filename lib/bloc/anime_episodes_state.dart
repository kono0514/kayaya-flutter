part of 'anime_episodes_bloc.dart';

abstract class AnimeEpisodesState extends Equatable {
  const AnimeEpisodesState();

  @override
  List<Object> get props => [];
}

class AnimeEpisodesInitial extends AnimeEpisodesState {}

class AnimeEpisodesLoaded extends AnimeEpisodesState {
  final List<GetAnimeEpisodes$Query$Episodes$Data> episodes;
  final GetAnimeEpisodes$Query$Episodes$PaginatorInfo paginatorInfo;
  final SortOrder sortOrder;
  final Exception error;

  const AnimeEpisodesLoaded({
    this.episodes,
    this.paginatorInfo,
    this.sortOrder = SortOrder.asc,
    this.error,
  });

  AnimeEpisodesLoaded copyWith({
    List<GetAnimeEpisodes$Query$Episodes$Data> epispdes,
    GetAnimeEpisodes$Query$Episodes$PaginatorInfo paginatorInfo,
    SortOrder sortOrder,
    Optional<Exception> error,
  }) {
    return AnimeEpisodesLoaded(
      episodes: episodes ?? this.episodes,
      paginatorInfo: paginatorInfo ?? this.paginatorInfo,
      sortOrder: sortOrder ?? this.sortOrder,
      error: error != null ? error.orNull : this.error,
    );
  }

  @override
  List<Object> get props => [episodes, paginatorInfo, sortOrder, error];
}

// Initial list fetch error
class AnimeEpisodesError extends AnimeEpisodesState {
  final Exception exception;

  const AnimeEpisodesError(this.exception);

  @override
  List<Object> get props => [exception];
}

class AnimeEpisodesEmpty extends AnimeEpisodesState {
  const AnimeEpisodesEmpty();
}
