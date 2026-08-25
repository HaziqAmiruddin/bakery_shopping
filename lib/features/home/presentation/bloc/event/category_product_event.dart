import 'package:equatable/equatable.dart';

abstract class CategoryProductsEvent extends Equatable {
  const CategoryProductsEvent();
  @override
  List<Object?> get props => [];
}

class FetchCategoryProducts extends CategoryProductsEvent {
  final String category;
  const FetchCategoryProducts(this.category);

  @override
  List<Object?> get props => [category];
}
