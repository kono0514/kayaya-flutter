part of 'browse_bloc.dart';

abstract class BrowseState extends Equatable {
  const BrowseState();

  @override
  List<Object> get props => [];
}

class BrowseInitial extends BrowseState {}

class BrowseLoaded extends BrowseState {
  final PagedList<Anime> animes;
  final Exception error;
  final String timestamp;

  const BrowseLoaded({
    this.animes,
    this.timestamp,
    this.error,
  });

  BrowseLoaded copyWith({
    PagedList<Anime> animes,
    Optional<Exception> error,
    String timestamp,
  }) {
    return BrowseLoaded(
      animes: animes ?? this.animes,
      error: error != null ? error.orNull : this.error,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object> get props => [animes, error, timestamp];
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
