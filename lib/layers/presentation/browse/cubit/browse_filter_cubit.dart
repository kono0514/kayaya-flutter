import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/anime_filter.dart';

part 'browse_filter_state.dart';

@Injectable()
class BrowseFilterCubit extends Cubit<BrowseFilterState> {
  BrowseFilterCubit() : super(BrowseFilterInitial());

  void changeFilter(Filter filter) {
    emit(BrowseFilterModified(filter));
  }

  void resetFilter() {
    emit(BrowseFilterInitial());
  }
}
