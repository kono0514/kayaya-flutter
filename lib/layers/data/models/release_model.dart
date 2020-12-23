import 'package:meta/meta.dart';

import '../../../codegen/graphql_api.graphql.dart' as gen;
import '../../domain/entities/release.dart';

class ReleaseModel extends Release {
  const ReleaseModel({
    @required String id,
    @required String url,
    String resolution,
    String group,
  }) : super(
          id: id,
          url: url,
          resolution: resolution,
          group: group,
        );

  factory ReleaseModel.fromGraphQL(
      gen.GetAnimeEpisodes$Query$Episodes$Data$Releases graphql) {
    return ReleaseModel(
      id: graphql.id,
      url: graphql.url,
      resolution: graphql.resolution?.toString(),
      group: graphql.group,
    );
  }
}
