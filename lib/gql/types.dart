import 'package:graphql_flutter/graphql_flutter.dart';

class Queries {
  static final browseAnimes = gql(r'''
    query BrowseAnimes($first: Int, $page: Int, $orderBy: [AnimesOrderByOrderByClause!], $types: [AnimeType!], $genres: AnimesHasGenresWhereConditions) {
      animes(first: $first, page: $page, orderBy: $orderBy, anime_type_in: $types, hasGenres: $genres) {
        paginatorInfo {
          total
          lastPage
          hasMorePages
        }
        data {
          id
          name {
            en
            mn
          }
          anime_type
          rating
          cover_image
          cover_color
          anilist
          genres {
            id
            name {
              en
              mn
            }
          }
        }
      }
    }
  ''');
}
