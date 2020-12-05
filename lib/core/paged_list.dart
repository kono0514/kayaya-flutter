import 'package:equatable/equatable.dart';

class PagedList<T> extends Equatable {
  final List<T> elements;
  final int total;
  final int currentPage;
  final bool hasMorePages;

  PagedList({
    this.elements,
    this.total,
    this.currentPage,
    this.hasMorePages,
  });

  PagedList<T> copyWith({
    List<T> elements,
    int total,
    int currentPage,
    bool hasMorePages,
  }) {
    return PagedList<T>(
      elements: elements ?? this.elements,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }

  @override
  List<Object> get props => [elements, total, currentPage, hasMorePages];
}
