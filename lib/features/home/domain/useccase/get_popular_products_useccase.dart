import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/domain/repo/product_repository.dart';

class GetPopularProductsUseCase {
  final ProductRepository repository;
  GetPopularProductsUseCase(this.repository);
  Future<List<Product>> call() => repository.getPopularProducts();
}
