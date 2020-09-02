part of 'anime_episodes_bloc.dart';

abstract class AnimeEpisodesEvent extends Equatable {
  const AnimeEpisodesEvent();

  @override
  List<Object> get props => [];
}

class AnimeEpisodesFetched extends AnimeEpisodesEvent {
  final String id;
  final SortOrder sortOrder;

  AnimeEpisodesFetched(this.id, {this.sortOrder});

  @override
  String toString() => 'AnimeEpisodesFetched';
}

class AnimeEpisodesRefreshed extends AnimeEpisodesEvent {
  final String id;
  final SortOrder sortOrder;

  AnimeEpisodesRefreshed(this.id, {this.sortOrder});

  @override
  String toString() => 'AnimeEpisodesRefreshed';
}
