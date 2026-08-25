import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

abstract class CategoryProductsState extends Equatable {
  const CategoryProductsState();
  @override
  List<Object?> get props => [];
}

class CategoryProductsLoading extends CategoryProductsState {}

class CategoryProductsLoaded extends CategoryProductsState {
  final List<Product> products;
  final String category;
  const CategoryProductsLoaded(this.products, this.category);

  @override
  List<Object?> get props => [products, category];
}

class CategoryProductsError extends CategoryProductsState {
  final String message;
  const CategoryProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
