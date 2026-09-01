import 'package:shopping_app/features/cart/domain/repo/cart_repo.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

class AddToCartUseCase {
  final CartRepository repository;
  AddToCartUseCase(this.repository);

  Future<void> call(Product product, {String? weight}) =>
      repository.addToCart(product, weight: weight);
}
