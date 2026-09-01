// presentation/widgets/favorite_products_preview_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_title_widget.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/fav_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/fav_state.dart';
import 'package:shopping_app/features/home/presentation/widgets/product_image.dart';

class FavoriteProductsPreviewSection extends StatelessWidget {
  const FavoriteProductsPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        if (state is! FavoriteLoaded || state.items.isEmpty) {
          // No favorites yet, or still loading — section simply doesn't render.
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTitleWidget(
              title: 'Favorites',
              onPressed: () {
                // TODO: wire up a dedicated FavoritesScreen later
              },
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.items.length,
                shrinkWrap: true,
                itemBuilder: (final context, final index) {
                  final item = state.items[index];

                  return Padding(
                    padding: const EdgeInsets.only(left: Dimens.largePadding),
                    child: SizedBox(
                      height: 100,
                      width: 196,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 196,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: ProductImage(imagePath: item.image),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 24,
                                margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.largePadding,
                                  vertical: Dimens.padding,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.smallCorners,
                                  ),
                                  color: context.theme.scaffoldBackgroundColor,
                                ),
                                child: Center(
                                  child: Text(
                                    '\$${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 196,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      context.theme.appColors.black.withValues(
                                        alpha: 0.4,
                                      ),
                                      context.theme.appColors.black.withValues(
                                        alpha: 0.7,
                                      ),
                                      context.theme.appColors.black.withValues(
                                        alpha: 0.8,
                                      ),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    item.name,
                                    style: context
                                        .theme
                                        .appTypography
                                        .titleSmall
                                        .copyWith(
                                          color: context.theme.appColors.white,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
