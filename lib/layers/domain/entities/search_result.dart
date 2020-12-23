import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SearchResult extends Equatable {
  final String id;
  final String name;
  final String image;
  final String color;
  final int year;
  final String type;

  const SearchResult({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.color,
    @required this.year,
    @required this.type,
  });

  @override
  List<Object> get props => [id, name, image, color, year, type];
}
