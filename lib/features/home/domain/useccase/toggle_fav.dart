import 'package:shopping_app/features/home/domain/entities/fav_item_entities.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/domain/repo/fav_repository.dart';

class WatchFavoritesUseCase {
  final FavoriteRepository repository;
  WatchFavoritesUseCase(this.repository);
  Stream<List<FavoriteItem>> call() => repository.watchFavorites();
}

class ToggleFavoriteUseCase {
  final FavoriteRepository repository;
  ToggleFavoriteUseCase(this.repository);
  Future<void> call(Product product) => repository.toggleFavorite(product);
}
