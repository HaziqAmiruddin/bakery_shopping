import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/features/home/data/sample_data.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorsOwn = context.theme.appColors;
    return SizedBox(
      height: 120,
      child: ListView.builder(
        itemCount: titlesOfCategories.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (final context, final index) {
          return Column(
            spacing: Dimens.padding,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: context.theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: colorsOwn.primary.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(Dimens.largePadding),
                margin: EdgeInsets.symmetric(
                  horizontal: index == 0 ? Dimens.largePadding : Dimens.padding,
                ),
                child: Center(child: Image.asset(imagesOfCategories[index])),
              ),
              Text(titlesOfCategories[index]),
            ],
          );
        },
      ),
    );
  }
}
