part of 'episodes_bloc.dart';

abstract class EpisodesEvent extends Equatable {
  const EpisodesEvent();

  @override
  List<Object> get props => [];
}

class EpisodesFetched extends EpisodesEvent {
  final String id;
  final String sortOrder;

  EpisodesFetched(this.id, {this.sortOrder});

  @override
  String toString() => 'EpisodesFetched';
}

class EpisodesRefreshed extends EpisodesEvent {
  final String id;
  final String sortOrder;

  EpisodesRefreshed(this.id, {this.sortOrder});

  @override
  String toString() => 'EpisodesRefreshed';
}
