part of 'subscription_cubit.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

class SubscriptionInitialized extends SubscriptionState {
  const SubscriptionInitialized();
}

class SubscriptionLoaded extends SubscriptionState {
  final bool subscribed;
  final bool isDirty;

  const SubscriptionLoaded(this.subscribed, this.isDirty);

  @override
  List<Object> get props => [subscribed, isDirty];
}

class SubscriptionChanging extends SubscriptionState {
  const SubscriptionChanging();
}
