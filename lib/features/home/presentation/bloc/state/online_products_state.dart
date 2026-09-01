// presentation/bloc/online_products/online_products_state.dart
import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

abstract class OnlineProductsState extends Equatable {
  const OnlineProductsState();
  @override
  List<Object?> get props => [];
}

class OnlineProductsLoading extends OnlineProductsState {}

class OnlineProductsLoaded extends OnlineProductsState {
  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;

  const OnlineProductsLoaded({
    required this.products,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  OnlineProductsLoaded copyWith({
    List<Product>? products,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return OnlineProductsLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [products, hasMore, isLoadingMore];
}

class OnlineProductsError extends OnlineProductsState {
  final String message;
  const OnlineProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
