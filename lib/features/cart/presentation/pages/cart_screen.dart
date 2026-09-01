import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_state.dart';
import 'package:shopping_app/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:shopping_app/features/cart/presentation/widgets/cart_summary.dart'
    hide CartLoaded;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textOwn = context.theme.appTypography;
    final colorsOwn = context.theme.appColors;

    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: GeneralAppBar(title: 'My Cart', showBackIcon: false),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (final context, final state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
            return Center(child: Text(state.message));
          }

          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  spacing: Dimens.largePadding,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppSvgViewer(
                      Assets.icons.shoppingCart,
                      width: 50,
                      color: colorsOwn.gray4,
                    ),
                    Text(
                      "Your cart is empty",
                      style: textOwn.bodyLarge.copyWith(color: colorsOwn.gray4),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(Dimens.largePadding),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: Dimens.padding),
                    itemBuilder: (final context, final index) {
                      final item = state.items[index];
                      return CartItemTile(item: item);
                    },
                  ),
                ),
                CartSummary(
                  total: state.total,
                  totalSavings: state.totalSavings,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
