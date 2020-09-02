part of 'animes_cubit.dart';

@immutable
abstract class AnimesState extends Equatable {
  const AnimesState();
}

class AnimesInitialState extends AnimesState {
  const AnimesInitialState();

  @override
  List<Object> get props => [];
}

class AnimesLoadedState extends AnimesState {
  final List<BrowseAnimes$Query$Animes$Data> animes;
  final BrowseAnimes$Query$Animes$PaginatorInfo paginatorInfo;

  const AnimesLoadedState(this.animes, this.paginatorInfo);

  @override
  List<Object> get props => [animes, paginatorInfo];
}

class AnimesErrorState extends AnimesState {
  final Exception exception;

  const AnimesErrorState(this.exception);

  @override
  List<Object> get props => [];
}
