import 'package:shopping_app/features/cart/domain/repo/cart_repo.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;
  RemoveFromCartUseCase(this.repository);

  Future<void> call(String productId) => repository.removeFromCart(productId);
}
