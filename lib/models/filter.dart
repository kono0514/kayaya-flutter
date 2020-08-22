import 'package:equatable/equatable.dart';

enum FilterOrderBy {
  recent,
  alpha_asc,
  alpha_desc,
  rating_asc,
  rating_desc,
}

enum FilterType {
  all,
  movie,
  series,
}

class Filter extends Equatable {
  final FilterOrderBy orderBy;
  final FilterType type;
  final List<String> genres;

  const Filter({this.orderBy, this.type, this.genres});

  Filter copyWith({
    FilterOrderBy orderBy,
    FilterType type,
    List<String> genres,
  }) {
    return Filter(
      orderBy: orderBy ?? this.orderBy,
      type: type ?? this.type,
      genres: genres ?? this.genres,
    );
  }

  @override
  List<Object> get props => [orderBy, type, genres];

  @override
  String toString() {
    return 'Filter { orderBy: $orderBy, type: $type, genres: $genres }';
  }
}
