part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class QueryChanged extends SearchEvent {
  final String query;

  const QueryChanged(this.query);
}
