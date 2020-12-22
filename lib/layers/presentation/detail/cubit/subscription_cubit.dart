import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/anime.dart';
import '../../../domain/usecases/subscription/check_subscription_usecase.dart';
import '../../../domain/usecases/subscription/subscribe_to_series_usecase.dart';
import '../../../domain/usecases/subscription/unsubscribe_from_series_usecase.dart';
import '../../library/cubit/subscription_list_cubit.dart';

part 'subscription_state.dart';

@Injectable()
class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscribeToSeriesUsecase subscribeToSeriesUsecase;
  final UnsubscribeFromSeriesUsecase unsubscribeFromSeriesUsecase;
  final SubscriptionListCubit subscriptionListCubit;
  final CheckSubscriptionUsecase checkSubscriptionUsecase;
  Anime anime;

  SubscriptionCubit({
    @required this.subscribeToSeriesUsecase,
    @required this.unsubscribeFromSeriesUsecase,
    @required this.checkSubscriptionUsecase,
    @factoryParam @required this.subscriptionListCubit,
  }) : super(SubscriptionInitial());

  void loadData(Anime anime) {
    this.anime = anime;
    emit(SubscriptionInitialized());
  }

  void check() async {
    if (state is SubscriptionInitial) return;

    emit(SubscriptionChanging());
    final result = await checkSubscriptionUsecase(
        CheckSubscriptionUsecaseParams(anime.id));
    result.fold((l) => () {}, (r) => emit(SubscriptionLoaded(r, false)));
  }

  void subscribe() async {
    final currentState = state;

    if (currentState is SubscriptionLoaded) {
      emit(SubscriptionChanging());
      final result = await subscribeToSeriesUsecase(
          SubscribeToSeriesUsecaseParams(anime.id));
      result.fold(
        (l) => () {},
        (r) {
          emit(SubscriptionLoaded(true, true));
          subscriptionListCubit.addSubscriptionItem(anime);
        },
      );
    }
  }

  void unsubscribe() async {
    final currentState = state;

    if (currentState is SubscriptionLoaded) {
      emit(SubscriptionChanging());
      final result = await unsubscribeFromSeriesUsecase(
          UnsubscribeFromSeriesUsecaseParams(anime.id));
      result.fold(
        (l) => () {},
        (r) {
          emit(SubscriptionLoaded(false, true));
          subscriptionListCubit.removeSubscriptionItem(anime);
        },
      );
    }
  }
}
