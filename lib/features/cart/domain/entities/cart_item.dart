import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String name;
  final String image;
  final double price;
  final double originalPrice;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.originalPrice,
    required this.quantity,
  });

  bool get hasDiscount => originalPrice > price;
  double get subtotal => price * quantity;
  double get savings => (originalPrice - price) * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      image: image,
      price: price,
      originalPrice: originalPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      productId: data['productId'] as String,
      name: data['name'] as String,
      image: data['image'] as String,
      price: (data['price'] as num).toDouble(),
      originalPrice:
          (data['originalPrice'] as num?)?.toDouble() ??
          (data['price'] as num).toDouble(),
      quantity: (data['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'originalPrice': originalPrice,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    image,
    price,
    originalPrice,
    quantity,
  ];
}
