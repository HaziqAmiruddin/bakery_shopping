import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/rate_widget.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/presentation/widgets/product_image.dart';

class CategoryProductCard extends StatelessWidget {
  final Product product;

  const CategoryProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colorsOwn = context.theme.appColors;
    final textOwn = context.theme.appTypography;

    return Container(
      width: 138,
      height: 243,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(Dimens.largePadding),
        boxShadow: [
          BoxShadow(
            color: colorsOwn.black.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        spacing: Dimens.padding,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 110,
            width: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.corners),
              //child: Image.asset(product.image, fit: BoxFit.cover),
              child: ProductImage(imagePath: product.image, fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: 32,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.smallPadding,
              ),
              child: Center(
                child: Text(
                  product.name,
                  style: textOwn.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RateWidget(rate: product.rating.toStringAsFixed(2)),
              const Text('1k Review', style: TextStyle(fontSize: 12)),
            ],
          ),
          Text(
            '\$ ${product.price.toStringAsFixed(2)}',
            style: textOwn.labelLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 100,
            height: 32,
            child: AppButton(
              title: "Add to Cart",
              onPressed: () {
                context.read<CartBloc>().add(AddToCartPressed(product));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to cart'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              margin: EdgeInsets.zero,
              padding: WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: Dimens.padding),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
