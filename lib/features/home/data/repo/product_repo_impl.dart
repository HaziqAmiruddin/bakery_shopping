import 'package:shopping_app/features/home/data/product_data/internet_data.dart';
import 'package:shopping_app/features/home/data/product_data/local_data.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/domain/repo/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({ProductApiService? apiService})
    : _apiService = apiService ?? ProductApiService();

  final ProductApiService _apiService;

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

  @override
  Future<List<Product>> getFeaturedProducts() async =>
      localProducts.where((p) => p.isFeatured).toList();

  @override
  Future<List<Product>> getNewProducts() async =>
      localProducts.where((p) => p.isNew).toList();

  @override
  Future<List<Product>> getPopularProducts() async =>
      localProducts.where((p) => p.isPopular).toList();

  @override
  Future<List<Product>> getOnlineProducts() async {
    return _apiService.getAllProducts(limit: 10);
  }
}
