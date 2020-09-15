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

  const AnimeSubscriptionLoaded(this.id, this.subscribed);

  @override
  List<Object> get props => [id, subscribed];
}

class AnimeSubscriptionChanging extends AnimeSubscriptionState {
  const AnimeSubscriptionChanging();
}
