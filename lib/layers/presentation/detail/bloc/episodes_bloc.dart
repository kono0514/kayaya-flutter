import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/paged_list.dart';
import '../../../domain/entities/episode.dart';
import '../../../domain/usecases/detail/get_episodes_usecase.dart';

part 'episodes_event.dart';
part 'episodes_state.dart';

@Injectable()
class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final GetEpisodesUsecase getEpisodesUsecase;

  EpisodesBloc({@required this.getEpisodesUsecase}) : super(EpisodesInitial());

  @override
  Stream<Transition<EpisodesEvent, EpisodesState>> transformEvents(
      Stream<EpisodesEvent> events, transitionFn) {
    final forwardStream = events.where((event) => event is! EpisodesFetched);

    final debounceStream = events
        .where((event) => event is EpisodesFetched)
        .debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
        MergeStream([forwardStream, debounceStream]), transitionFn);
  }

  @override
  Stream<EpisodesState> mapEventToState(
    EpisodesEvent event,
  ) async* {
    final currentState = state;

    if (event is EpisodesRefreshed) {
      yield EpisodesInitial();

      final result = await getEpisodesUsecase(GetEpisodesUsecaseParams(
        id: event.id,
        page: 1,
        order: event.sortOrder ?? 'asc',
      ));
      yield* result.fold(
        (l) async* {
          yield EpisodesError(l.message);
        },
        (r) async* {
          if (r.total == 0) {
            yield EpisodesEmpty();
          } else {
            yield EpisodesLoaded(
              episodes: r,
              sortOrder: event.sortOrder ?? 'asc',
            );
          }
        },
      );
    } else if (event is EpisodesFetched) {
      if (currentState is EpisodesLoaded) {
        if (!currentState.episodes.hasMorePages) return;

        if (currentState.error != null) {
          yield currentState.copyWith(
            error: Optional.absent(),
          );
        }
      }

      int page = 1;
      String sortOrder = event.sortOrder ?? 'asc';
      if (currentState is EpisodesLoaded) {
        page = currentState.episodes.currentPage + 1;
        sortOrder = currentState.sortOrder;
      }

      final result = await getEpisodesUsecase(GetEpisodesUsecaseParams(
        id: event.id,
        page: page,
        order: sortOrder,
      ));
      yield* result.fold((l) async* {
        if (currentState is EpisodesLoaded) {
          yield currentState.copyWith(
            error: Optional.of(l.message),
          );
        } else {
          yield EpisodesError(l.message);
        }
      }, (r) async* {
        if (r.total == 0) {
          yield EpisodesEmpty();
          return;
        }

        if (currentState is EpisodesLoaded) {
          yield EpisodesLoaded(
            episodes: r.copyWith(
              elements: currentState.episodes.elements + r.elements,
            ),
            sortOrder: sortOrder,
          );
        } else {
          yield EpisodesLoaded(
            episodes: r,
            sortOrder: sortOrder,
          );
        }
      });
    }
  }
}
