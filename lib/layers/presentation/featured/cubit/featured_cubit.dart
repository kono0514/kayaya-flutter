import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/usecase.dart';
import '../../../domain/usecases/anime/get_featured_usecase.dart';

part 'featured_state.dart';

@Injectable()
class FeaturedCubit extends Cubit<FeaturedState> {
  final GetFeaturedUsecase getFeatured;

  FeaturedCubit({
    @required this.getFeatured,
  }) : super(FeaturedInitial());

  void fetch() async {
    emit(FeaturedInitial());
    final featured = await getFeatured(NoParams());
    featured.fold(
      (l) => emit(FeaturedError(l.message)),
      (r) => emit(FeaturedLoaded(r)),
    );
  }
}
