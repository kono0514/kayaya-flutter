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

  @override
  List<Object> get props => [];
}
