// presentation/bloc/favorite/favorite_event.dart
import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object?> get props => [];
}

class WatchFavoritesStarted extends FavoriteEvent {}

class FavoriteToggled extends FavoriteEvent {
  final Product product;
  const FavoriteToggled(this.product);
  @override
  List<Object?> get props => [product];
}
