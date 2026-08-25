import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductsByCategory(String category);
  Future<List<Product>> getAllProducts();
}
