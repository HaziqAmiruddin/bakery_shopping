import 'package:shopping_app/features/home/domain/entities/fav_item_entities.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

abstract class FavoriteRepository {
  Stream<List<FavoriteItem>> watchFavorites();
  Future<void> toggleFavorite(Product product);
}
