// presentation/bloc/product_list/product_list_state.dart
import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

class ProductListSection extends Equatable {
  final String title;
  final List<Product> products;

  const ProductListSection({required this.title, required this.products});

  @override
  List<Object?> get props => [title, products];
}

abstract class ProductListState extends Equatable {
  const ProductListState();
  @override
  List<Object?> get props => [];
}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<ProductListSection> sections;
  const ProductListLoaded(this.sections);

  @override
  List<Object?> get props => [sections];
}

class ProductListError extends ProductListState {
  final String message;
  const ProductListError(this.message);

  @override
  List<Object?> get props => [message];
}
