part of 'episodes_bloc.dart';

abstract class EpisodesState extends Equatable {
  const EpisodesState();

  @override
  List<Object> get props => [];
}

class EpisodesInitial extends EpisodesState {}

class EpisodesLoaded extends EpisodesState {
  final PagedList<Episode> episodes;
  final String sortOrder;
  final String error;

  const EpisodesLoaded({
    this.episodes,
    this.sortOrder = 'asc',
    this.error,
  });

  EpisodesLoaded copyWith({
    PagedList<Episode> episodes,
    String sortOrder,
    Optional<String> error,
  }) {
    return EpisodesLoaded(
      episodes: episodes ?? this.episodes,
      sortOrder: sortOrder ?? this.sortOrder,
      error: error != null ? error.orNull : this.error,
    );
  }

  @override
  List<Object> get props => [episodes, sortOrder, error];
}

// Initial list fetch error
class EpisodesError extends EpisodesState {
  final String error;

  const EpisodesError(this.error);

  @override
  List<Object> get props => [error];
}

class EpisodesEmpty extends EpisodesState {
  const EpisodesEmpty();
}
