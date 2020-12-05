part of 'featured_cubit.dart';

abstract class FeaturedState extends Equatable {
  const FeaturedState();

  @override
  List<Object> get props => [];
}

class FeaturedInitial extends FeaturedState {}

class FeaturedLoaded extends FeaturedState {
  final String data;

  FeaturedLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class FeaturedError extends FeaturedState {
  final String errorMessage;

  FeaturedError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
