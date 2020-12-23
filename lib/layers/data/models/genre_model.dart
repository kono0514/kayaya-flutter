import 'package:meta/meta.dart';

import '../../../codegen/graphql_api.graphql.dart' as gen;
import '../../domain/entities/genre.dart';

class GenreModel extends Genre {
  const GenreModel({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);

  factory GenreModel.fromGraphQL(gen.GenreFieldsMixin graphql) {
    return GenreModel(
      id: graphql.id,
      name: graphql.name,
    );
  }
}
