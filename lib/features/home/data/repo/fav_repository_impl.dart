import 'package:shopping_app/features/home/data/product_data/fav_remote_datasource.dart';
import 'package:shopping_app/features/home/domain/entities/fav_item_entities.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/domain/repo/fav_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl({required FavoriteRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final FavoriteRemoteDataSource _remoteDataSource;

  @override
  Stream<List<FavoriteItem>> watchFavorites() =>
      _remoteDataSource.watchFavorites();

  @override
  Future<void> toggleFavorite(Product product) =>
      _remoteDataSource.toggleFavorite(product);
}
