part of 'browse_filter_cubit.dart';

abstract class BrowseFilterState extends Equatable {
  final Filter filter;

  const BrowseFilterState(this.filter);
}

class BrowseFilterInitial extends BrowseFilterState {
  final Filter filter;

  const BrowseFilterInitial({
    this.filter = const Filter(
      orderBy: FilterOrderBy.recent,
      type: FilterType.all,
      genres: <String>[],
    ),
  }) : super(null);

  @override
  List<Object> get props => [filter];
}

class BrowseFilterModified extends BrowseFilterState {
  final Filter filter;

  const BrowseFilterModified(this.filter) : super(null);

  @override
  List<Object> get props => [filter];
}
