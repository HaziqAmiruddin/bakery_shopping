import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/home/domain/entities/fav_item_entities.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object?> get props => [];
}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<FavoriteItem> items;
  const FavoriteLoaded(this.items);

  bool isFavorite(String productId) =>
      items.any((item) => item.productId == productId);

  @override
  List<Object?> get props => [items];
}

class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError(this.message);
  @override
  List<Object?> get props => [message];
}
