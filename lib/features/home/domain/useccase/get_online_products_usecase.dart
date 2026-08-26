import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/domain/repo/product_repository.dart';

class GetOnlineProductsUseCase {
  final ProductRepository repository;
  GetOnlineProductsUseCase(this.repository);

  Future<List<Product>> call() => repository.getOnlineProducts();
}
