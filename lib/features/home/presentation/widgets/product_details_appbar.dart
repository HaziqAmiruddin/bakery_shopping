import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/app_bordered_icon_button.dart';

class ProductDetailsAppBar extends StatelessWidget {
  const ProductDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.largePadding),
        child: AppBorderedIconButton(
          iconPath: Assets.icons.arrowLeft,
          color: Colors.white,
          onPressed: () {
            appPop(context);
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.largePadding),
          child: AppBorderedIconButton(
            iconPath: Assets.icons.heart,
            color: Colors.white,
            onPressed: () {},
          ),
        ),
      ],
      leadingWidth: 90.0,
    );
  }
}
