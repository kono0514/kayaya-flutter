import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/algolia_client_provider.dart';
import 'package:kayaya_flutter/logger.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Algolia algolia = AlgoliaClientProvider.instance.algolia;

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

        final _query =
            algolia.index('animes').setHitsPerPage(20).search(event.query);
        final _result = await _query.getObjects();

        yield (SearchLoaded(
          hits: _result.hits,
          query: event.query,
          isLoading: false,
        ));
      } catch (e) {
        yield SearchError(e);
      }
    }
  }
}
