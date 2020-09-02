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
      emit(AnimeDetailsLoaded(details));
    } catch (e) {
      emit(AnimeDetailsError(e));
    }
  }
}
