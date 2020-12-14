import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Release extends Equatable {
  final String id;
  final String url;
  final String resolution;
  final String group;

  Release({
    @required this.id,
    @required this.url,
    this.resolution,
    this.group,
  });

  @override
  List<Object> get props => [id, resolution, url, group];
}
