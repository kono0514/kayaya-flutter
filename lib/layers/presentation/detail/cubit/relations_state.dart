part of 'relations_cubit.dart';

abstract class RelationsState extends Equatable {
  const RelationsState();

  @override
  List<Object> get props => [];
}

class RelationsInitial extends RelationsState {}

class RelationsLoaded extends RelationsState {
  final List<AnimeRelated> relations;
  final List<AnimeRecommendation> recommendations;

  const RelationsLoaded(this.relations, this.recommendations);

  @override
  List<Object> get props => [relations, recommendations];
}

class RelationsError extends RelationsState {
  final Exception exception;

  const RelationsError(this.exception);

  @override
  List<Object> get props => [exception];
}
