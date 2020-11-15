import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:kayaya_flutter/models/search_result.dart';
import 'package:kayaya_flutter/services/search_service.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchService searchService = GetIt.I<SearchService>();

  SearchBloc() : super(SearchInitial());

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events, transitionFn) {
    return events
        .debounceTime(Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    final currentState = state;

    if (event is QueryChanged) {
      try {
        if (event.query.trim() == '') {
          yield SearchInitial();
          return;
        }

        if (currentState is SearchLoaded) {
          if (currentState.query == event.query) return;
          yield currentState.copyWith(isLoading: true);
        }

        final result = await searchService.search(event.query);

        yield (SearchLoaded(
          result: result,
          query: event.query,
          isLoading: false,
        ));
      } catch (e) {
        print(e);
        yield SearchError(e);
      }
    }
  }
}
