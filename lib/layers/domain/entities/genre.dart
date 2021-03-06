import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Genre extends Equatable {
  final String id;
  final String name;

  const Genre({
    @required this.id,
    @required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
