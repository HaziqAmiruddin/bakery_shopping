import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textOwn = context.theme.appTypography;
    final colorsOwn = context.theme.appColors;
    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: GeneralAppBar(title: 'My Cart', showBackIcon: false),
      body: Center(
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
      ),
    );
  }
}
