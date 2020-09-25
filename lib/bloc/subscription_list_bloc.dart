import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/repositories/user_data_repository.dart';

part 'subscription_list_event.dart';
part 'subscription_list_state.dart';

class SubscriptionListBloc
    extends Bloc<SubscriptionListEvent, SubscriptionListState> {
  final UserDataRepositry repository;

  SubscriptionListBloc(this.repository) : super(SubscriptionListInitial());

  @override
  Stream<SubscriptionListState> mapEventToState(
    SubscriptionListEvent event,
  ) async* {
    if (event is SubscriptionListFetched) {
      try {
        yield SubscriptionListInitial();

        final subscriptions = await repository.fetchSubscriptions();

        if (subscriptions.length == 0) {
          yield SubscriptionListEmpty();
          return;
        }

        yield SubscriptionListLoaded(subscriptions: subscriptions);
      } catch (e) {
        yield (SubscriptionListError(e));
      }
    }
  }
}
