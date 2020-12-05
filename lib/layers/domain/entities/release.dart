import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Release extends Equatable {
  final String id;
  final ReleaseType type;
  final String url;
  final String resolution;
  final String group;

  Release({
    @required this.id,
    @required this.type,
    @required this.url,
    this.resolution,
    this.group,
  });

  bool get isDirect => type == ReleaseType.direct;
  bool get isEmbed => type == ReleaseType.embed;

  @override
  List<Object> get props => [id, resolution, type, url, group];
}

enum ReleaseType {
  direct,
  embed,
}
