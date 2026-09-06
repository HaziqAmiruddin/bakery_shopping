import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/domain/repo/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;
  GetAllProductsUseCase(this.repository);

  Future<List<Product>> call() {
    return repository.getAllProducts();
  }
}

class GetFeaturedProductsUseCase {
  final ProductRepository repository;
  GetFeaturedProductsUseCase(this.repository);
  Future<List<Product>> call() => repository.getFeaturedProducts();
}

class GetNewProductsUseCase {
  final ProductRepository repository;
  GetNewProductsUseCase(this.repository);
  Future<List<Product>> call() => repository.getNewProducts();
}

class GetOnlineProductsUseCase {
  final ProductRepository repository;
  GetOnlineProductsUseCase(this.repository);

  Future<List<Product>> call({int skip = 0, int limit = 10}) {
    return repository.getOnlineProducts(skip: skip, limit: limit);
  }
}

class GetPopularProductsUseCase {
  final ProductRepository repository;
  GetPopularProductsUseCase(this.repository);
  Future<List<Product>> call() => repository.getPopularProducts();
}

class GetProductsByCategoryUseCase {
  final ProductRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<List<Product>> call(String category) {
    return repository.getProductsByCategory(category);
  }
}
