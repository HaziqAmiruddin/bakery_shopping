import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_item.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:shopping_app/features/home/presentation/widgets/product_image.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textOwn = context.theme.appTypography;
    final colorsOwn = context.theme.appColors;

    return Container(
      padding: EdgeInsets.all(Dimens.padding),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(Dimens.corners),
        boxShadow: [
          BoxShadow(
            color: colorsOwn.black.withValues(alpha: 0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        spacing: Dimens.padding,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.smallCorners),
            child: SizedBox(
              width: 64,
              height: 64,
              child: ProductImage(imagePath: item.image),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.smallPadding,
              children: [
                Text(
                  item.name,
                  style: textOwn.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.weight != null && item.weight!.isNotEmpty)
                  Text(
                    item.weight!,
                    style: textOwn.labelSmall.copyWith(color: colorsOwn.gray4),
                  ),
                Row(
                  spacing: Dimens.smallPadding,
                  children: [
                    if (item.hasDiscount)
                      Text(
                        '\$ ${item.originalPrice.toStringAsFixed(2)}',
                        style: textOwn.labelSmall.copyWith(
                          color: colorsOwn.gray4,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      '\$ ${item.price.toStringAsFixed(2)}',
                      style: textOwn.labelMedium.copyWith(
                        color: colorsOwn.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              _QuantityButton(
                icon: Icons.remove,
                onTap: () => context.read<CartBloc>().add(
                  CartQuantityChanged(item.cartDocId, item.quantity - 1),
                ),
              ),
              SizedBox(
                width: 28,
                child: Text(
                  '${item.quantity}',
                  textAlign: TextAlign.center,
                  style: textOwn.labelMedium,
                ),
              ),
              _QuantityButton(
                icon: Icons.add,
                onTap: () => context.read<CartBloc>().add(
                  CartQuantityChanged(item.cartDocId, item.quantity + 1),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: colorsOwn.gray4),
            onPressed: () =>
                context.read<CartBloc>().add(CartItemRemoved(item.cartDocId)),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.theme.appColors.gray4),
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }
}
