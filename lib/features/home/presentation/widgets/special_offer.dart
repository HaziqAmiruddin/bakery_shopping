import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/home/data/product_data/local_data.dart';
import 'package:shopping_app/features/home/presentation/pages/discount_product_screen.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: GeneralAppBar(title: 'Special offers'),
      body: ListView.separated(
        itemCount: bannerOffers.length,
        itemBuilder: (final context, final index) {
          final offer = bannerOffers[index];
          return InkWell(
            onTap: () {
              appPush(
                context,
                DiscountProductScreen(
                  category: offer.category,
                  title: offer.title,
                ),
              );
            },
            borderRadius: BorderRadius.circular(Dimens.largePadding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.largePadding),
              child: Image.asset(offer.image),
            ),
          );
        },
        separatorBuilder: (final context, final index) {
          return SizedBox(height: Dimens.largePadding);
        },
      ),
    );
  }
}
