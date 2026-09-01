// data/repositories/cart_repository_impl.dart
import 'package:shopping_app/features/cart/data/cart_remote_data_source.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_item.dart';
import 'package:shopping_app/features/cart/domain/repo/cart_repo.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({required CartRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final CartRemoteDataSource _remoteDataSource;

  @override
  Stream<List<CartItem>> watchCart() => _remoteDataSource.watchCart();

  @override
  Future<void> addToCart(Product product, {String? weight}) =>
      _remoteDataSource.addToCart(product, weight: weight);

  @override
  Future<void> updateQuantity(String productId, int quantity) =>
      _remoteDataSource.updateQuantity(productId, quantity);

  @override
  Future<void> removeFromCart(String productId) =>
      _remoteDataSource.removeFromCart(productId);
}
