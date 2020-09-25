part of 'anime_subscription_cubit.dart';

abstract class AnimeSubscriptionState extends Equatable {
  const AnimeSubscriptionState();

  @override
  List<Object> get props => [];
}

class AnimeSubscriptionInitial extends AnimeSubscriptionState {
  const AnimeSubscriptionInitial();
}

class AnimeSubscriptionLoaded extends AnimeSubscriptionState {
  final String id;
  final bool subscribed;
  final bool isDirty;

  const AnimeSubscriptionLoaded(this.id, this.subscribed, this.isDirty);

  @override
  List<Object> get props => [id, subscribed, isDirty];
}

class AnimeSubscriptionChanging extends AnimeSubscriptionState {
  const AnimeSubscriptionChanging();
}
