import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../../../../core/paged_list.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/usecases/subscription/get_subscriptions_usecase.dart';

part 'subscription_list_state.dart';

@Injectable()
class SubscriptionListCubit extends Cubit<SubscriptionListState> {
  final GetSubscriptionsUsecase getSubscriptionsUsecase;

  SubscriptionListCubit({@required this.getSubscriptionsUsecase})
      : super(SubscriptionListInitial());

  Future<void> loadSubscriptions() async {
    final currentState = state;

    if (currentState is SubscriptionListLoaded) {
      if (!currentState.subscriptions.hasMorePages) return;

      if (currentState.error != null) {
        emit(currentState.copyWith(
          error: const Optional.absent(),
        ));
      }
    }

    int page = 1;
    if (currentState is SubscriptionListLoaded) {
      page = currentState.subscriptions.currentPage + 1;
    }

    final result =
        await getSubscriptionsUsecase(GetSubscriptionsUsecaseParams(page));
    result.fold((l) {
      if (currentState is SubscriptionListLoaded) {
        emit(currentState.copyWith(
          error: Optional.of(l.message),
        ));
      } else {
        emit(SubscriptionListError(l.message));
      }
    }, (r) {
      if (r.total == 0) {
        emit(const SubscriptionListEmpty());
        return;
      }

      if (currentState is SubscriptionListLoaded) {
        emit(SubscriptionListLoaded(
          subscriptions: r.copyWith(
            elements: currentState.subscriptions.elements + r.elements,
          ),
        ));
      } else {
        emit(SubscriptionListLoaded(
          subscriptions: r,
        ));
      }
    });
  }

  Future<void> refreshSubscriptions() async {
    emit(SubscriptionListInitial());

    final result =
        await getSubscriptionsUsecase(GetSubscriptionsUsecaseParams(1));
    result.fold(
      (l) => emit(SubscriptionListError(l.message)),
      (r) {
        if (r.total == 0) {
          emit(const SubscriptionListEmpty());
        } else {
          emit(SubscriptionListLoaded(subscriptions: r));
        }
      },
    );
  }

  void addSubscriptionItem(Anime anime) {
    if (state is SubscriptionListEmpty) {
      emit(SubscriptionListLoaded(
        subscriptions: PagedList<Anime>(
          elements: <Anime>[anime],
          total: 2,
          currentPage: 1,
          hasMorePages: false,
        ),
      ));
    }

    if (state is SubscriptionListLoaded) {
      final currentState = state as SubscriptionListLoaded;
      // final elements = List.of(currentState.subscriptions.elements);

      // // Insert at the beginning
      // elements.removeWhere((e) => e.id == anime.id);
      // elements.insert(0, anime);
      emit(
        currentState.copyWith(
          subscriptions: currentState.subscriptions.copyWith(
            elements: currentState.subscriptions.elements
                .where((e) => e.id != anime.id)
                .toList()
                  ..insert(0, anime),
          ),
        ),
      );
    }
  }

  void removeSubscriptionItem(Anime anime) {
    if (state is! SubscriptionListLoaded) return;

    final currentState = state as SubscriptionListLoaded;

    final filteredElements = currentState.subscriptions.elements
        .where((e) => e.id != anime.id)
        .toList();

    if (filteredElements.isEmpty) {
      emit(const SubscriptionListEmpty());
    } else {
      emit(
        currentState.copyWith(
          subscriptions: currentState.subscriptions.copyWith(
            elements: filteredElements,
          ),
        ),
      );
    }
  }
}
