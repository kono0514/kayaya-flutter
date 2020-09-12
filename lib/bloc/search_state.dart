part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoaded extends SearchState {
  final bool isLoading;
  final List<AlgoliaObjectSnapshot> hits;
  final String query;

  const SearchLoaded({this.hits, this.isLoading, this.query});

  SearchLoaded copyWith({
    bool isLoading,
    List<AlgoliaObjectSnapshot> hits,
    String query,
  }) {
    return SearchLoaded(
      isLoading: isLoading ?? this.isLoading,
      hits: hits ?? this.hits,
      query: query ?? this.query,
    );
  }

  @override
  List<Object> get props => [hits, isLoading, query];
}

class SearchError extends SearchState {
  final Exception exception;

  const SearchError(this.exception);

  @override
  List<Object> get props => [exception];
}
