import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
  });

  bool get _isNetworkImage =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage) {
      return Image.network(
        imagePath,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image_outlined));
        },
      );
    }

    return Image.asset(
      imagePath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.broken_image_outlined));
      },
    );
  }
}
