import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';

part 'anime_relations_state.dart';

class AnimeRelationsCubit extends Cubit<AnimeRelationsState> {
  final AniimRepository repository;

  AnimeRelationsCubit(this.repository) : super(AnimeRelationsInitial());

  void loadRelations(String id) async {
    emit(AnimeRelationsInitial());

    try {
      final relations = await repository.fetchRelations(id);
      if (relations == null) {
        throw Exception('Not found');
      }
      emit(
          AnimeRelationsLoaded(relations.relations, relations.recommendations));
    } catch (e) {
      emit(AnimeRelationsError(e));
    }
  }
}
