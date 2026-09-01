import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/app_bordered_icon_button.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/fav_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/fav_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/fav_state.dart';

class ProductDetailsAppBar extends StatelessWidget {
  const ProductDetailsAppBar({super.key, required this.product});

  final Product product;

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
          child: BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              final isFavorite =
                  state is FavoriteLoaded && state.isFavorite(product.id);

              return AppBorderedIconButton(
                iconPath: isFavorite ? Assets.icons.star : Assets.icons.heart,
                color: isFavorite ? Colors.amber : Colors.white,
                onPressed: () {
                  context.read<FavoriteBloc>().add(FavoriteToggled(product));
                },
              );
            },
          ),
        ),
      ],
      leadingWidth: 90.0,
    );
  }
}
