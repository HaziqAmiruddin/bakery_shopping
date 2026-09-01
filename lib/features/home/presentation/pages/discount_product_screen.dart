import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/home/data/product_data/local_data.dart';
import 'package:shopping_app/features/home/presentation/pages/product_details_screen.dart';

class DiscountProductScreen extends StatelessWidget {
  const DiscountProductScreen({
    super.key,
    required this.category,
    required this.title,
  });

  final String category;
  final String title;

  @override
  Widget build(BuildContext context) {
    final appColor = context.theme.appColors;

    final products = localProducts
        .where((p) => p.category == category && p.isOnSale)
        .toList();

    return AppScaffold(
      appBar: GeneralAppBar(title: title),
      body: products.isEmpty
          ? const Center(child: Text('No offers available right now'))
          : ListView.separated(
              padding: EdgeInsets.all(Dimens.largePadding),
              itemCount: products.length,
              separatorBuilder: (_, __) => SizedBox(height: Dimens.padding),
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).secondaryHeaderColor,
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'product_${product.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              product.image,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '\$${product.discountedPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: appColor.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${product.discountPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
