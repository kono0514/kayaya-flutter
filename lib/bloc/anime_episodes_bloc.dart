import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

part 'anime_episodes_event.dart';
part 'anime_episodes_state.dart';

class AnimeEpisodesBloc extends Bloc<AnimeEpisodesEvent, AnimeEpisodesState> {
  final AniimRepository repository;

  AnimeEpisodesBloc(this.repository) : super(AnimeEpisodesInitial());

  @override
  Stream<Transition<AnimeEpisodesEvent, AnimeEpisodesState>> transformEvents(
      Stream<AnimeEpisodesEvent> events, transitionFn) {
    final forwardStream =
        events.where((event) => event is! AnimeEpisodesFetched);

    final debounceStream = events
        .where((event) => event is AnimeEpisodesFetched)
        .debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
        MergeStream([forwardStream, debounceStream]), transitionFn);
  }

  @override
  Stream<AnimeEpisodesState> mapEventToState(
    AnimeEpisodesEvent event,
  ) async* {
    final currentState = state;

    if (event is AnimeEpisodesRefreshed) {
      try {
        yield AnimeEpisodesInitial();

        final episodes = await repository.fetchEpisodes(event.id,
            page: 1, sortOrder: event.sortOrder ?? SortOrder.asc);

        if (episodes.paginatorInfo.total == 0) {
          yield AnimeEpisodesEmpty();
          return;
        }

        yield AnimeEpisodesLoaded(
          episodes: episodes.data,
          paginatorInfo: episodes.paginatorInfo,
          sortOrder: event.sortOrder ?? SortOrder.asc,
        );
      } catch (e) {
        yield AnimeEpisodesError(e);
      }
    } else if (event is AnimeEpisodesFetched) {
      if (currentState is AnimeEpisodesLoaded) {
        if (!currentState.paginatorInfo.hasMorePages) return;

        if (currentState.error != null) {
          yield currentState.copyWith(
            error: Optional.absent(),
          );
        }
      }

      try {
        int page = 1;
        SortOrder sortOrder = event.sortOrder ?? SortOrder.asc;
        if (currentState is AnimeEpisodesLoaded) {
          page = currentState.paginatorInfo.currentPage + 1;
          sortOrder = currentState.sortOrder;
        }

        final episodes = await repository.fetchEpisodes(event.id,
            page: page, sortOrder: sortOrder);

        if (episodes.paginatorInfo.total == 0) {
          yield AnimeEpisodesEmpty();
          return;
        }

        if (currentState is AnimeEpisodesLoaded) {
          yield AnimeEpisodesLoaded(
            episodes: currentState.episodes + episodes.data,
            paginatorInfo: episodes.paginatorInfo,
            sortOrder: sortOrder,
          );
        } else {
          yield AnimeEpisodesLoaded(
            episodes: episodes.data,
            paginatorInfo: episodes.paginatorInfo,
            sortOrder: sortOrder,
          );
        }
      } catch (e) {
        if (currentState is AnimeEpisodesLoaded) {
          yield currentState.copyWith(
            error: Optional.of(e),
          );
        } else {
          yield AnimeEpisodesError(e);
        }
      }
    }
  }
}
