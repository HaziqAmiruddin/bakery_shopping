import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String name;
  final String image;
  final double price;
  final double originalPrice;
  final int quantity;
  final String? weight;

  const CartItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    this.weight,
  });

  bool get hasDiscount => originalPrice > price;
  double get subtotal => price * quantity;
  double get savings => (originalPrice - price) * quantity;

  String get cartDocId =>
      weight != null && weight!.isNotEmpty ? '${productId}_$weight' : productId;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      image: image,
      price: price,
      originalPrice: originalPrice,
      quantity: quantity ?? this.quantity,
      weight: weight,
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
      weight: data['weight'] as String?,
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
      'weight': weight,
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
    weight,
  ];
}
