import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/domain/repo/product_repository.dart';

class GetFeaturedProductsUseCase {
  final ProductRepository repository;
  GetFeaturedProductsUseCase(this.repository);
  Future<List<Product>> call() => repository.getFeaturedProducts();
}
