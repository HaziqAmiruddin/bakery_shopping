import 'package:shopping_app/features/cart/domain/entities/cart_item.dart';
import 'package:shopping_app/features/cart/domain/repo/cart_repo.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

class AddToCartUseCase {
  final CartRepository repository;
  AddToCartUseCase(this.repository);

  Future<void> call(Product product, {String? weight}) =>
      repository.addToCart(product, weight: weight);
}

class RemoveFromCartUseCase {
  final CartRepository repository;
  RemoveFromCartUseCase(this.repository);

  Future<void> call(String productId) => repository.removeFromCart(productId);
}

class UpdateCartQuantityUseCase {
  final CartRepository repository;
  UpdateCartQuantityUseCase(this.repository);

  Future<void> call(String productId, int quantity) {
    return repository.updateQuantity(productId, quantity);
  }
}

class WatchCartUseCase {
  final CartRepository repository;
  WatchCartUseCase(this.repository);

  Stream<List<CartItem>> call() => repository.watchCart();
}
