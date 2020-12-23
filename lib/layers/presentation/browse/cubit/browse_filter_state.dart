part of 'browse_filter_cubit.dart';

abstract class BrowseFilterState extends Equatable {
  final Filter filter;

  const BrowseFilterState(this.filter);
}

class BrowseFilterInitial extends BrowseFilterState {
  const BrowseFilterInitial({
    Filter filter = const Filter(
      orderBy: FilterOrderBy.recent,
      type: FilterType.all,
      genres: <String>[],
    ),
  }) : super(filter);

  @override
  List<Object> get props => [filter];
}

class BrowseFilterModified extends BrowseFilterState {
  const BrowseFilterModified(Filter filter) : super(filter);

  @override
  List<Object> get props => [filter];
}
