import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Release extends Equatable {
  final String id;
  final String resolution;
  final ReleaseType type;
  final String url;
  final String group;

  Release({
    @required this.id,
    @required this.type,
    @required this.url,
    this.resolution,
    this.group,
  });

  @override
  List<Object> get props => [id, resolution, type, url, group];
}

enum ReleaseType {
  direct,
  embed,
}
