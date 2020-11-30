import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/usecase.dart';
import '../../domain/entity/search_result.dart';
import '../../domain/usecase/get_search_history.dart';
import '../../domain/usecase/save_search_history.dart';
import '../../domain/usecase/search_by_text.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchByText searchByText;
  final GetSearchHistory getSearchHistory;
  final SaveSearchHistory saveSearchHistory;

  SearchBloc({
    @required this.searchByText,
    @required this.getSearchHistory,
    @required this.saveSearchHistory,
  }) : super(SearchInitial());

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
      if (event.query.trim() == '') {
        final _history = await getSearchHistory(NoParams());
        yield* _history.fold((l) async* {
          yield SearchError(l);
        }, (r) async* {
          yield SearchHistoryLoaded(result: r);
        });
        return;
      }

      if (currentState is SearchLoaded) {
        if (currentState.query == event.query) return;
        yield currentState.copyWith(isLoading: true);
      } else {
        yield SearchLoaded(
          result: [],
          query: event.query,
          isLoading: true,
        );
      }

      final result = await searchByText(SearchByTextParams(text: event.query));

      yield* result.fold(
        (l) async* {
          yield SearchError(l);
        },
        (r) async* {
          yield SearchLoaded(
            result: r,
            query: event.query,
            isLoading: false,
          );
        },
      );
    }
  }
}
