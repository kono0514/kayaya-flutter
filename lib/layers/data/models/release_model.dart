import 'package:meta/meta.dart';

import '../../../codegen/graphql_api.graphql.dart' as gen;
import '../../domain/entities/release.dart';

class ReleaseModel extends Release {
  ReleaseModel({
    @required String id,
    @required ReleaseType type,
    @required String url,
    String resolution,
    String group,
  }) : super(
          id: id,
          type: type,
          url: url,
          resolution: resolution,
          group: group,
        );

  factory ReleaseModel.fromGraphQL(
      gen.GetAnimeEpisodes$Query$Episodes$Data$Releases graphql) {
    var _type =
        graphql.type == 'direct' ? ReleaseType.direct : ReleaseType.embed;

    return ReleaseModel(
      id: graphql.id,
      type: _type,
      url: graphql.url,
      resolution: graphql.resolution?.toString(),
      group: graphql.group,
    );
  }
}
