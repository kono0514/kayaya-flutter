part of 'anime_list_bloc.dart';

abstract class AnimeListState extends Equatable {
  const AnimeListState();

  @override
  List<Object> get props => [];
}

class AnimeListInitial extends AnimeListState {}

class AnimeListInitialState extends AnimeListState {
  const AnimeListInitialState();

  @override
  List<Object> get props => [];
}

class AnimeListLoadedState extends AnimeListState {
  final List<BrowseAnimes$Query$Animes$Data> animes;
  final BrowseAnimes$Query$Animes$PaginatorInfo paginatorInfo;
  final Exception error;
  final String timestamp;

  const AnimeListLoadedState({
    this.animes,
    this.paginatorInfo,
    this.timestamp,
    this.error,
  });

  AnimeListLoadedState copyWith({
    List<BrowseAnimes$Query$Animes$Data> animes,
    BrowseAnimes$Query$Animes$PaginatorInfo paginatorInfo,
    Optional<Exception> error,
    String timestamp,
  }) {
    return AnimeListLoadedState(
      animes: animes ?? this.animes,
      paginatorInfo: paginatorInfo ?? this.paginatorInfo,
      error: error != null ? error.orNull : this.error,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object> get props => [animes, paginatorInfo, error, timestamp];
}

// Initial list fetch error
class AnimeListErrorState extends AnimeListState {
  final Exception exception;

  const AnimeListErrorState(this.exception);

  @override
  List<Object> get props => [exception];
}

class AnimeListEmptyState extends AnimeListState {
  const AnimeListEmptyState();
}
