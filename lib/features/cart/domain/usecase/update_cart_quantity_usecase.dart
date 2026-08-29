import 'package:shopping_app/features/cart/domain/repo/cart_repo.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;
  UpdateCartQuantityUseCase(this.repository);

  Future<void> call(String productId, int quantity) {
    return repository.updateQuantity(productId, quantity);
  }
}
