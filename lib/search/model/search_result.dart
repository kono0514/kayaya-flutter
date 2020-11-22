import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  final List<SearchResultItem> hits;

  SearchResult(this.hits);

  @override
  List<Object> get props => [hits];
}

class SearchResultItem extends Equatable {
  final String id;
  final String nameMn;
  final String nameEn;
  final String coverImageLarge;
  final String coverColor;
  final int startYear;
  final String animeType;

  SearchResultItem({
    this.id,
    this.nameMn,
    this.nameEn,
    this.coverImageLarge,
    this.coverColor,
    this.startYear,
    this.animeType,
  });

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem(
      id: json['id'] as String,
      nameMn: json['name_mn'] as String,
      nameEn: json['name_en'] as String,
      coverImageLarge: json['cover_image_large'] as String,
      coverColor: json['cover_color'] as String,
      startYear: json['start_year'] as int,
      animeType: json['anime_type'] as String,
    );
  }

  @override
  List<Object> get props =>
      [nameMn, nameEn, coverImageLarge, coverColor, startYear, animeType];
}
