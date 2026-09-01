import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductsByCategory(String category);
  Future<List<Product>> getAllProducts();
  Future<List<Product>> getFeaturedProducts();
  Future<List<Product>> getNewProducts();
  Future<List<Product>> getPopularProducts();
  Future<List<Product>> getOnlineProducts({int skip = 0, int limit = 10});
}
