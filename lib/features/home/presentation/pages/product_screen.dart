import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/utils/sized_context.dart';
import 'package:shopping_app/core/widgets/app_icon_button.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/app_search_bar.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/core/widgets/rate_widget.dart';
import 'package:shopping_app/core/widgets/shaded_container.dart';
import 'package:shopping_app/features/home/data/sample_data.dart';
import 'package:shopping_app/features/home/presentation/pages/sort_and_filter_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    return AppScaffold(
      appBar: GeneralAppBar(
        title: 'Products',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.only(
              left: Dimens.largePadding,
              right: Dimens.largePadding,
            ),
            child: AppSearchBar(),
          ),
        ),
        height: 128,
      ),
      body: Column(
        spacing: Dimens.largePadding,
        children: [
          SizedBox.shrink(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: Dimens.largePadding,
            children: [
              GestureDetector(
                onTap: () {
                  appPush(context, SortAndFilterScreen());
                },
                child: ShadedContainer(
                  padding: EdgeInsets.all(Dimens.largePadding),
                  borderRadius: 100,
                  child: Row(
                    spacing: Dimens.padding,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSvgViewer(Assets.icons.filterSearch, width: 16),
                      Text('Filters'),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  appPush(context, SortAndFilterScreen());
                },
                child: ShadedContainer(
                  padding: EdgeInsets.all(Dimens.largePadding),
                  borderRadius: 100,
                  child: Row(
                    spacing: Dimens.padding,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSvgViewer(Assets.icons.sort, width: 16),
                      Text('Sort'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Dimens.largePadding,
                crossAxisSpacing: Dimens.largePadding,
                mainAxisExtent: 210,
              ),
              shrinkWrap: true,
              itemCount: categoryProductsImage.length,
              itemBuilder: (final context, final index) {
                return ShadedContainer(
                  child: Column(
                    spacing: Dimens.padding,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Dimens.padding),
                        child: SizedBox(
                          height: 114,
                          width: context.widthPx,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimens.corners),
                            child: Image.asset(
                              categoryProductsImage[index],
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.padding,
                        ),
                        child: Column(
                          spacing: Dimens.largePadding,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: Dimens.padding,
                              children: [
                                Expanded(
                                  child: Text(
                                    categoryProductsName[index],
                                    style:
                                        context.theme.appTypography.titleSmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                RateWidget(rate: '7.10'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${index + 1}8.00',
                                  style: context.theme.appTypography.labelLarge
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: AppIconButton(
                                    iconPath: Assets.icons.shoppingCart,
                                    backgroundColor: appColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
