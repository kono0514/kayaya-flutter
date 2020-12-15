import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/anime_relation.dart';
import '../../../domain/usecases/detail/get_relations_usecase.dart';

part 'relations_state.dart';

@Injectable()
class RelationsCubit extends Cubit<RelationsState> {
  final GetRelationsUsecase getRelationsUsecase;

  RelationsCubit({@required this.getRelationsUsecase})
      : super(RelationsInitial());

  void loadRelations(String id) async {
    emit(RelationsInitial());

    final result = await getRelationsUsecase(GetRelationsUsecaseParams(id: id));
    result.fold(
      (l) => emit(RelationsError(l.message)),
      (r) => emit(RelationsLoaded(
        r.related,
        r.recommendations,
      )),
    );
  }
}
