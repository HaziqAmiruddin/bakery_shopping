import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_divider.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/home/data/sample_data.dart';
import 'package:shopping_app/features/home/presentation/widgets/filter_title.dart';
import 'package:shopping_app/features/home/presentation/widgets/sort_abd_filter_list.dart';

class SortAndFilterScreen extends StatelessWidget {
  const SortAndFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appTypography = context.theme.appTypography;
    return AppScaffold(
      appBar: GeneralAppBar(title: 'Sort & Filter'),
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Column(
          spacing: Dimens.largePadding,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.shrink(),
            FiltersTitle(title: 'Sort'),
            SortAndFilterList(
              titles: [
                'Highest score',
                'Nearest',
                'The latest',
                'The cheapest',
                'The cheapest',
                'The cheapest',
                'The cheapest',
                'The cheapest',
              ],
            ),
            AppDivider(
              indent: Dimens.largePadding,
              endIndent: Dimens.largePadding,
            ),
            FiltersTitle(title: 'Categories'),
            SortAndFilterList(titles: ['All', ...titlesOfCategories]),
            AppDivider(
              indent: Dimens.largePadding,
              endIndent: Dimens.largePadding,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: Dimens.largePadding,
          right: Dimens.largePadding,
          bottom: Dimens.padding,
        ),
        child: AppButton(
          onPressed: () {},
          title: 'Apply filter',
          textStyle: appTypography.bodyLarge,
          borderRadius: Dimens.corners,
          margin: EdgeInsets.symmetric(vertical: Dimens.largePadding),
        ),
      ),
    );
  }
}
