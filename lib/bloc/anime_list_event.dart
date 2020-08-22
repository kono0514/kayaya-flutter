part of 'anime_list_bloc.dart';

abstract class AnimeListEvent extends Equatable {
  const AnimeListEvent();

  @override
  List<Object> get props => [];
}

class AnimeListFetched extends AnimeListEvent {
  AnimeListFetched();

  @override
  String toString() => 'AnimeListFetched';
}

class AnimeListRefreshed extends AnimeListEvent {
  AnimeListRefreshed();

  @override
  String toString() => 'AnimeListRefreshed';
}
