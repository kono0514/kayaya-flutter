part of 'subscription_list_bloc.dart';

abstract class SubscriptionListState extends Equatable {
  const SubscriptionListState();

  @override
  List<Object> get props => [];
}

class SubscriptionListInitial extends SubscriptionListState {
  const SubscriptionListInitial();
}

class SubscriptionListLoaded extends SubscriptionListState {
  final List<GetSubscriptions$Query$Subscriptions> subscriptions;

  const SubscriptionListLoaded({
    this.subscriptions,
  });

  @override
  List<Object> get props => [subscriptions];
}

class SubscriptionListError extends SubscriptionListState {
  final Exception exception;

  const SubscriptionListError(this.exception);

  @override
  List<Object> get props => [exception];
}

class SubscriptionListEmpty extends SubscriptionListState {
  const SubscriptionListEmpty();
}
