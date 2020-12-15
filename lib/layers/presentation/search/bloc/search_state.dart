part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchHistoryLoaded extends SearchState {
  final List<String> result;

  const SearchHistoryLoaded({@required this.result});

  @override
  List<Object> get props => [result];
}

class SearchLoaded extends SearchState {
  final bool isLoading;
  final List<SearchResult> result;
  final String query;

  const SearchLoaded({this.result, this.isLoading, this.query});

  SearchLoaded copyWith({
    bool isLoading,
    List<SearchResult> result,
    String query,
  }) {
    return SearchLoaded(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      query: query ?? this.query,
    );
  }

  @override
  List<Object> get props => [result, isLoading, query];
}

class SearchError extends SearchState {
  final String error;

  const SearchError(this.error);

  @override
  List<Object> get props => [error];
}
