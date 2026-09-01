import 'package:shopping_app/features/cart/domain/entities/cart_item.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

abstract class CartRepository {
  Stream<List<CartItem>> watchCart();
  Future<void> addToCart(Product product, {String? weight});
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> removeFromCart(String productId);
}
