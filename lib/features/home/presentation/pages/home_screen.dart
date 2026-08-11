import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/app_title_widget.dart';
import 'package:shopping_app/features/home/presentation/pages/category_screen.dart';
import 'package:shopping_app/features/home/presentation/widgets/banner_slider_widget.dart';
import 'package:shopping_app/features/home/presentation/widgets/categories_list.dart';
import 'package:shopping_app/features/home/presentation/widgets/product_list.dart';
import 'package:shopping_app/features/home/presentation/widgets/special_offer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppTitleWidget(
            title: "Special Offer",
            onPressed: () {
              appPush(context, SpecialOffers());
            },
          ),
          BannerSliderWidget(),
          AppTitleWidget(
            title: "Categories",
            onPressed: () {
              appPush(context, CategoryScreen());
            },
          ),
          CategoriesList(),
          ProductList(),
          SizedBox(height: Dimens.largePadding),
        ],
      ),
    );
  }
}
