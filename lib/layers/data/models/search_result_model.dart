import 'package:meta/meta.dart';

import '../../domain/entities/search_result.dart';

class SearchResultModel extends SearchResult {
  const SearchResultModel({
    @required String id,
    @required String name,
    @required String image,
    @required String color,
    @required int year,
    @required String type,
  }) : super(
          id: id,
          name: name,
          image: image,
          color: color,
          year: year,
          type: type,
        );

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['cover_image_large'] as String,
      color: json['cover_color'] as String,
      year: json['start_year'] as int,
      type: json['anime_type'] as String,
    );
  }
}
