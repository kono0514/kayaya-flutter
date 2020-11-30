import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart' as gen;
import 'package:meta/meta.dart';

import '../entity/genre.dart';

class GenreModel extends Genre {
  GenreModel({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);

  factory GenreModel.fromGraphQL(gen.GetGenres$Query$Genres graphql) {
    return GenreModel(
      id: graphql.id,
      name: graphql.name,
    );
  }
}
