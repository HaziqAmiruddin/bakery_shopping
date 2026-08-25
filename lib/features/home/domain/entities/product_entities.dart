enum ProductSource { local, remote }

class Seller {
  final String name;
  final String imagePath;
  final bool isAsset;

  const Seller({
    required this.name,
    required this.imagePath,
    this.isAsset = true,
  });
}

class BannerOffer {
  final String image;
  final String title;
  final String category; // must match Product.category exactly

  const BannerOffer({
    required this.image,
    required this.title,
    required this.category,
  });
}

class Product {
  final String id;
  final String name;
  final String image;
  final String detailImage;
  final String category;
  final double? price;
  final String? description;
  final double rating;
  final Seller seller;
  final List<String> availableWeights;
  final ProductSource source;
  final double discountPercentage;

  const Product({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.description,
    required this.rating,
    required this.seller,
    this.detailImage = '',
    this.availableWeights = const ['0.5 kg', '1 kg', '1.5 kg', '2 kg', '4 kg'],
    this.source = ProductSource.local,
    this.discountPercentage = 0,
  });

  bool get isOnSale => discountPercentage > 0;
  double get discountedPrice => price! - (price! * discountPercentage / 100);
  String get displayImage => detailImage.isNotEmpty ? detailImage : image;

  factory Product.fromDummyJson(Map<String, dynamic> json) {
    final images = (json['images'] as List?)?.cast<String>() ?? [];
    return Product(
      id: 'remote_${json['id']}',
      name: json['title'] as String,
      image: json['thumbnail'] as String,
      detailImage: images.isNotEmpty
          ? images.first
          : json['thumbnail'] as String,
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      seller: Seller(
        name: json['brand'] as String? ?? 'DummyJSON Store',
        imagePath: 'assets/images/profile_image.png', // fallback local avatar
        isAsset: true,
      ),
      source: ProductSource.remote,
    );
  }
}
