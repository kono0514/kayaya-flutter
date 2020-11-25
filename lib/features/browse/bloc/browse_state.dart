part of 'browse_bloc.dart';

abstract class BrowseState extends Equatable {
  const BrowseState();

  @override
  List<Object> get props => [];
}

class BrowseInitial extends BrowseState {}

class BrowseLoaded extends BrowseState {
  final List<BrowseAnimes$Query$Animes$Data> animes;
  final BrowseAnimes$Query$Animes$PaginatorInfo paginatorInfo;
  final Exception error;
  final String timestamp;

  const BrowseLoaded({
    this.animes,
    this.paginatorInfo,
    this.timestamp,
    this.error,
  });

  BrowseLoaded copyWith({
    List<BrowseAnimes$Query$Animes$Data> animes,
    BrowseAnimes$Query$Animes$PaginatorInfo paginatorInfo,
    Optional<Exception> error,
    String timestamp,
  }) {
    return BrowseLoaded(
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
class BrowseError extends BrowseState {
  final Exception exception;

  const BrowseError(this.exception);

  @override
  List<Object> get props => [exception];
}

class BrowseEmpty extends BrowseState {
  const BrowseEmpty();
}
