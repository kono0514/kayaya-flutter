part of 'player_episodes_bloc.dart';

abstract class PlayerEpisodesState extends Equatable {
  const PlayerEpisodesState();

  @override
  List<Object> get props => [];
}

class PlayerEpisodesInitial extends PlayerEpisodesState {
  PlayerEpisodesInitial();
}

class PlayerEpisodesLoaded extends PlayerEpisodesState {
  final PagedList<Episode> negativeEpisodes;
  final PagedList<Episode> positiveEpisodes;
  final String negativeError;
  final String positiveError;
  final int startingPage;

  const PlayerEpisodesLoaded({
    this.negativeEpisodes,
    this.positiveEpisodes,
    this.negativeError,
    this.positiveError,
    this.startingPage,
  });

  bool get hasMoreNegativeEpisodes {
    if (startingPage == 1) return false;
    return negativeEpisodes == null || negativeEpisodes.currentPage != 1;
  }

  bool get hasMorePositiveEpisodes =>
      positiveEpisodes == null || positiveEpisodes.hasMorePages;

  PlayerEpisodesLoaded copyWith({
    PagedList<Episode> negativeEpisodes,
    PagedList<Episode> positiveEpisodes,
    Optional<String> negativeError,
    Optional<String> positiveError,
    int startingPage,
  }) {
    return PlayerEpisodesLoaded(
      negativeEpisodes: negativeEpisodes ?? this.negativeEpisodes,
      positiveEpisodes: positiveEpisodes ?? this.positiveEpisodes,
      negativeError:
          negativeError != null ? negativeError.orNull : this.negativeError,
      positiveError:
          positiveError != null ? positiveError.orNull : this.positiveError,
      startingPage: startingPage ?? this.startingPage,
    );
  }

  @override
  List<Object> get props =>
      [negativeEpisodes, positiveEpisodes, negativeError, positiveError];
}

class PlayerEpisodesError extends PlayerEpisodesState {
  final String error;

  const PlayerEpisodesError(this.error);

  @override
  List<Object> get props => [error];
}

class PlayerEpisodesEmpty extends PlayerEpisodesState {
  const PlayerEpisodesEmpty();
}
