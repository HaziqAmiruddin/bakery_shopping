import 'package:shopping_app/features/home/data/product_data/local_data.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/domain/repo/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    // Local data source for now — swap the body here later if you move to an API
    return localProducts
        .where((product) => product.category == category)
        .toList();
  }

  @override
  Future<List<Product>> getAllProducts() async {
    // TODO: implement getAllProducts
    return localProducts;
  }
}
