import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/models/filter.dart';

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
