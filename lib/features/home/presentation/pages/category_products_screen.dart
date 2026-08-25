import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/category_product_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/category_product_state.dart';
import 'package:shopping_app/features/home/presentation/widgets/category_product_card.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: GeneralAppBar(title: category),
      padding: EdgeInsets.zero,
      body: BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
        builder: (final context, final state) {
          if (state is CategoryProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryProductsError) {
            return Center(child: Text(state.message));
          }

          if (state is CategoryProductsLoaded) {
            final products = state.products;

            if (products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }

            return ListView.separated(
              itemCount: products.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: Dimens.padding),
              itemBuilder: (final context, final index) {
                return Padding(
                  padding: EdgeInsets.only(left: Dimens.largePadding),
                  child: CategoryProductCard(product: products[index]),
                );
              },
              separatorBuilder: (final context, final index) {
                return SizedBox(height: Dimens.largePadding);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
