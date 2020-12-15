import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/paged_list.dart';
import '../../../../core/utils/logger.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/entities/anime_filter.dart';
import '../../../domain/usecases/anime/get_animes_usecase.dart';
import '../cubit/browse_filter_cubit.dart';

part 'browse_event.dart';
part 'browse_state.dart';

@Injectable()
class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final GetAnimesUsecase getAnimesUsecase;
  final BrowseFilterCubit filterCubit;

  BrowseBloc({
    @required this.getAnimesUsecase,
    @factoryParam @required this.filterCubit,
  }) : super(BrowseInitial()) {
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
      // if (currentState is! BrowseLoaded) {
      yield BrowseInitial();
      // }
      Filter filter = _getCurrentFilterFromState(filterCubit.state);

      final result = await getAnimesUsecase(
        GetAnimesUsecaseParams(page: 1, filter: filter),
      );
      yield* result.fold((l) async* {
        yield BrowseError(l.message);
      }, (r) async* {
        if (r.total == 0) {
          yield BrowseEmpty();
        } else {
          yield BrowseLoaded(
            animes: r,
            timestamp: DateTime.now().toString(),
          );
        }
      });
    } else if (event is BrowseFetched) {
      if (currentState is BrowseLoaded) {
        if (!currentState.animes.hasMorePages) return;

        if (currentState.error != null) {
          yield currentState.copyWith(
            error: Optional.absent(),
            timestamp: DateTime.now().toString(),
          );
        }
      }

      int page = 1;
      Filter filter = _getCurrentFilterFromState(filterCubit.state);
      if (currentState is BrowseLoaded) {
        page = currentState.animes.currentPage + 1;
      }

      final result = await getAnimesUsecase(
        GetAnimesUsecaseParams(page: page, filter: filter),
      );
      yield* result.fold(
        (l) async* {
          if (currentState is BrowseLoaded) {
            yield currentState.copyWith(
              error: Optional.of(l.message),
              timestamp: DateTime.now().toString(),
            );
          } else {
            yield BrowseError(l.message);
          }
        },
        (r) async* {
          if (r.total == 0) {
            yield BrowseEmpty();
            return;
          }

          if (currentState is BrowseLoaded) {
            yield BrowseLoaded(
              animes: r.copyWith(
                elements: currentState.animes.elements + r.elements,
              ),
              timestamp: DateTime.now().toString(),
            );
          } else {
            yield BrowseLoaded(
              animes: r,
              timestamp: DateTime.now().toString(),
            );
          }
        },
      );
    }
  }
}
