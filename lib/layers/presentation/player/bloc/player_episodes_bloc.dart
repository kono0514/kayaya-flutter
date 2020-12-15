import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/paged_list.dart';
import '../../../domain/entities/episode.dart';
import '../../../domain/usecases/detail/get_episode_page_info.dart';
import '../../../domain/usecases/detail/get_episodes_usecase.dart';

part 'player_episodes_event.dart';
part 'player_episodes_state.dart';

@Injectable()
class PlayerEpisodesBloc
    extends Bloc<PlayerEpisodesEvent, PlayerEpisodesState> {
  final GetEpisodesUsecase getEpisodesUsecase;
  final GetEpisodePageInfoUsecase getEpisodePageInfoUsecase;
  final String id;
  final int startingEpisode;
  int startingPage;

  PlayerEpisodesBloc({
    @required this.getEpisodesUsecase,
    @required this.getEpisodePageInfoUsecase,
    @factoryParam @required this.id,
    @factoryParam @required this.startingEpisode,
  }) : super(PlayerEpisodesInitial());

  @override
  Stream<Transition<PlayerEpisodesEvent, PlayerEpisodesState>> transformEvents(
      Stream<PlayerEpisodesEvent> events, transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<PlayerEpisodesState> mapEventToState(
    PlayerEpisodesEvent event,
  ) async* {
    final currentState = state;

    if (event is! PlayerEpisodesFetchNext &&
        event is! PlayerEpisodesFetchPrevious) return;

    if (startingPage == null) {
      try {
        await resolvePageNumberForEpisode();
      } on Exception catch (e) {
        yield PlayerEpisodesError(e.toString());
        return;
      }
    }

    // Assign the correct page to fetch next, if any.
    int page = startingPage;
    if (currentState is PlayerEpisodesLoaded) {
      if (event is PlayerEpisodesFetchPrevious) {
        if (currentState.negativeEpisodes != null) {
          page = currentState.negativeEpisodes.currentPage - 1;
        } else if (currentState.positiveEpisodes != null) {
          // Starting page already fetched
          page -= 1;
        }
        if (page < 1) return;
      }
      if (event is PlayerEpisodesFetchNext) {
        if (currentState.positiveEpisodes != null) {
          if (!currentState.hasMorePositiveEpisodes) return;
          page = currentState.positiveEpisodes.currentPage + 1;
        }
      }
    }

    // Clear any previous error
    if (currentState is PlayerEpisodesLoaded) {
      if (currentState.negativeError != null ||
          currentState.positiveError != null) {
        yield currentState.copyWith(
          negativeError: Optional.absent(),
          positiveError: Optional.absent(),
        );
      }
    }

    final result = await getEpisodesUsecase(GetEpisodesUsecaseParams(
      id: id,
      page: page,
      order: 'asc',
    ));

    yield* result.fold((l) async* {
      if (currentState is PlayerEpisodesLoaded) {
        yield currentState.copyWith(
          negativeError: event is PlayerEpisodesFetchPrevious
              ? Optional.of(l.message)
              : currentState.negativeError,
          positiveError: event is PlayerEpisodesFetchNext
              ? Optional.of(l.message)
              : currentState.positiveError,
        );
      } else {
        yield PlayerEpisodesError(l.message);
      }
    }, (r) async* {
      if (r.total == 0) {
        yield PlayerEpisodesEmpty();
        return;
      }

      if (event is PlayerEpisodesFetchPrevious) {
        if (currentState is PlayerEpisodesLoaded) {
          yield currentState.copyWith(
            negativeEpisodes: r.copyWith(
              elements: currentState.negativeEpisodes == null
                  ? r.elements.reversed.toList()
                  : currentState.negativeEpisodes.elements +
                      r.elements.reversed.toList(),
            ),
          );
        } else {
          yield PlayerEpisodesLoaded(
            negativeEpisodes: r.copyWith(
              elements: r.elements.reversed.toList(),
            ),
            startingPage: startingPage,
          );
        }
      } else if (event is PlayerEpisodesFetchNext) {
        if (currentState is PlayerEpisodesLoaded) {
          yield currentState.copyWith(
            positiveEpisodes: currentState.positiveEpisodes == null
                ? r.elements
                : r.copyWith(
                    elements:
                        currentState.positiveEpisodes.elements + r.elements,
                  ),
          );
        } else {
          yield PlayerEpisodesLoaded(
            positiveEpisodes: r,
            startingPage: startingPage,
          );
        }
      }
    });
  }

  Future<void> resolvePageNumberForEpisode() async {
    if (startingEpisode <= 30) {
      startingPage = 1;
      return;
    }

    final result = await getEpisodePageInfoUsecase(
        GetEpisodePageInfoUsecaseParams(id: id, number: startingEpisode));

    return result.fold(
      (l) => throw Exception('Failed to get page info from episode'),
      (r) => startingPage = r.value1,
    );
  }
}
