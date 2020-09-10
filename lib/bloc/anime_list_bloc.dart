import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/cubit/browse_filter_cubit.dart';
import 'package:kayaya_flutter/logger.dart';
import 'package:kayaya_flutter/models/filter.dart';
import 'package:kayaya_flutter/repository.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

part 'anime_list_event.dart';
part 'anime_list_state.dart';

class AnimeListBloc extends Bloc<AnimeListEvent, AnimeListState> {
  final AniimRepository repository;
  final BrowseFilterCubit filterCubit;

  AnimeListBloc(this.repository, this.filterCubit) : super(AnimeListInitial()) {
    filterCubit.listen((filterState) {
      logger.wtf(
          'AnimeListBloc: BrowseFilterModified emitted. Will now trigger AnimeListRefreshed');
      add(AnimeListRefreshed());
    });
  }

  Filter _getCurrentFilterFromState(BrowseFilterState state) {
    if (state is BrowseFilterInitial) {
      return state.filter;
    } else if (state is BrowseFilterModified) {
      return state.filter;
    }
  }

  @override
  Stream<Transition<AnimeListEvent, AnimeListState>> transformEvents(
      Stream<AnimeListEvent> events, transitionFn) {
    final forwardStream = events.where((event) => event is! AnimeListFetched);

    final debounceStream = events
        .where((event) => event is AnimeListFetched)
        .debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
        MergeStream([forwardStream, debounceStream]), transitionFn);
  }

  @override
  Stream<AnimeListState> mapEventToState(
    AnimeListEvent event,
  ) async* {
    final currentState = state;

    if (event is AnimeListRefreshed) {
      try {
        // if (currentState is! AnimeListLoadedState) {
        yield AnimeListInitialState();
        // }
        Filter filter = _getCurrentFilterFromState(filterCubit.state);

        final animes = await repository.fetchAnimes(page: 1, filter: filter);

        if (animes.data.length == 0) {
          yield AnimeListEmptyState();
          return;
        }

        yield AnimeListLoadedState(
          animes: animes.data,
          paginatorInfo: animes.paginatorInfo,
          timestamp: DateTime.now().toString(),
        );
      } catch (e) {
        yield AnimeListErrorState(e);
      }
    } else if (event is AnimeListFetched) {
      if (currentState is AnimeListLoadedState) {
        if (!currentState.paginatorInfo.hasMorePages) return;

        if (currentState.error != null) {
          yield currentState.copyWith(
            error: Optional.absent(),
            timestamp: DateTime.now().toString(),
          );
        }
      }

      try {
        int page = 1;
        Filter filter = _getCurrentFilterFromState(filterCubit.state);
        if (currentState is AnimeListLoadedState) {
          page = currentState.paginatorInfo.currentPage + 1;
        }

        print('fetch page $page');

        final animes = await repository.fetchAnimes(page: page, filter: filter);

        if (animes.data.length == 0) {
          yield AnimeListEmptyState();
          return;
        }

        if (currentState is AnimeListLoadedState) {
          yield AnimeListLoadedState(
            animes: currentState.animes + animes.data,
            paginatorInfo: animes.paginatorInfo,
            timestamp: DateTime.now().toString(),
          );
        } else {
          yield AnimeListLoadedState(
            animes: animes.data,
            paginatorInfo: animes.paginatorInfo,
            timestamp: DateTime.now().toString(),
          );
        }
      } catch (e) {
        if (currentState is AnimeListLoadedState) {
          yield currentState.copyWith(
            error: Optional.of(e),
            timestamp: DateTime.now().toString(),
          );
        } else {
          yield AnimeListErrorState(e);
        }
      }
    }
  }
}
