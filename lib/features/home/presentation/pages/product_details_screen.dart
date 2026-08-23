import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/sized_context.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_choice_chip.dart';
import 'package:shopping_app/core/widgets/app_icon_button.dart';
import 'package:shopping_app/core/widgets/app_read_more_text.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/rate_widget.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/presentation/widgets/product_details_appbar.dart';
import 'package:shopping_app/features/home/presentation/widgets/user_profile_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String _selectedWeight = widget.product.availableWeights.isNotEmpty
      ? widget.product.availableWeights.last
      : '';

  static const _priceBarHeight = 140.0;

  @override
  Widget build(BuildContext context) {
    final appColor = context.theme.appColors;
    final appTypography = context.theme.appTypography;
    final product = widget.product;

    return AppScaffold(
      safeAreaTop: false,
      safeAreaBottom: false,
      padding: EdgeInsets.zero,
      body: Stack(
        children: [
          // Scrollable content: image height is natural, card follows right after it.
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: _priceBarHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'product_${product.id}',
                  child: Image(
                    image: product.source == ProductSource.remote
                        ? NetworkImage(product.displayImage)
                        : AssetImage(product.displayImage) as ImageProvider,
                    width: context.widthPx,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Transform.translate(
                  // Pulls the card up slightly so its rounded corners overlap the image.
                  offset: const Offset(0, -24),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimens.corners * 2),
                        topRight: Radius.circular(Dimens.corners * 2),
                      ),
                    ),
                    padding: EdgeInsets.all(Dimens.largePadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: appTypography.bodyLarge.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            RateWidget(rate: product.rating.toStringAsFixed(2)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: appColor.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: appColor.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.largePadding),
                        AppReadMoreText(product.description),
                        SizedBox(height: Dimens.padding),
                        Divider(height: Dimens.largePadding),
                        Text(
                          'Seller',
                          style: appTypography.bodyLarge.copyWith(fontSize: 18),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: SizedBox(
                            width: 44,
                            height: 44,
                            child: UserProfileImage(
                              imagePath: product.seller.imagePath,
                            ),
                          ),
                          title: Text(
                            product.seller.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: Dimens.padding),
                            child: Text(product.category),
                          ),
                          trailing: AppIconButton(
                            iconPath: Assets.icons.call,
                            onPressed: () {},
                            iconColor: appColor.primary,
                            backgroundColor: appColor.primary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        if (product.source == ProductSource.local) ...[
                          Divider(height: 0),
                          SizedBox(height: Dimens.padding),
                          Text(
                            'Select Weight',
                            style: appTypography.bodyLarge.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: Dimens.padding),
                          Wrap(
                            spacing: Dimens.largePadding,
                            children: product.availableWeights.map((weight) {
                              final isSelected = _selectedWeight == weight;
                              return AppChoiceChip(
                                label: weight,
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedWeight = weight;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fixed app bar over the image.
          ProductDetailsAppBar(),

          // Fixed price / add-to-cart bar, pinned to bottom of the screen.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: _priceBarHeight,
              color: appColor.primary,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.largePadding,
                    vertical: Dimens.padding,
                  ),
                  child: SizedBox(
                    width:
                        (context.widthPx < Dimens.largeDeviceBreakPoint
                            ? context.widthPx
                            : Dimens.mediumDeviceBreakPoint) -
                        32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price?.toStringAsFixed(2)}',
                          style: appTypography.bodyLarge.copyWith(
                            color: appColor.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(
                          width: 222,
                          child: AppButton(
                            margin: EdgeInsets.zero,
                            title: 'Add to cart',
                            onPressed: () {},
                            borderRadius: Dimens.corners,
                            color: appColor.white,
                            textStyle: appTypography.bodyLarge.copyWith(
                              color: appColor.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                            iconColor: appColor.primary,
                            iconPath: Assets.icons.shoppingCart,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
