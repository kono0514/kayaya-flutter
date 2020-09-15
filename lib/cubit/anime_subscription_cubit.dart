import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/repository.dart';

part 'anime_subscription_state.dart';

class AnimeSubscriptionCubit extends Cubit<AnimeSubscriptionState> {
  final AniimRepository repository;

  AnimeSubscriptionCubit(this.repository) : super(AnimeSubscriptionInitial());

  void assignData(String id, bool subscribed) {
    emit(AnimeSubscriptionLoaded(id, subscribed));
  }

  void subscribe() async {
    final currentState = state;

    if (currentState is AnimeSubscriptionLoaded) {
      try {
        emit(AnimeSubscriptionChanging());
        final success = await repository.subscribeTo(currentState.id);
        if (success) {
          emit(AnimeSubscriptionLoaded(currentState.id, success));
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
          emit(AnimeSubscriptionLoaded(currentState.id, false));
        }
      } catch (e) {
        //
      }
    }
  }
}
