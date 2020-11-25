import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/utils/logger.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

import '../browse.dart';

part 'browse_event.dart';
part 'browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final AniimRepository repository;
  final BrowseFilterCubit filterCubit;

  BrowseBloc(this.repository, this.filterCubit) : super(BrowseInitial()) {
    filterCubit.listen((filterState) {
      logger.wtf(
          'BrowseBloc: BrowseFilterModified emitted. Will now trigger BrowseRefreshed');
      add(BrowseRefreshed());
    });
  }

  Filter _getCurrentFilterFromState(BrowseFilterState state) {
    if (state is BrowseFilterInitial) {
      return state.filter;
    } else if (state is BrowseFilterModified) {
      return state.filter;
    }
    return null;
  }

  @override
  Stream<Transition<BrowseEvent, BrowseState>> transformEvents(
      Stream<BrowseEvent> events, transitionFn) {
    final forwardStream = events.where((event) => event is! BrowseFetched);

    final debounceStream = events
        .where((event) => event is BrowseFetched)
        .debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
        MergeStream([forwardStream, debounceStream]), transitionFn);
  }

  @override
  Stream<BrowseState> mapEventToState(
    BrowseEvent event,
  ) async* {
    final currentState = state;

    if (event is BrowseRefreshed) {
      try {
        // if (currentState is! BrowseLoaded) {
        yield BrowseInitial();
        // }
        Filter filter = _getCurrentFilterFromState(filterCubit.state);

        final animes = await repository.fetchAnimes(page: 1, filter: filter);

        if (animes.data.length == 0) {
          yield BrowseEmpty();
          return;
        }

        yield BrowseLoaded(
          animes: animes.data,
          paginatorInfo: animes.paginatorInfo,
          timestamp: DateTime.now().toString(),
        );
      } catch (e) {
        yield BrowseError(e);
      }
    } else if (event is BrowseFetched) {
      if (currentState is BrowseLoaded) {
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
        if (currentState is BrowseLoaded) {
          page = currentState.paginatorInfo.currentPage + 1;
        }

        final animes = await repository.fetchAnimes(page: page, filter: filter);

        if (animes.data.length == 0) {
          yield BrowseEmpty();
          return;
        }

        if (currentState is BrowseLoaded) {
          yield BrowseLoaded(
            animes: currentState.animes + animes.data,
            paginatorInfo: animes.paginatorInfo,
            timestamp: DateTime.now().toString(),
          );
        } else {
          yield BrowseLoaded(
            animes: animes.data,
            paginatorInfo: animes.paginatorInfo,
            timestamp: DateTime.now().toString(),
          );
        }
      } catch (e) {
        if (currentState is BrowseLoaded) {
          yield currentState.copyWith(
            error: Optional.of(e),
            timestamp: DateTime.now().toString(),
          );
        } else {
          yield BrowseError(e);
        }
      }
    }
  }
}
