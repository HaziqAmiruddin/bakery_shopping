import 'package:shopping_app/features/cart/domain/entities/cart_item.dart';
import 'package:shopping_app/features/cart/domain/repo/cart_repo.dart';

class WatchCartUseCase {
  final CartRepository repository;
  WatchCartUseCase(this.repository);

  Stream<List<CartItem>> call() => repository.watchCart();
}
