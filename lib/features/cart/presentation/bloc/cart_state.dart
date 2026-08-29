// presentation/bloc/cart/cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  const CartLoaded(this.items);

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  @override
  List<Object?> get props => [items];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object?> get props => [message];
}
