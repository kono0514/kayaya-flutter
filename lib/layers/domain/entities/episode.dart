import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'release.dart';

class Episode extends Equatable {
  final String id;
  final String title;
  final int number;
  final List<Release> releases;
  final String thumbnail;

  const Episode({
    @required this.id,
    @required this.title,
    @required this.number,
    @required this.releases,
    this.thumbnail,
  });

  @override
  List<Object> get props => [id, title, number, releases, thumbnail];
}

enum EpisodeSortOrder {
  asc,
  desc
}
