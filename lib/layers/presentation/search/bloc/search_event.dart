part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  final String query;

  const SearchEvent(this.query);

  @override
  List<Object> get props => [query];
}

class QueryChanged extends SearchEvent {
  const QueryChanged(String query) : super(query);
}

class QueryChangedTyping extends SearchEvent {
  const QueryChangedTyping(String query) : super(query);
}
