import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/sized_context.dart';
import 'package:shopping_app/core/widgets/app_icon_button.dart';
import 'package:shopping_app/core/widgets/app_search_bar.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorsOwn = context.theme.appColors;
    final textOwn = context.theme.appTypography;
    return Column(
      children: [
        AppBar(
          backgroundColor: colorsOwn.primary,
          actions: [AppIconButton(iconPath: Assets.icons.location)],
          title: Row(
            spacing: Dimens.padding,
            children: [
              AppIconButton(iconPath: Assets.icons.notification),
              Column(
                spacing: Dimens.padding,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location",
                    style: textOwn.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Bukit Jelutong, MLY",
                    style: textOwn.titleSmall.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          leadingWidth: 85,
          titleSpacing: Dimens.padding,
          actionsPadding: EdgeInsets.symmetric(horizontal: Dimens.largePadding),
        ),
        Stack(
          children: [
            Container(
              height: 50,
              width: context.widthPx,
              decoration: BoxDecoration(
                color: colorsOwn.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimens.extraLargePadding),
                  bottomRight: Radius.circular(Dimens.extraLargePadding),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 25,
                left: Dimens.largePadding,
                right: Dimens.largePadding,
              ),
              child: AppSearchBar(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height + 80);
}
