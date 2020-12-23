part of 'browse_bloc.dart';

abstract class BrowseEvent extends Equatable {
  const BrowseEvent();

  @override
  List<Object> get props => [];
}

class BrowseFetched extends BrowseEvent {
  const BrowseFetched();

  @override
  String toString() => 'BrowseFetched';
}

class BrowseRefreshed extends BrowseEvent {
  const BrowseRefreshed();

  @override
  String toString() => 'BrowseRefreshed';
}
