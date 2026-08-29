import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_item.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_state.dart';

class CartSummary extends StatelessWidget {
  final double total;
  const CartSummary({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final textOwn = context.theme.appTypography;
    final colorsOwn = context.theme.appColors;

    return Container(
      padding: EdgeInsets.all(Dimens.largePadding),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorsOwn.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        spacing: Dimens.padding,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: textOwn.labelMedium.copyWith(color: colorsOwn.gray4),
                ),
                Text(
                  '\$ ${total.toStringAsFixed(2)}',
                  style: textOwn.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 160,
            height: 48,
            child: AppButton(
              title: "Pay",
              onPressed: () {
                // Checkout flow — TODO next
              },
              margin: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class CartLoaded extends CartState {
  final List<CartItem> items;
  const CartLoaded(this.items);

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
  double get totalSavings => items.fold(0, (sum, item) => sum + item.savings);

  @override
  List<Object?> get props => [items];
}
