// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:algolia/algolia.dart';
import 'package:hive/hive.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'layers/data/datasources/anime_local_datasource.dart';
import 'layers/datasources/anime_local_datasource_memory_impl.dart';
import 'layers/data/datasources/anime_network_datasource.dart';
import 'layers/datasources/anime_network_datasource_kayaya_impl.dart';
import 'layers/domain/repositories/anime_repository.dart';
import 'layers/data/repositories/anime_repository_impl.dart';
import 'layers/domain/repositories/authentication_repository.dart';
import 'layers/data/repositories/firebase_authentication_repository_impl.dart';
import 'layers/presentation/authentication/bloc/authentication_bloc.dart';
import 'layers/presentation/browse/bloc/browse_bloc.dart';
import 'layers/presentation/browse/cubit/browse_filter_cubit.dart';
import 'layers/domain/usecases/subscription/check_subscription_usecase.dart';
import 'layers/domain/usecases/search/clear_search_history_usecase.dart';
import 'layers/data/datasources/detail_local_datasource.dart';
import 'layers/datasources/detail_local_datasource_memory_impl.dart';
import 'layers/data/datasources/detail_network_datasource.dart';
import 'layers/datasources/detail_network_datasource_kayaya_impl.dart';
import 'layers/domain/repositories/detail_repository.dart';
import 'layers/data/repositories/detail_repository_impl.dart';
import 'layers/presentation/detail/cubit/details_cubit.dart';
import 'layers/presentation/detail/bloc/episodes_bloc.dart';
import 'layers/presentation/featured/cubit/featured_cubit.dart';
import 'layers/presentation/genre/cubit/genre_list_cubit.dart';
import 'layers/domain/usecases/anime/get_animes_usecase.dart';
import 'layers/domain/usecases/detail/get_detail_usecase.dart';
import 'layers/domain/usecases/detail/get_detail_with_anime_usecase.dart';
import 'layers/domain/usecases/detail/get_episode_page_info.dart';
import 'layers/domain/usecases/detail/get_episodes_usecase.dart';
import 'layers/domain/usecases/anime/get_featured_usecase.dart';
import 'layers/domain/usecases/anime/get_genres_usecase.dart';
import 'layers/domain/usecases/authentication/get_id_token_usecase.dart';
import 'layers/domain/usecases/detail/get_relations_usecase.dart';
import 'layers/domain/usecases/search/get_search_history_usecase.dart';
import 'layers/domain/usecases/subscription/get_subscriptions_usecase.dart';
import 'layers/domain/usecases/authentication/get_user_stream_usecase.dart';
import 'core/in_memory_cache.dart';
import 'layers/domain/usecases/authentication/is_logged_in_usecase.dart';
import 'layers/presentation/locale/cubit/locale_cubit.dart';
import 'layers/presentation/login/cubit/login_cubit.dart';
import 'layers/domain/usecases/authentication/login_with_anonymous_usecase.dart';
import 'layers/domain/usecases/authentication/login_with_facebook_usecase.dart';
import 'layers/domain/usecases/authentication/login_with_google_usecase.dart';
import 'layers/domain/usecases/authentication/login_with_password_usecase.dart';
import 'layers/domain/usecases/authentication/logout_usecase.dart';
import 'core/services/notification_service.dart';
import 'layers/presentation/player/bloc/player_episodes_bloc.dart';
import 'core/services/preferences_service.dart';
import 'injection.dart';
import 'layers/presentation/detail/cubit/relations_cubit.dart';
import 'layers/domain/usecases/search/save_search_history_usecase.dart';
import 'layers/presentation/search/bloc/search_bloc.dart';
import 'layers/domain/usecases/search/search_by_text_usecase.dart';
import 'layers/data/datasources/search_local_datasource.dart';
import 'layers/datasources/search_local_datasource_impl.dart';
import 'layers/data/datasources/search_network_datasource.dart';
import 'layers/datasources/search_network_datasource_algolia_impl.dart';
import 'layers/domain/repositories/search_repository.dart';
import 'layers/data/repositories/search_repository_impl.dart';
import 'layers/domain/usecases/authentication/send_phone_code_usecase.dart';
import 'layers/domain/usecases/subscription/subscribe_to_series_usecase.dart';
import 'layers/presentation/detail/cubit/subscription_cubit.dart';
import 'layers/presentation/library/cubit/subscription_list_cubit.dart';
import 'layers/data/datasources/subscription_network_datasource.dart';
import 'layers/datasources/subscription_network_datasource_kayaya_impl.dart';
import 'layers/domain/repositories/subscription_repository.dart';
import 'layers/data/repositories/subscription_repository_impl.dart';
import 'layers/presentation/theme/cubit/theme_cubit.dart';
import 'layers/domain/usecases/subscription/unsubscribe_from_series_usecase.dart';
import 'layers/presentation/updater/cubit/updater_cubit.dart';
import 'layers/domain/usecases/authentication/verify_phone_code_usecase.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

Future<GetIt> $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) async {
  final gh = GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<Algolia>(() => registerModule.algolia);
  final box = await registerModule.animeBox;
  gh.factory<Box<dynamic>>(() => box, instanceName: 'animeBox');
  final box1 = await registerModule.preferencesBox;
  gh.factory<Box<dynamic>>(() => box1, instanceName: 'preferencesBox');
  gh.factory<BrowseFilterCubit>(() => BrowseFilterCubit());
  gh.factory<FacebookAuth>(() => registerModule.facebookAuth);
  gh.factory<FirebaseAuth>(() => registerModule.firebaseAuth);
  gh.factory<GoogleSignIn>(() => registerModule.googleAuth);
  gh.lazySingleton<GraphQLClient>(() => registerModule.gqlClient);
  gh.lazySingleton<NotificationService>(
      () => registerModule.notificationService);
  gh.factory<PreferencesDatasource>(() => HivePreferencesDatasource(
      hiveBox: get<Box<dynamic>>(instanceName: 'preferencesBox')));
  gh.factory<PreferencesService>(
      () => PreferencesService(dataSource: get<PreferencesDatasource>()));
  gh.factory<SearchLocalDatasource>(
      () => SearchLocalDatasourceImpl(pref: get<PreferencesService>()));
  gh.factory<SearchNetworkDatasource>(() => SearchNetworkDatasourceAlgoliaImpl(
      algolia: get<Algolia>(), pref: get<PreferencesService>()));
  gh.factory<SearchRepository>(() => SearchRepositoryImpl(
      localDatasource: get<SearchLocalDatasource>(),
      networkDatasource: get<SearchNetworkDatasource>()));
  gh.factory<SubscriptionNetworkDatasource>(() =>
      SubscriptionNetworkDatasourceKayayaImpl(graphql: get<GraphQLClient>()));
  gh.factory<SubscriptionRepository>(() => SubscriptionRepositoryImpl(
      networkDatasource: get<SubscriptionNetworkDatasource>()));
  gh.factory<ThemeCubit>(() => ThemeCubit(pref: get<PreferencesService>()));
  gh.factory<UnsubscribeFromSeriesUsecase>(() => UnsubscribeFromSeriesUsecase(
      subscriptionRepository: get<SubscriptionRepository>()));
  gh.factory<UpdaterCubit>(() => UpdaterCubit(pref: get<PreferencesService>()));
  gh.factory<AnimeLocalDatasource>(
      () => AnimeLocalDatasourceMemoryImpl(memoryCache: get<InMemoryCache>()));
  gh.factory<AnimeNetworkDatasource>(
      () => AnimeNetworkDatasourceKayayaImpl(graphql: get<GraphQLClient>()));
  gh.factory<AnimeRepository>(() => AnimeRepositoryImpl(
      localDatasource: get<AnimeLocalDatasource>(),
      networkDatasource: get<AnimeNetworkDatasource>()));
  gh.factory<AuthRepository>(() => AuthRepositoryFirebaseImpl(
        firebaseAuth: get<FirebaseAuth>(),
        googleAuth: get<GoogleSignIn>(),
        facebookAuth: get<FacebookAuth>(),
      ));
  gh.factory<CheckSubscriptionUsecase>(() => CheckSubscriptionUsecase(
      subscriptionRepository: get<SubscriptionRepository>()));
  gh.factory<ClearSearchHistoryUsecase>(
      () => ClearSearchHistoryUsecase(searchRepo: get<SearchRepository>()));
  gh.factory<DetailLocalDatasource>(
      () => DetailLocalDatasourceMemoryImpl(memoryCache: get<InMemoryCache>()));
  gh.factory<DetailNetworkDatasource>(
      () => DetailNetworkDatasourceKayayaImpl(graphql: get<GraphQLClient>()));
  gh.factory<DetailRepository>(() => DetailRepositoryImpl(
      localDatasource: get<DetailLocalDatasource>(),
      networkDatasource: get<DetailNetworkDatasource>()));
  gh.factory<GetAnimesUsecase>(
      () => GetAnimesUsecase(animeRepository: get<AnimeRepository>()));
  gh.factory<GetDetailUsecase>(
      () => GetDetailUsecase(detailRepository: get<DetailRepository>()));
  gh.factory<GetDetailWithAnimeUsecase>(() =>
      GetDetailWithAnimeUsecase(detailRepository: get<DetailRepository>()));
  gh.factory<GetEpisodePageInfoUsecase>(() =>
      GetEpisodePageInfoUsecase(detailRepository: get<DetailRepository>()));
  gh.factory<GetEpisodesUsecase>(
      () => GetEpisodesUsecase(detailRepository: get<DetailRepository>()));
  gh.factory<GetFeaturedUsecase>(
      () => GetFeaturedUsecase(animeRepository: get<AnimeRepository>()));
  gh.factory<GetGenresUsecase>(
      () => GetGenresUsecase(animeRepository: get<AnimeRepository>()));
  gh.factory<GetIdTokenUsecase>(
      () => GetIdTokenUsecase(authRepo: get<AuthRepository>()));
  gh.factory<GetRelationsUsecase>(
      () => GetRelationsUsecase(detailRepository: get<DetailRepository>()));
  gh.factory<GetSearchHistoryUsecase>(
      () => GetSearchHistoryUsecase(searchRepo: get<SearchRepository>()));
  gh.factory<GetSubscriptionsUsecase>(() => GetSubscriptionsUsecase(
      subscriptionRepository: get<SubscriptionRepository>()));
  gh.factory<GetUserStreamUsecase>(
      () => GetUserStreamUsecase(authRepo: get<AuthRepository>()));
  gh.factory<IsLoggedInUsecase>(
      () => IsLoggedInUsecase(authRepo: get<AuthRepository>()));
  gh.factory<LocaleCubit>(() => LocaleCubit(pref: get<PreferencesService>()));
  gh.factory<LoginWithAnonymousUsecase>(
      () => LoginWithAnonymousUsecase(authRepo: get<AuthRepository>()));
  gh.factory<LoginWithFacebookUsecase>(
      () => LoginWithFacebookUsecase(authRepo: get<AuthRepository>()));
  gh.factory<LoginWithGoogleUsecase>(
      () => LoginWithGoogleUsecase(authRepo: get<AuthRepository>()));
  gh.factory<LoginWithPasswordUsecase>(
      () => LoginWithPasswordUsecase(authRepo: get<AuthRepository>()));
  gh.factory<LogoutUsecase>(
      () => LogoutUsecase(authRepo: get<AuthRepository>()));
  gh.factoryParam<PlayerEpisodesBloc, String, int>(
      (id, startingEpisode) => PlayerEpisodesBloc(
            getEpisodesUsecase: get<GetEpisodesUsecase>(),
            getEpisodePageInfoUsecase: get<GetEpisodePageInfoUsecase>(),
            id: id,
            startingEpisode: startingEpisode,
          ));
  gh.factory<RelationsCubit>(
      () => RelationsCubit(getRelationsUsecase: get<GetRelationsUsecase>()));
  gh.factory<SaveSearchHistoryUsecase>(
      () => SaveSearchHistoryUsecase(searchRepo: get<SearchRepository>()));
  gh.factory<SearchByTextUsecase>(
      () => SearchByTextUsecase(searchRepo: get<SearchRepository>()));
  gh.factory<SendPhoneCodeUsecase>(
      () => SendPhoneCodeUsecase(authRepo: get<AuthRepository>()));
  gh.factory<SubscribeToSeriesUsecase>(() => SubscribeToSeriesUsecase(
      subscriptionRepository: get<SubscriptionRepository>()));
  gh.factoryParam<SubscriptionCubit, SubscriptionListCubit, dynamic>(
      (subscriptionListCubit, _) => SubscriptionCubit(
            subscribeToSeriesUsecase: get<SubscribeToSeriesUsecase>(),
            unsubscribeFromSeriesUsecase: get<UnsubscribeFromSeriesUsecase>(),
            checkSubscriptionUsecase: get<CheckSubscriptionUsecase>(),
            subscriptionListCubit: subscriptionListCubit,
          ));
  gh.factory<SubscriptionListCubit>(() => SubscriptionListCubit(
      getSubscriptionsUsecase: get<GetSubscriptionsUsecase>()));
  gh.factory<VerifyPhoneCodeUsecase>(
      () => VerifyPhoneCodeUsecase(authRepo: get<AuthRepository>()));
  gh.factory<AuthenticationBloc>(() => AuthenticationBloc(
      getUserStreamUsecase: get<GetUserStreamUsecase>(),
      logoutUsecase: get<LogoutUsecase>()));
  gh.factoryParam<BrowseBloc, BrowseFilterCubit, dynamic>((filterCubit, _) =>
      BrowseBloc(
          getAnimesUsecase: get<GetAnimesUsecase>(), filterCubit: filterCubit));
  gh.factory<DetailsCubit>(() => DetailsCubit(
      getDetailUsecase: get<GetDetailUsecase>(),
      getDetailWithAnimeUsecase: get<GetDetailWithAnimeUsecase>()));
  gh.factory<EpisodesBloc>(
      () => EpisodesBloc(getEpisodesUsecase: get<GetEpisodesUsecase>()));
  gh.factory<FeaturedCubit>(
      () => FeaturedCubit(getFeatured: get<GetFeaturedUsecase>()));
  gh.factory<GenreListCubit>(() => GenreListCubit(get<GetGenresUsecase>()));
  gh.factory<LoginCubit>(() => LoginCubit(
        loginWithGoogleUsecase: get<LoginWithGoogleUsecase>(),
        loginWithFacebookUsecase: get<LoginWithFacebookUsecase>(),
        loginWithAnonymousUsecase: get<LoginWithAnonymousUsecase>(),
      ));
  gh.factory<SearchBloc>(() => SearchBloc(
        searchByTextUsecase: get<SearchByTextUsecase>(),
        getSearchHistoryUsecase: get<GetSearchHistoryUsecase>(),
        saveSearchHistoryUsecase: get<SaveSearchHistoryUsecase>(),
      ));

  // Eager singletons must be registered in the right order
  gh.singleton<InMemoryCache>(InMemoryCache());
  return get;
}

class _$RegisterModule extends RegisterModule {}
