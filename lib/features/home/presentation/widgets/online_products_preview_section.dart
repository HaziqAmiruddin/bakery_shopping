import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/app_title_widget.dart';
import 'package:shopping_app/core/widgets/rate_widget.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/online_products_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/online_products_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/online_products_state.dart';
import 'package:shopping_app/features/home/presentation/pages/online_products_screen.dart';
import 'package:shopping_app/features/home/presentation/pages/product_details_screen.dart';
import 'package:shopping_app/features/home/presentation/widgets/product_image.dart';

class OnlineProductsPreviewSection extends StatefulWidget {
  const OnlineProductsPreviewSection({super.key});

  @override
  State<OnlineProductsPreviewSection> createState() =>
      _OnlineProductsPreviewSectionState();
}

class _OnlineProductsPreviewSectionState
    extends State<OnlineProductsPreviewSection> {
  final _scrollController = ScrollController();
  late final OnlineProductsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<OnlineProductsBloc>()..add(FetchInitialOnlineProducts());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _bloc.add(FetchMoreOnlineProducts());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnlineProductsBloc>.value(
      value: _bloc,
      child: BlocBuilder<OnlineProductsBloc, OnlineProductsState>(
        builder: (context, state) {
          if (state is OnlineProductsLoading) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is OnlineProductsError) {
            return const SizedBox.shrink();
          }

          if (state is OnlineProductsLoaded) {
            if (state.products.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTitleWidget(
                  title: 'Online products',
                  onPressed: () {
                    appPush(context, const OnlineProductsScreen());
                  },
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        state.products.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.products.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.largePadding,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      final product = state.products[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: Dimens.largePadding,
                        ),
                        child: InkWell(
                          onTap: () {
                            appPush(
                              context,
                              ProductDetailsScreen(product: product),
                            );
                          },
                          borderRadius: BorderRadius.circular(24),
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
                                    child: ProductImage(
                                      imagePath: product.image,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 24,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: Dimens.largePadding,
                                        vertical: Dimens.padding,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          Dimens.smallCorners,
                                        ),
                                        color: context
                                            .theme
                                            .scaffoldBackgroundColor,
                                      ),
                                      child: RateWidget(
                                        rate: product.rating.toStringAsFixed(2),
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
                                            context.theme.appColors.black
                                                .withValues(alpha: 0.4),
                                            context.theme.appColors.black
                                                .withValues(alpha: 0.7),
                                            context.theme.appColors.black
                                                .withValues(alpha: 0.8),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          product.name,
                                          style: context
                                              .theme
                                              .appTypography
                                              .titleSmall
                                              .copyWith(
                                                color: context
                                                    .theme
                                                    .appColors
                                                    .white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
