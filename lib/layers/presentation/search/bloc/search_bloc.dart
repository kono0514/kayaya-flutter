import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/usecase.dart';
import '../../../domain/entities/search_result.dart';
import '../../../domain/usecases/search/get_search_history_usecase.dart';
import '../../../domain/usecases/search/save_search_history_usecase.dart';
import '../../../domain/usecases/search/search_by_text_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

@Injectable()
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchByTextUsecase searchByTextUsecase;
  final GetSearchHistoryUsecase getSearchHistoryUsecase;
  final SaveSearchHistoryUsecase saveSearchHistoryUsecase;

  SearchBloc({
    @required this.searchByTextUsecase,
    @required this.getSearchHistoryUsecase,
    @required this.saveSearchHistoryUsecase,
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
        final _history = await getSearchHistoryUsecase(NoParams());
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

      final result = await searchByTextUsecase(
          SearchByTextUsecaseParams(text: event.query));

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
