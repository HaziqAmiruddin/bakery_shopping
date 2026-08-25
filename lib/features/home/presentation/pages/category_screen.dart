import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/category_overview_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/category_product_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/category_overview_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/category_product_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/category_overview_state.dart';
import 'package:shopping_app/features/home/presentation/pages/category_products_screen.dart';
import 'package:shopping_app/features/home/presentation/widgets/category_product_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryOverviewBloc>(
      create: (_) => getIt<CategoryOverviewBloc>()..add(FetchAllCategories()),
      child: AppScaffold(
        appBar: GeneralAppBar(title: "Categories"),
        padding: EdgeInsets.zero,
        body: BlocBuilder<CategoryOverviewBloc, CategoryOverviewState>(
          builder: (final context, final state) {
            if (state is CategoryOverviewLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoryOverviewError) {
              return Center(child: Text(state.message));
            }

            if (state is CategoryOverviewLoaded) {
              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: Dimens.padding),
                itemCount: state.sections.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: Dimens.largePadding),
                itemBuilder: (final context, final index) {
                  final section = state.sections[index];
                  return _CategorySectionWidget(section: section);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _CategorySectionWidget extends StatelessWidget {
  final CategorySection section;

  const _CategorySectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    final textOwn = context.theme.appTypography;
    final colorsOwn = context.theme.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.largePadding),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(section.icon, width: 32, height: 32),
              ),
              SizedBox(width: Dimens.smallPadding),
              Text(
                section.title,
                style: textOwn.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  appPush(
                    context,
                    BlocProvider<CategoryProductsBloc>(
                      create: (_) =>
                          getIt<CategoryProductsBloc>()
                            ..add(FetchCategoryProducts(section.title)),
                      child: CategoryProductsScreen(category: section.title),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      "See All",
                      style: textOwn.labelMedium.copyWith(
                        color: colorsOwn.primary,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: colorsOwn.primary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimens.padding),
        SizedBox(
          height: 243,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: Dimens.largePadding),
            itemCount: section.products.length,
            separatorBuilder: (_, __) => SizedBox(width: Dimens.padding),
            itemBuilder: (final context, final index) {
              return CategoryProductCard(product: section.products[index]);
            },
          ),
        ),
      ],
    );
  }
}
