import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:meta/meta.dart';

part 'animes_state.dart';

class AnimesCubit extends Cubit<AnimesState> {
  final GraphQLClient client;

  AnimesCubit(this.client) : super(AnimesInitialState());

  void getAnimesNextPage() async {
    if (state is AnimesLoadedState &&
        (state as AnimesLoadedState).paginatorInfo.hasMorePages == false) {
      return;
    }

    try {
      print('Fetching next page. Current state is ${state.runtimeType}');
      int page = 1;
      if (state is AnimesLoadedState) {
        page = (state as AnimesLoadedState).paginatorInfo.currentPage + 1;
      }
      print('Next page is: ${page}');

      final _options = QueryOptions(
        documentNode: BrowseAnimesQuery().document,
        variables: BrowseAnimesArguments(
          first: 10,
          page: page,
          orderBy: [],
        ).toJson(),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      );
      final result = await client.query(_options);

      if (result.hasException) {
        throw result.exception;
      }

      final resultData = BrowseAnimes$Query.fromJson(result.data).animes;
      final animes = resultData.data;
      final paginatorInfo = resultData.paginatorInfo;

      if (state is AnimesLoadedState) {
        emit(AnimesLoadedState(
            animes + (state as AnimesLoadedState).animes, paginatorInfo));
      } else {
        emit(AnimesLoadedState(animes, paginatorInfo));
      }
    } catch (e) {
      emit(AnimesErrorState(e));
    }
  }
}
