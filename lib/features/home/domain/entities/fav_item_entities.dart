import 'package:equatable/equatable.dart';

class FavoriteItem extends Equatable {
  final String productId;
  final String name;
  final String image;
  final double price;
  final bool
  isRemote; // needed to know how to re-fetch full product details later

  const FavoriteItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.isRemote,
  });

  factory FavoriteItem.fromFirestore(Map<String, dynamic> data) {
    return FavoriteItem(
      productId: data['productId'] as String,
      name: data['name'] as String,
      image: data['image'] as String,
      price: (data['price'] as num).toDouble(),
      isRemote: data['isRemote'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'isRemote': isRemote,
    };
  }

  @override
  List<Object?> get props => [productId, name, image, price, isRemote];
}
