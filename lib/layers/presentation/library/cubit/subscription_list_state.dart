part of 'subscription_list_cubit.dart';

abstract class SubscriptionListState extends Equatable {
  const SubscriptionListState();

  @override
  List<Object> get props => [];
}

class SubscriptionListInitial extends SubscriptionListState {}

class SubscriptionListLoaded extends SubscriptionListState {
  final PagedList<Anime> subscriptions;
  final String error;

  const SubscriptionListLoaded({
    this.subscriptions,
    this.error,
  });

  SubscriptionListLoaded copyWith({
    PagedList<Anime> subscriptions,
    Optional<String> error,
  }) {
    return SubscriptionListLoaded(
      subscriptions: subscriptions ?? this.subscriptions,
      error: error != null ? error.orNull : this.error,
    );
  }

  @override
  List<Object> get props => [subscriptions, error];
}

class SubscriptionListError extends SubscriptionListState {
  final String error;

  const SubscriptionListError(this.error);

  @override
  List<Object> get props => [error];
}

class SubscriptionListEmpty extends SubscriptionListState {
  const SubscriptionListEmpty();
}
