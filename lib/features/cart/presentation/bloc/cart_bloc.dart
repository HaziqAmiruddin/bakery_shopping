import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_item.dart';
import 'package:shopping_app/features/cart/domain/usecase/add_to_cart_usecase.dart';
import 'package:shopping_app/features/cart/domain/usecase/remove_from_cart_usecase.dart';
import 'package:shopping_app/features/cart/domain/usecase/update_cart_quantity_usecase.dart';
import 'package:shopping_app/features/cart/domain/usecase/watch_cart_usecase.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final WatchCartUseCase watchCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;

  CartBloc({
    required this.watchCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartQuantityUseCase,
    required this.removeFromCartUseCase,
  }) : super(CartLoading()) {
    on<WatchCartStarted>(_onWatchCartStarted);
    on<AddToCartPressed>(_onAddToCartPressed);
    on<CartQuantityChanged>(_onQuantityChanged);
    on<CartItemRemoved>(_onItemRemoved);
  }

  Future<void> _onWatchCartStarted(
    WatchCartStarted event,
    Emitter<CartState> emit,
  ) async {
    await emit.forEach<List<CartItem>>(
      watchCartUseCase(),
      onData: (items) => CartLoaded(items),
      onError: (error, stackTrace) => CartError(error.toString()),
    );
  }

  Future<void> _onAddToCartPressed(
    AddToCartPressed event,
    Emitter<CartState> emit,
  ) async {
    // No emit here — Firestore write triggers the stream in
    // _onWatchCartStarted, which updates the UI automatically.
    await addToCartUseCase(event.product, weight: event.weight);
  }

  Future<void> _onQuantityChanged(
    CartQuantityChanged event,
    Emitter<CartState> emit,
  ) async {
    await updateCartQuantityUseCase(event.productId, event.quantity);
  }

  Future<void> _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    await removeFromCartUseCase(event.productId);
  }
}
