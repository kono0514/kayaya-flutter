part of 'details_cubit.dart';

abstract class DetailsState extends Equatable {
  const DetailsState();
}

class DetailsInitial extends DetailsState {
  const DetailsInitial();

  @override
  List<Object> get props => [];
}

class DetailsLoaded extends DetailsState {
  final Detail details;
  final Anime animeListData;
  final bool hasListData;

  const DetailsLoaded({this.details, this.animeListData, this.hasListData});

  @override
  List<Object> get props => [details, animeListData, hasListData];
}

class DetailsError extends DetailsState {
  final Exception exception;

  const DetailsError(this.exception);

  @override
  List<Object> get props => [exception];
}
