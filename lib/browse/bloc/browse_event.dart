part of 'browse_bloc.dart';

abstract class BrowseEvent extends Equatable {
  const BrowseEvent();

  @override
  List<Object> get props => [];
}

class BrowseFetched extends BrowseEvent {
  BrowseFetched();

  @override
  String toString() => 'BrowseFetched';
}

class BrowseRefreshed extends BrowseEvent {
  BrowseRefreshed();

  @override
  String toString() => 'BrowseRefreshed';
}
