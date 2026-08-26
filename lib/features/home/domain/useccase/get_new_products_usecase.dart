import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/domain/repo/product_repository.dart';

class GetNewProductsUseCase {
  final ProductRepository repository;
  GetNewProductsUseCase(this.repository);
  Future<List<Product>> call() => repository.getNewProducts();
}
