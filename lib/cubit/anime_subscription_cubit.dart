import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';

part 'anime_subscription_state.dart';

class AnimeSubscriptionCubit extends Cubit<AnimeSubscriptionState> {
  final AniimRepository repository;

  AnimeSubscriptionCubit(this.repository) : super(AnimeSubscriptionInitial());

  void assignData(String id, bool subscribed) {
    emit(AnimeSubscriptionLoaded(id, subscribed, false));
  }

  void subscribe() async {
    final currentState = state;

    if (currentState is AnimeSubscriptionLoaded) {
      try {
        emit(AnimeSubscriptionChanging());
        final success = await repository.subscribeTo(currentState.id);
        if (success) {
          emit(AnimeSubscriptionLoaded(currentState.id, success, true));
          // Add to subscription list bloc
        }
      } catch (e) {
        //
      }
    }
  }

  void unsubscribe() async {
    final currentState = state;

    if (currentState is AnimeSubscriptionLoaded) {
      try {
        emit(AnimeSubscriptionChanging());
        final success = await repository.unsubscribeFrom(currentState.id);
        if (success) {
          emit(AnimeSubscriptionLoaded(currentState.id, false, true));
        }
      } catch (e) {
        //
      }
    }
  }
}
