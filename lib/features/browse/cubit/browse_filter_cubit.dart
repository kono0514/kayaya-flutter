import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../browse.dart';

part 'browse_filter_state.dart';

class BrowseFilterCubit extends Cubit<BrowseFilterState> {
  BrowseFilterCubit() : super(BrowseFilterInitial());

  void changeFilter(Filter filter) {
    emit(BrowseFilterModified(filter));
  }

  void resetFilter() {
    emit(BrowseFilterInitial());
  }
}
