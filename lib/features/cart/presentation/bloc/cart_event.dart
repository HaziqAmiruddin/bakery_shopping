// presentation/bloc/cart/cart_event.dart
import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class WatchCartStarted extends CartEvent {}

class AddToCartPressed extends CartEvent {
  final Product product;
  const AddToCartPressed(this.product);
  @override
  List<Object?> get props => [product];
}

class CartQuantityChanged extends CartEvent {
  final String productId;
  final int quantity;
  const CartQuantityChanged(this.productId, this.quantity);
  @override
  List<Object?> get props => [productId, quantity];
}

class CartItemRemoved extends CartEvent {
  final String productId;
  const CartItemRemoved(this.productId);
  @override
  List<Object?> get props => [productId];
}
