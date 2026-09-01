import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/utils/sized_context.dart';
import 'package:shopping_app/core/widgets/app_icon_button.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/core/widgets/rate_widget.dart';
import 'package:shopping_app/core/widgets/shaded_container.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/presentation/pages/product_details_screen.dart';
import 'package:shopping_app/features/home/presentation/pages/sort_and_filter_screen.dart';
import 'package:shopping_app/features/home/presentation/widgets/inline_search_field.dart';
import 'package:shopping_app/features/home/presentation/widgets/product_image.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    super.key,
    required this.products,
    required this.title,
    this.scrollController,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.onSearch,
  });

  final List<Product> products;
  final String title;
  final ScrollController? scrollController;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final Future<List<Product>> Function(String query)? onSearch;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchController = TextEditingController();
  late List<Product> _filteredProducts = widget.products;

  Timer? _debounce;
  bool _isSearching = false;
  bool _searchActive = false;

  @override
  void didUpdateWidget(covariant ProductsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Only re-sync with the incoming (paginated) list when not actively
    // showing remote search results — otherwise a background page-load
    // would silently overwrite the user's search results.
    if (!_searchActive && oldWidget.products != widget.products) {
      _filteredProducts = widget.products;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _searchActive = false;
        _isSearching = false;
        _filteredProducts = widget.products;
      });
      return;
    }

    if (widget.onSearch != null) {
      // Remote search mode — debounce, then search the FULL catalog.
      setState(() {
        _searchActive = true;
        _isSearching = true;
      });

      _debounce = Timer(const Duration(milliseconds: 350), () async {
        final results = await widget.onSearch!(query);
        if (!mounted) return;
        setState(() {
          _filteredProducts = results;
          _isSearching = false;
        });
      });
    } else {
      // Local instant filter mode — no network, no debounce needed.
      final q = query.trim().toLowerCase();
      setState(() {
        _searchActive = true;
        _filteredProducts = widget.products
            .where(
              (p) =>
                  p.name.toLowerCase().contains(q) ||
                  p.category.toLowerCase().contains(q),
            )
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    return AppScaffold(
      appBar: GeneralAppBar(
        title: widget.title,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.only(
              left: Dimens.largePadding,
              right: Dimens.largePadding,
            ),
            child: InlineSearchField(
              controller: _searchController,
              onChanged: _onQueryChanged,
              hintText: 'Search in ${widget.title}',
            ),
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
          if (_isSearching)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_filteredProducts.isEmpty)
            const Expanded(child: Center(child: Text('No products found.')))
          else
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: Dimens.largePadding,
                  crossAxisSpacing: Dimens.largePadding,
                  mainAxisExtent: 210,
                ),
                shrinkWrap: true,
                controller: _searchActive ? null : widget.scrollController,
                itemCount:
                    _filteredProducts.length +
                    (!_searchActive && widget.isLoadingMore ? 1 : 0),
                itemBuilder: (final context, final index) {
                  if (index >= _filteredProducts.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final product = _filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      appPush(context, ProductDetailsScreen(product: product));
                    },
                    child: ShadedContainer(
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
                                borderRadius: BorderRadius.circular(
                                  Dimens.corners,
                                ),
                                child: ProductImage(imagePath: product.image),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  spacing: Dimens.padding,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        style: context
                                            .theme
                                            .appTypography
                                            .titleSmall,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    RateWidget(rate: product.rating.toString()),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${product.discountedPrice.toStringAsFixed(2)}',
                                      style: context
                                          .theme
                                          .appTypography
                                          .labelLarge
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: AppIconButton(
                                        iconPath: Assets.icons.shoppingCart,
                                        backgroundColor: appColors.primary,
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                            AddToCartPressed(product),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${product.name} added to cart',
                                              ),
                                              duration: const Duration(
                                                seconds: 1,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
