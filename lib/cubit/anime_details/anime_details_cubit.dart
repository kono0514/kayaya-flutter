import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/repository.dart';

part 'anime_details_state.dart';

class AnimeDetailsCubit extends Cubit<AnimeDetailsState> {
  final AniimRepository repository;

  AnimeDetailsCubit(this.repository) : super(AnimeDetailsInitial());

  void loadDetails(String id) async {
    emit(AnimeDetailsInitial());

    try {
      final details = await repository.fetchDetails(id);
      if (details == null) {
        throw Exception('Not found');
      }
      emit(AnimeDetailsLoaded(details: details));
    } catch (e) {
      emit(AnimeDetailsError(e));
    }
  }

  void loadDetailsFull(String id) async {
    emit(AnimeDetailsInitial());

    try {
      final detailsFull = await repository.fetchDetailsFull(id);
      if (detailsFull == null) {
        throw Exception('Not found');
      }
      final details =
          GetAnimeDetails$Query$Anime.fromJson(detailsFull.toJson());
      final listData =
          BrowseAnimes$Query$Animes$Data.fromJson(detailsFull.toJson());
      emit(AnimeDetailsLoaded(
          details: details, hasListData: true, listData: listData));
    } catch (e) {
      emit(AnimeDetailsError(e));
    }
  }
}
