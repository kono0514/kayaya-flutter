part of 'player_episodes_bloc.dart';

abstract class PlayerEpisodesEvent extends Equatable {
  const PlayerEpisodesEvent();

  @override
  List<Object> get props => [];
}

class PlayerEpisodesFetchPrevious extends PlayerEpisodesEvent {}

class PlayerEpisodesFetchNext extends PlayerEpisodesEvent {}
